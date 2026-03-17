(in-package #:cl-pdb)



(defun ingest (record)
  (case (record-type record)
    (:atom   (parse-atom record))
    (:hetatm (parse-hetatm record))
    (:het    (parse-het record))
    (otherwise nil)))
