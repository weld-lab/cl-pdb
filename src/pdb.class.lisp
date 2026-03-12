(in-package #:cl-pdb)


(defclass pdb ()
  ((pdb-title :initform ""
	      :accessor pdb-title)
   (pdb-sequence :initform '()
		 :accessor pdb-sequence)
   (pdb-chains :initform '()
	       :accessor pdb-chains)))
