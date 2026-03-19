(in-package #:cl-pdb)


(defclass seqres ()
  ((seqres-serial-number :initarg :seqres-serial-number
                         :initform nil
                         :accessor seqres-serial-number)
   (seqres-chain :initarg :seqres-chain
                 :initform nil
                 :accessor seqres-chain)
   (seqres-residue-count :initarg :seqres-residue-count
                         :initform nil
                         :accessor seqres-residue-count)
   (seqres-residue-names :initarg :seqres-residue-names
                         :initform '()
                         :accessor seqres-residue-names))
  (:documentation "Raw object representing one SEQRES record."))
