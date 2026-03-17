(in-package #:cl-pdb)



(defmethod residues-in-chain ((pdb pdb) chainID)
  (loop for residue in (pdb-residues pdb)
	when (string= chainID (residue-chain residue))
	collect residue))
