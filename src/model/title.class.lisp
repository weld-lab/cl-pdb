(in-package #:cl-pdb)



(defclass title ()
  ((title-content :initarg :title-content
		  :initform nil
		  :accessor title-content)))
