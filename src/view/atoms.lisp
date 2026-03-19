(in-package #:cl-pdb)


(defun atoms-of-residue (residue)
  (residue-atoms residue))


(defun atoms-in-chain (residues chainID)
  (loop for residue in residues
        when (string= chainID (residue-chain residue))
          append (residue-atoms residue)))


(defun atoms-of-kind (residues kind)
  (loop for residue in residues
        when (eql kind (residue-kind residue))
          append (residue-atoms residue)))
