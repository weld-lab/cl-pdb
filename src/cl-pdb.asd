(asdf:defsystem #:cl-pdb
  :author "weld (Erwan Le Doeuff)"
  :description "A package written in common lisp to handle .pdb files"
  :license "To be defined"
  :in-order-to ((test-op (test-op #:cl-pdb/tests)))
  :serial t
  :components ((:file "package")
	       (:file "pdb.class")))


(asdf:defsystem #:cl-pdb/tests
  :author "weld (Erwan Le Doeuff)"
  :description "Tests for cl-pdb"
  :license "To be defined"
  :serial t
  :depends-on ("cl-pdb" "fiveam")
  :components ((:file "tests/package")
	       (:file "tests/general"))
  :perform (test-op (o c)
	     (uiop:symbol-call :fiveam :run! :cl-pdb/tests.general)))

