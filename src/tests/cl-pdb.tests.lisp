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
    (is (string= "                        bla             "
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



(test create-atom-from-record-hetatm
  (let* ((record "HETATM11435  O1  CLR R 502     103.762 129.434 146.992  1.00 71.89           O  " )
         (atom   (pdb::parse-hetatm record)))
    ;; type global
    (is (typep atom 'pdb:atom))

    ;; valeurs
    (is (string= " O1 " (pdb:atom-name atom)))
    (is (string= "11435" (pdb:atom-serial atom)))
    (is (string= "CLR"   (pdb:atom-residue-name atom)))
    (is (string= "R"     (pdb:atom-residue-chain atom)))
    (is (= 502           (pdb:atom-residue-sequence-number atom)))
    (is (null            (pdb:atom-residue-insertion-code atom)))
    (is (= 103.762       (pdb:atom-x atom)))
    (is (= 129.434       (pdb:atom-y atom)))
    (is (= 146.992       (pdb:atom-z atom)))
    (is (string= " O"    (pdb:atom-element atom)))
    (is (null            (pdb:atom-charge atom)))

    ;; types
    (is (typep (pdb:atom-name atom) 'string))
    (is (typep (pdb:atom-serial atom) 'string))
    (is (typep (pdb:atom-residue-name atom) 'string))
    (is (typep (pdb:atom-residue-chain atom) 'string))
    (is (typep (pdb:atom-residue-sequence-number atom) 'integer))
    (is (null  (pdb:atom-residue-insertion-code atom)))
    (is (floatp (pdb:atom-x atom)))
    (is (floatp (pdb:atom-y atom)))
    (is (floatp (pdb:atom-z atom)))
    (is (typep (pdb:atom-element atom) 'string))
    (is (null   (pdb:atom-charge atom)))))


(test create-atom-from-record-atom
  (let* ((record "ATOM   3201  CG  ARG A 242     128.003 125.608 196.380  1.00109.17           C  ")
         (atom   (pdb::parse-atom record)))
    ;; type global
    (is (typep atom 'pdb:atom))

    ;; valeurs
    (is (string= " CG " (pdb:atom-name atom)))
    (is (string= " 3201" (pdb:atom-serial atom)))
    (is (string= "ARG"   (pdb:atom-residue-name atom)))
    (is (string= "A"     (pdb:atom-residue-chain atom)))
    (is (= 242           (pdb:atom-residue-sequence-number atom)))
    (is (null            (pdb:atom-residue-insertion-code atom)))
    (is (= 128.003       (pdb:atom-x atom)))
    (is (= 125.608       (pdb:atom-y atom)))
    (is (= 196.380       (pdb:atom-z atom)))
    (is (string= " C"    (pdb:atom-element atom)))
    (is (null            (pdb:atom-charge atom)))

    ;; types
    (is (typep (pdb:atom-name atom) 'string))
    (is (typep (pdb:atom-serial atom) 'string))
    (is (typep (pdb:atom-residue-name atom) 'string))
    (is (typep (pdb:atom-residue-chain atom) 'string))
    (is (typep (pdb:atom-residue-sequence-number atom) 'integer))
    (is (null  (pdb:atom-residue-insertion-code atom)))
    (is (floatp (pdb:atom-x atom)))
    (is (floatp (pdb:atom-y atom)))
    (is (floatp (pdb:atom-z atom)))
    (is (typep (pdb:atom-element atom) 'string))
    (is (null   (pdb:atom-charge atom)))))
