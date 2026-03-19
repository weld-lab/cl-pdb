(asdf:defsystem #:cl-pdb
  :author "weld (Erwan Le Doeuff)"
  :description "A package written in common lisp to handle .pdb files"
  :license "To be defined"
  :in-order-to ((test-op (test-op #:cl-pdb/tests)))
  :serial t
  :components ((:file "package")
	       (:file "model/atom.class")
	       (:file "model/residue.class")
	       (:file "model/title.class")
	       (:file "model/seqres.class")
	       (:file "model/pdb.class")
	       (:file "parse/common")
	       (:file "parse/title")
	       (:file "parse/atom")
	       (:file "parse/het")
	       (:file "parse/hetatm")
	       (:file "parse/seqres")
	       (:file "reader/ingest")
	       (:file "reader/build")
	       (:file "reader/finalize")
	       (:file "reader/read-pdb")
	       (:file "normalize/residue-kind")
	       (:file "view/atoms")
	       (:file "view/heteros")
	       (:file "view/residues")
	       (:file "view/in-chain")
	       (:file "view/of-kind")
	       (:file "writer/write-pdb")))


(asdf:defsystem #:cl-pdb/tests
  :author "weld (Erwan Le Doeuff)"
  :description "Tests for cl-pdb"
  :license "To be defined"
  :serial t
  :depends-on ("cl-pdb" "fiveam")
  :components ((:file "tests/package")
	       (:file "tests/parse")
	       (:file "tests/reader"))
  :perform (test-op (o c)
	     (uiop:symbol-call :fiveam :run! :cl-pdb.tests)))

