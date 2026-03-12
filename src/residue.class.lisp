(in-package #:cl-pdb)


(defclass residue ()
  ;; kind c'est le type "métier"
  ;; "structural" ; par exemple, :water, :ligand, :amino-acid, :other
  ;; mais pas un kind chimique :CLR
  ;; faudra faire une normalisation pour attribuer les kind
  ((kind :initarg :kind
	 :initform :unknown
	 :accessor residue-kind)))
