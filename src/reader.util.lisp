(in-package #:cl-pdb)


(defparameter *test-file*
  (merge-pathnames (pathname "git/cl-pdb/src/8ef5.pdb")))


(defmacro is-record-type (str)
  `(equalp record-type ,str))


(defun parse-remark (remark)
  (print remark))


(defun parse-hetatm (hetatm)
  (print hetatm))


(defun parse-record (record)
  (let ((record-type (subseq record 0 6)))
    (cond
      ((is-record-type "REMARK") (parse-remark record))
      ((is-record-type "HETATM") (parse-hetatm record))
      (t nil))))


(defun reader (pathname)
  ;; should give back a pdb object
  (with-open-file (file pathname)
    (loop for record = (read-line file nil)
	  while record
	  do (parse-record record))))
