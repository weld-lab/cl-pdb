(in-package #:cl-pdb/tests)


(5am:in-suite :cl-pdb.tests)


(test create-residue-from-record-het
  (let* ((record   "HET    7V7  R 501      25                             bla                       ")
	 (residue (pdb::parse-het record)))
    (is (equalp "7V7" (residue-name residue)))))
