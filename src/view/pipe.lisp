(in-package #:cl-pdb)


(defmacro pipe (pdb &body forms)
  `(let ((it (pdb-residues ,pdb)))
     ,@(mapcar (lambda (form)
                 `(setf it ,form))
               forms)
     it))
