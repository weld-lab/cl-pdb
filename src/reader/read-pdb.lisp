(in-package #:cl-pdb)

;; read-pdb
;;   -> lit les lignes
;;   -> ingest chaque ligne en un objet brut ou nil
;;   -> build reconstruit à partir de la liste
;;   -> finalize normalise etc.

(defun read-pdb (pathname)
  (with-open-file (file pathname :direction :input)
    (loop for record = (read-line file nil)
	  while record collect (ingest record) into ingested
	  finally (return (finalize (build ingested))))))

