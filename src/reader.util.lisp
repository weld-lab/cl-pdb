(in-package #:cl-pdb)


(defparameter *test-file*
  (merge-pathnames (pathname "git/cl-pdb/src/8ef5.pdb")))

(defparameter *test-het*
  "HET    7V7  R 501      25                             bla                       ")

(defparameter *test-atom*
  "ATOM   3201  CG  ARG A 242     128.003 125.608 196.380  1.00109.17           C  ")




; utils

(defun trim-or-nil (str)
  (let ((s (string-trim '(#\Space #\Tab #\Newline) str)))
    (unless (string= s "")
      s)))


(defun parse-float (str)
  (let ((str (trim-or-nil str)))
    (if (null str)
	nil
	(car (multiple-value-list (read-from-string str))))))


(defun parse-het (het)
;;; HET record
;;; 1-6    : record name ("HET")
;;; 8-10   : hetID       -- het identifier, right-justified
;;; 13     : chainID     -- chain identifier
;;; 14-17  : seqNum      -- sequence number
;;; 18     : iCode       -- insertion code                         
;;; 21-25  : numHetAtoms -- number of HETATM records for this group       MISSING
;;; 31-70  : text        -- text describing the het group
  (let ((hetID (subseq het 7 10))
	(chainID (subseq het 12 13))
	(seqNum (parse-integer (subseq het 13 17)))
	(iCode (trim-or-nil (subseq het 17 18)))
	(text (subseq het 30 70)))
    (make-instance 'residue
		   :residue-name hetID
		   :residue-sequence-number seqNum
		   :residue-insertion-code iCode
		   :residue-chain chainID
		   :residue-kind :unknown
		   :residue-additional-informations text)))


(defun parse-atom (atom)
;;; ATOM record
;;; 1-6    : record name ("ATOM")
;;; 7-11   : serial     -- atom serial number
;;; 13-16  : name       -- atom name
;;; 17     : altLoc     -- alternate location indicator               MISSING
;;; 18-20  : resName    -- residue name
;;; 22     : chainID    -- chain identifier
;;; 23-26  : resSeq     -- residue sequence number
;;; 27     : iCode      -- insertion code
;;; 31-38  : x          -- orthogonal X coordinate in angstroms
;;; 39-46  : y          -- orthogonal Y coordinate in angstroms
;;; 47-54  : z          -- orthogonal Z coordinate in angstroms
;;; 55-60  : occupancy  -- occupancy                                  MISSING
;;; 61-66  : tempFactor -- temperature factor                         MISSING
;;; 77-78  : element    -- element symbol, right-justified            MISSING
;;; 79-80  : charge     -- atom charge
  (let ((serial (subseq atom 6 11))
	(name (subseq atom 12 16))
	(resname (subseq atom 17 20))
	(chainID (subseq atom 21 22))
	(resSeq (parse-integer (subseq atom 22 26)))
	(iCode (trim-or-nil (subseq atom 26 27)))
	(x (parse-float (subseq atom 30 38)))
	(y (parse-float (subseq atom 38 46)))
	(z (parse-float (subseq atom 46 54)))
	(charge (parse-float (subseq atom 78 80))))
    (make-instance 'atom
		   :atom-name name
		   :atom-serial serial
		   :atom-residue-name resname
		   :atom-residue-chain chainID
		   :atom-residue-sequence-number resSeq
		   :atom-residue-insertion-code iCode
		   :atom-x x :atom-y y :atom-z z
		   :atom-charge charge)))

(defun parse-remark (remark)
  nil)


(defun parse-hetatm (hetatm)
  nil)


(defmacro is-record-type (str)
  `(equalp record-type ,str))

(defun parse-record (pdb record)
  (let ((record-type (subseq record 0 6)))
    (cond
      ((is-record-type "ATOM  ") (parse-atom record))
      ((is-record-type "HET   ") (push (parse-het record) (pdb-residues pdb)))
      ((is-record-type "REMARK") (parse-remark record))
      ((is-record-type "HETATM") (parse-hetatm record))
      (t nil))))


(defun reader (pathname)
  ;; should give back a pdb object
  (let ((pdb (make-instance 'pdb)))
    (with-open-file (file pathname)
      (loop for record = (read-line file nil)
	    while record
	    do (parse-record pdb record)))
    pdb))
