(in-package #:cl-pdb/tests)


(5am:in-suite :cl-pdb.tests)


(test create-residue-from-record-het
  (let* ((record "HET    7V7  R 501      25                             bla                       ")
         (residue (pdb::parse-het record)))
    ;; type global
    (is (typep residue 'pdb:residue))

    ;; valeurs
    (is (string= "7V7" (pdb:residue-name residue)))
    (is (null (pdb:residue-id residue)))
    (is (= 501 (pdb:residue-sequence-number residue)))
    (is (null (pdb:residue-insertion-code residue)))
    (is (string= "R" (pdb:residue-chain residue)))
    (is (eql :unknown (pdb:residue-kind residue)))
    (is (equal '() (pdb:residue-atoms residue)))
    (is (string= "bla                       "
                 (pdb:residue-additional-informations residue)))

    ;; types des slots
    (is (typep (pdb:residue-name residue) 'string))
    (is (null (pdb:residue-id residue)))
    (is (typep (pdb:residue-sequence-number residue) 'integer))
    (is (null (pdb:residue-insertion-code residue)))
    (is (typep (pdb:residue-chain residue) 'string))
    (is (typep (pdb:residue-kind residue) 'keyword))
    (is (typep (pdb:residue-atoms residue) 'list))
    (is (typep (pdb:residue-additional-informations residue) 'string))))
