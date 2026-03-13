(in-package #:cl-pdb)


(defun trim-or-nil (str)
  (let ((s (string-trim '(#\Space #\Tab #\Newline) str)))
    (unless (string= s "")
      s)))

(defun parse-float (str)
  (let ((str (trim-or-nil str)))
    (if (null str)
	nil
	(car (multiple-value-list (read-from-string str))))))

