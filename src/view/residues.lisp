(in-package #:cl-pdb)



(defun residues-in-chain (residues chainID)
  (loop for residue in residues
	when (string= chainID (residue-chain residue))
	collect residue))


(defun residues-of-kind (residues kind)
  (loop for residue in residues
	when (eql kind (residue-kind residue))
	collect residue))


(defun residues-named (residues name)
  (loop for residue in residues
        when (string= name (residue-name residue))
          collect residue))

(defun hetero-residues (residues)
  (loop for residue in residues
        when (eql :hetero (residue-type residue))
        collect residue))

(defun unknown-residues (residues)
  (loop for residue in residues
        when (eql :unknown (residue-kind residue))
        collect residue))
