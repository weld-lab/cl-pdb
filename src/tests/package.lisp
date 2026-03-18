(defpackage #:cl-pdb/tests
  (:use #:cl #:fiveam #:cl-pdb)
  (:shadow #:atom))


(in-package #:cl-pdb/tests)


(5am:def-suite :cl-pdb.tests)
(5am:def-suite :cl-pdb.tests.parse :in :cl-pdb.tests)
(5am:def-suite :cl-pdb.tests.reader :in :cl-pdb.tests)
