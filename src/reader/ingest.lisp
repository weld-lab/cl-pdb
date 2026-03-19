(in-package #:cl-pdb)



(defun ingest (record)
  (case (record-type record)
    (:title (parse-title record))
    (:atom   (parse-atom record))
    (:hetatm (parse-hetatm record))
    (:het    (parse-het record))
    (:seqres (parse-seqres record))
    (otherwise nil)))
