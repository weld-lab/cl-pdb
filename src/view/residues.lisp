(in-package #:cl-pdb)



(defun residues-in-chain (residues chainID)
  (loop for residue in residues
	when (string= chainID (residue-chain residue))
	collect residue))


(defun residues-of-kind (residues kind)
  (loop for residue in residues
	when (eql kind (residue-kind residue))
	collect residue))
