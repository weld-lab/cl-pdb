(in-package #:cl-pdb)



(defun parse-seqres (record)
;;; SEQRES record
;;; 1-6    : record name    ("SEQRES")
;;; 9-10   : serNum         -- serial number of the SEQRES record for the chain
;;; 12     : chainID        -- chain identifier
;;; 14-17  : numRes         -- number of residues in the chain
;;; 20-22  : resName        -- residue name
;;; 24-26  : resName        -- residue name
;;; 28-30  : resName        -- residue name
;;; 32-34  : resName        -- residue name
;;; 36-38  : resName        -- residue name
;;; 40-42  : resName        -- residue name
;;; 44-46  : resName        -- residue name
;;; 48-50  : resName        -- residue name
;;; 52-54  : resName        -- residue name
;;; 56-58  : resName        -- residue name
;;; 60-62  : resName        -- residue name
;;; 64-66  : resName        -- residue name
;;; 68-70  : resName        -- residue name
  (let* ((serial-number (parse-integer (subseq record 8 10)))
         (chain         (trim-or-nil (subseq record 11 12)))
         (residue-count (parse-integer (subseq record 13 17)))
         (residue-names
           (loop for start from 19 below (min 70 (length record)) by 4
                 for end = (min (+ start 3) (length record))
                 for name = (trim-or-nil (subseq record start end))
                 when name collect name)))
    (make-instance 'seqres
                   :seqres-serial-number serial-number
                   :seqres-chain chain
                   :seqres-residue-count residue-count
                   :seqres-residue-names residue-names)))
