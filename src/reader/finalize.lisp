(in-package #:cl-pdb)


(defmethod finalize ((pdb pdb))
  (loop for residue in (pdb-residues pdb)
        do (setf (residue-kind residue)
                 (infer-residue-kind residue)))
  pdb)
