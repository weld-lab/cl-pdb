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



(defun record-type (line)
  (let ((tag (trim-or-nil (subseq line 0 6))))
    (cond
      ((string= tag "ATOM")   :atom)
      ((string= tag "HETATM") :hetatm)
      ((string= tag "HET")    :het)
      ((string= tag "TITLE")  :title)
      ((string= tag "REMARK") :remark)
      ((string= tag "SEQRES") :seqres)
      ((string= tag "HEADER") :header)
      (t nil))))
