(in-package #:cl-pdb)



(defmethod residues-of-kind ((pdb pdb) kind)
  (loop for residue in (pdb-residues pdb)
	when (eql kind (residue-kind residue))
	collect residue))
