(in-package #:cl-pdb)


(defparameter *water-names*
  '("HOH" "WAT" "H2O"))

(defparameter *amino-acid-names*
  '("ALA" "ARG" "ASN" "ASP" "CYS" "GLN" "GLU" "GLY"
    "HIS" "ILE" "LEU" "LYS" "MET" "PHE" "PRO" "SER"
    "THR" "TRP" "TYR" "VAL"))

(defparameter *ion-names*
  '("NA" "K" "CL" "CA" "MG" "ZN"))


(defparameter *lipid-names*
  '("CLR"))


(defun infer-residue-kind (residue)
  (macrolet ((in? (category)
	       `(member name ,category :test #'string=)))
    (let ((name (string-upcase (residue-name residue))))
      (cond
	((in? *water-names* ) :water)
	((in? *amino-acid-names*) :amino-acid)
	((in? *ion-names*) :ion)
	((in? *lipid-names*) :lipid)
	(t :unknown)))))
