(in-package #:cl-pdb)


(defparameter *test-file*
  (merge-pathnames (pathname "git/cl-pdb/src/8ef5.pdb")))

(defparameter *test-het*
  "HET    7V7  R 501      25                                                       ")


(defmacro is-record-type (str)
  `(equalp record-type ,str))


(defun parse-het (het)
  ;;; HET record
  ;;; 1-6    : record name ("HET")
  ;;; 8-10   : hetID       -- het identifier, right-justified
  ;;; 13     : chainID     -- chain identifier
  ;;; 14-17  : seqNum      -- sequence number
  ;;; 18     : iCode       -- insertion code
  ;;; 21-25  : numHetAtoms -- number of HETATM records for this group
  ;;; 31-70  : text        -- text describing the het group
  (let ((hetID (subseq het 7 10))
	(chainID (subseq het 12 13))
	(seqNum (parse-integer (subseq het 13 17))))
    (make-instance 'residue
		   :residue-name hetID
		   :residue-id seqNum
		   :residue-chain chainID
		   :residue-kind :unknown)))

(defun parse-remark (remark)
  nil)

(defun parse-hetatm (hetatm)
  nil)


(defun parse-record (record)
  (let ((record-type (subseq record 0 6)))
    (let  ((things '()))
      (cond
	((is-record-type "HET   ") (push (parse-het record) things))
	((is-record-type "REMARK") (parse-remark record))
	((is-record-type "HETATM") (parse-hetatm record))
	(t nil))
      things)))


(defun reader (pathname)
  ;; should give back a pdb object
  (with-open-file (file pathname)
    (loop for record = (read-line file nil)
	  while record
	  do (parse-record record))))
