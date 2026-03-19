(in-package #:cl-pdb)


(defmacro pipe (initial-value &body forms)
  `(let ((it ,initial-value))
     ,@(mapcar (lambda (form)
                 `(setf it ,form))
               forms)
     it))


(defmacro pipe-residues (pdb &body forms)
  `(pipe (pdb-residues ,pdb)
     ,@forms))


(defmacro pipe-atoms (pdb &body forms)
  `(pipe (loop for residue in (pdb-residues ,pdb)
               append (residue-atoms residue))
     ,@forms))
