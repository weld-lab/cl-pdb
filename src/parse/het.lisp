(in-package #:cl-pdb)


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
