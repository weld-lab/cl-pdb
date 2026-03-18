(in-package #:cl-pdb)


(defclass pdb ()
  ((pdb-title :initform ""
	      :initarg :pdb-title
	      :accessor pdb-title)
   (pdb-sequence :initform '()
		 :initarg :pdb-sequence
		 :accessor pdb-sequence)
   (pdb-residues :initform '()
		 :initarg :pdb-residues
		 :accessor pdb-residues)))



