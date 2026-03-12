(in-package #:cl-pdb)


(defclass pdb ()
  ((pdb-sequence :initform '()
		 :accessor pdb-sequence))
  ((pdb-residues :initform '()
		 :accessor pdb-residues)))


(defmacro make-pdb ()
  `(make-instance 'pdb))
