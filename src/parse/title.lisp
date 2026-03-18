(in-package #:cl-pdb)


(defun parse-title (record)
;;; TITLE record
;;; 1-6    : record name  ("TITLE")
;;; 9-10   : continuation -- allows concatenation of multiple records    MISSING
;;; 11-80  : title        -- title of the experiment
  (let ((content (subseq record 10 80)))
    (make-instance 'title
		   :title-content content)))
