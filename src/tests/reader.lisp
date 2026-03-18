(in-package #:cl-pdb/tests)


(5am:in-suite :cl-pdb.tests.reader)


(test ingest/atom-record-returns-atom
  (let* ((record "ATOM      1  N   ASP A  29     -52.822  -1.611  23.137  1.00 98.48           N  ")
         (object (pdb::ingest record)))
    (is (typep object 'pdb:atom))
    (is (string= "N"   (pdb:atom-name object)))
    (is (string= "ASP" (pdb:atom-residue-name object)))
    (is (string= "A"   (pdb:atom-residue-chain object)))
    (is (= 29          (pdb:atom-residue-sequence-number object)))
    (is (= -52.822     (pdb:atom-x object)))
    (is (= -1.611      (pdb:atom-y object)))
    (is (= 23.137      (pdb:atom-z object)))
    (is (string= "N"   (pdb:atom-element object)))))


(test ingest/hetatm-record-returns-atom
  (let* ((record "HETATM11435  O1  CLR R 502     103.762 129.434 146.992  1.00 71.89           O  ")
         (object (pdb::ingest record)))
    (is (typep object 'pdb:atom))
    (is (string= "O1"  (pdb:atom-name object)))
    (is (string= "CLR" (pdb:atom-residue-name object)))
    (is (string= "R"   (pdb:atom-residue-chain object)))
    (is (= 502         (pdb:atom-residue-sequence-number object)))
    (is (= 103.762     (pdb:atom-x object)))
    (is (= 129.434     (pdb:atom-y object)))
    (is (= 146.992     (pdb:atom-z object)))
    (is (string= "O"   (pdb:atom-element object)))))


(test ingest/het-record-returns-residue
  (let* ((record "HET    CLR  A 412      28                                                        ")
         (object (pdb::ingest record)))
    (is (typep object 'pdb:residue))
    (is (string= "CLR" (pdb:residue-name object)))
    (is (= 412        (pdb:residue-sequence-number object)))
    (is (string= "A"  (pdb:residue-chain object)))
    (is (null         (pdb:residue-insertion-code object)))
    (is (eql :unknown (pdb:residue-kind object)))
    (is (equal '()    (pdb:residue-atoms object)))
    (is (typep (pdb:residue-additional-informations object) 'string))))


(test ingest/title-record-returns-title
  (let* ((record "TITLE     FENTANYL-BOUND MU-OPIOID RECEPTOR-GI COMPLEX                          ")
         (object (pdb::ingest record)))
    (is (typep object 'pdb::title))
    (is (string= "FENTANYL-BOUND MU-OPIOID RECEPTOR-GI COMPLEX                          " (pdb::title-content object)))))


(test ingest/title-second-line-returns-title
  (let* ((record "TITLE    2 BOUND TO AN ENGINEERED G PROTEIN                                     ")
         (object (pdb::ingest record)))
    (is (typep object 'pdb::title))
    (is (string= " BOUND TO AN ENGINEERED G PROTEIN                                     "
                 (pdb::title-content object)))))


(test ingest/remark-record-returns-nil
  (let ((record "REMARK   3  REFINEMENT.                                                          "))
    (is (null (pdb::ingest record)))))


(test ingest/header-record-returns-nil
  (let ((record "HEADER    SIGNALING PROTEIN                       08-SEP-22   8EF5              "))
    (is (null (pdb::ingest record)))))


(test ingest/seqres-record-returns-nil
  (let ((record "SEQRES   1 A  500  ASP TYR LYS ASP ASP ASP ALA MET GLY GLN PRO GLY ASN          "))
    (is (null (pdb::ingest record)))))


(test ingest/unknown-record-returns-nil
  (let ((record "FOOBAR    SOMETHING THAT SHOULD NOT MATCH                                          "))
    (is (null (pdb::ingest record)))))


(test ingest/blank-record-returns-nil
  (let ((record "                                                                                "))
    (is (null (pdb::ingest record)))))


(test ingest/atom-record-preserves-atom-type
  (let* ((record "ATOM   3201  CG  ARG A 242     128.003 125.608 196.380  1.00109.17           C  ")
         (object (pdb::ingest record)))
    (is (typep object 'pdb:atom))
    (is (string= "CG"  (pdb:atom-name object)))
    (is (string= "ARG" (pdb:atom-residue-name object)))
    (is (= 242         (pdb:atom-residue-sequence-number object)))
    (is (= 128.003     (pdb:atom-x object)))
    (is (= 125.608     (pdb:atom-y object)))
    (is (= 196.380     (pdb:atom-z object)))
    (is (string= "C"   (pdb:atom-element object)))))


(test ingest/hetatm-record-goes-through-parse-atom-shape
  (let* ((record "HETATM 3722  C2  PLM A 415     -58.012  31.828   5.279  1.00 93.74           C  ")
         (object (pdb::ingest record)))
    (is (typep object 'pdb:atom))
    (is (string= "C2"  (pdb:atom-name object)))
    (is (string= "PLM" (pdb:atom-residue-name object)))
    (is (string= "A"   (pdb:atom-residue-chain object)))
    (is (= 415         (pdb:atom-residue-sequence-number object)))
    (is (null          (pdb:atom-residue-insertion-code object)))
    (is (string= "C"   (pdb:atom-element object)))))


(test ingest/het-record-preserves-free-text
  (let* ((record "HET    7V7  R 501      25                             bla                       ")
         (object (pdb::ingest record)))
    (is (typep object 'pdb:residue))
    (is (string= "7V7" (pdb:residue-name object)))
    (is (= 501        (pdb:residue-sequence-number object)))
    (is (string= "R"  (pdb:residue-chain object)))
    (is (string= "                        bla             "
                 (pdb:residue-additional-informations object)))))


(test ingest/title-object-has-string-content
  (let* ((record "TITLE     HIGH RESOLUTION CRYSTAL STRUCTURE OF HUMAN B2-ADRENERGIC G PROTEIN-   ")
         (object (pdb::ingest record)))
    (is (typep object 'pdb::title))
    (is (typep (pdb::title-content object) 'string))))


(test residue-key/builds-structural-key
  (is (equal '("A" 42 nil "ALA")
             (pdb::residue-key "A" 42 nil "ALA"))))


(test key-from-atom/builds-key-from-atom-slots
  (let ((atom (make-instance 'pdb:atom
                             :atom-name "CA"
                             :atom-serial "1"
                             :atom-residue-name "ALA"
                             :atom-residue-chain "A"
                             :atom-residue-sequence-number 42
                             :atom-residue-insertion-code nil
                             :atom-x 1.0
                             :atom-y 2.0
                             :atom-z 3.0
                             :atom-element "C"
                             :atom-charge nil)))
    (is (equal '("A" 42 nil "ALA")
               (pdb::key-from-atom atom)))))


(test key-from-residue/builds-key-from-residue-slots
  (let ((residue (make-instance 'pdb:residue
                                :residue-name "ALA"
                                :residue-sequence-number 42
                                :residue-insertion-code nil
                                :residue-chain "A"
                                :residue-kind :unknown
                                :residue-atoms '()
                                :residue-additional-informations nil)))
    (is (equal '("A" 42 nil "ALA")
               (pdb::key-from-residue residue)))))


(test ensure-residue/creates-new-residue-from-atom
  (let* ((index (make-hash-table :test #'equal))
         (order '())
         (atom (make-instance 'pdb:atom
                              :atom-name "CA"
                              :atom-serial "1"
                              :atom-residue-name "ALA"
                              :atom-residue-chain "A"
                              :atom-residue-sequence-number 42
                              :atom-residue-insertion-code nil
                              :atom-x 1.0
                              :atom-y 2.0
                              :atom-z 3.0
                              :atom-element "C"
                              :atom-charge nil)))
    (multiple-value-bind (residue new-order)
        (pdb::ensure-residue atom index order)
      (is (typep residue 'pdb:residue))
      (is (string= "ALA" (pdb:residue-name residue)))
      (is (= 42 (pdb:residue-sequence-number residue)))
      (is (string= "A" (pdb:residue-chain residue)))
      (is (null (pdb:residue-insertion-code residue)))
      (is (equal (list residue) new-order))
      (is (eq residue (gethash '("A" 42 nil "ALA") index))))))


(test ensure-residue/reuses-existing-residue-from-second-atom
  (let* ((index (make-hash-table :test #'equal))
         (order '())
         (atom-1 (make-instance 'pdb:atom
                                :atom-name "N"
                                :atom-serial "1"
                                :atom-residue-name "ALA"
                                :atom-residue-chain "A"
                                :atom-residue-sequence-number 42
                                :atom-residue-insertion-code nil
                                :atom-x 1.0 :atom-y 2.0 :atom-z 3.0
                                :atom-element "N"
                                :atom-charge nil))
         (atom-2 (make-instance 'pdb:atom
                                :atom-name "CA"
                                :atom-serial "2"
                                :atom-residue-name "ALA"
                                :atom-residue-chain "A"
                                :atom-residue-sequence-number 42
                                :atom-residue-insertion-code nil
                                :atom-x 4.0 :atom-y 5.0 :atom-z 6.0
                                :atom-element "C"
                                :atom-charge nil)))
    (multiple-value-bind (residue-1 order-1)
        (pdb::ensure-residue atom-1 index order)
      (multiple-value-bind (residue-2 order-2)
          (pdb::ensure-residue atom-2 index order-1)
        (is (eq residue-1 residue-2))
        (is (equal order-1 order-2))
        (is (= 1 (hash-table-count index)))))))


(test ensure-residue/inserts-raw-residue-as-is
  (let* ((index (make-hash-table :test #'equal))
         (order '())
         (residue (make-instance 'pdb:residue
                                 :residue-name "CLR"
                                 :residue-sequence-number 412
                                 :residue-insertion-code nil
                                 :residue-chain "A"
                                 :residue-kind :unknown
                                 :residue-atoms '()
                                 :residue-additional-informations "cholesterol")))
    (multiple-value-bind (found new-order)
        (pdb::ensure-residue residue index order)
      (is (eq found residue))
      (is (equal (list residue) new-order))
      (is (eq residue (gethash '("A" 412 nil "CLR") index))))))


(test ensure-residue/reuses-existing-residue-when-same-raw-residue-key
  (let* ((index (make-hash-table :test #'equal))
         (order '())
         (residue-1 (make-instance 'pdb:residue
                                   :residue-name "CLR"
                                   :residue-sequence-number 412
                                   :residue-insertion-code nil
                                   :residue-chain "A"
                                   :residue-kind :unknown
                                   :residue-atoms '()
                                   :residue-additional-informations "first"))
         (residue-2 (make-instance 'pdb:residue
                                   :residue-name "CLR"
                                   :residue-sequence-number 412
                                   :residue-insertion-code nil
                                   :residue-chain "A"
                                   :residue-kind :unknown
                                   :residue-atoms '()
                                   :residue-additional-informations "second")))
    (multiple-value-bind (found-1 order-1)
        (pdb::ensure-residue residue-1 index order)
      (multiple-value-bind (found-2 order-2)
          (pdb::ensure-residue residue-2 index order-1)
        (is (eq found-1 residue-1))
        (is (eq found-2 residue-1))
        (is (equal order-1 order-2))
        (is (= 1 (hash-table-count index)))))))


(test ensure-residue/signals-error-on-unsupported-object
  (let ((index (make-hash-table :test #'equal))
        (order '()))
    (signals error
      (pdb::ensure-residue 42 index order))))


(test build/returns-empty-pdb-on-empty-ingested
  (let ((pdb (pdb::build '())))
    (is (typep pdb 'pdb:pdb))
    (is (string= "" (pdb:pdb-title pdb)))
    (is (null (pdb:pdb-sequence pdb)))
    (is (equal '() (pdb:pdb-residues pdb)))))


(test build/ignores-nil-objects
  (let* ((atom (make-instance 'pdb:atom
                              :atom-name "CA"
                              :atom-serial "1"
                              :atom-residue-name "ALA"
                              :atom-residue-chain "A"
                              :atom-residue-sequence-number 42
                              :atom-residue-insertion-code nil
                              :atom-x 1.0 :atom-y 2.0 :atom-z 3.0
                              :atom-element "C"
                              :atom-charge nil))
         (pdb (pdb::build (list nil atom nil))))
    (is (= 1 (length (pdb:pdb-residues pdb))))
    (is (= 1 (length (pdb:residue-atoms (first (pdb:pdb-residues pdb))))))))


(test build/groups-two-atoms-into-one-residue
  (let* ((atom-1 (make-instance 'pdb:atom
                                :atom-name "N"
                                :atom-serial "1"
                                :atom-residue-name "ALA"
                                :atom-residue-chain "A"
                                :atom-residue-sequence-number 42
                                :atom-residue-insertion-code nil
                                :atom-x 1.0 :atom-y 2.0 :atom-z 3.0
                                :atom-element "N"
                                :atom-charge nil))
         (atom-2 (make-instance 'pdb:atom
                                :atom-name "CA"
                                :atom-serial "2"
                                :atom-residue-name "ALA"
                                :atom-residue-chain "A"
                                :atom-residue-sequence-number 42
                                :atom-residue-insertion-code nil
                                :atom-x 4.0 :atom-y 5.0 :atom-z 6.0
                                :atom-element "C"
                                :atom-charge nil))
         (pdb (pdb::build (list atom-1 atom-2)))
         (residues (pdb:pdb-residues pdb))
         (residue (first residues))
         (atoms (pdb:residue-atoms residue)))
    (is (= 1 (length residues)))
    (is (= 2 (length atoms)))
    (is (string= "N"  (pdb:atom-name (first atoms))))
    (is (string= "CA" (pdb:atom-name (second atoms))))))


(test build/creates-two-residues-for-different-keys
  (let* ((atom-1 (make-instance 'pdb:atom
                                :atom-name "N"
                                :atom-serial "1"
                                :atom-residue-name "ALA"
                                :atom-residue-chain "A"
                                :atom-residue-sequence-number 42
                                :atom-residue-insertion-code nil
                                :atom-x 1.0 :atom-y 2.0 :atom-z 3.0
                                :atom-element "N"
                                :atom-charge nil))
         (atom-2 (make-instance 'pdb:atom
                                :atom-name "N"
                                :atom-serial "2"
                                :atom-residue-name "GLY"
                                :atom-residue-chain "A"
                                :atom-residue-sequence-number 43
                                :atom-residue-insertion-code nil
                                :atom-x 4.0 :atom-y 5.0 :atom-z 6.0
                                :atom-element "N"
                                :atom-charge nil))
         (pdb (pdb::build (list atom-1 atom-2)))
         (residues (pdb:pdb-residues pdb)))
    (is (= 2 (length residues)))
    (is (string= "ALA" (pdb:residue-name (first residues))))
    (is (string= "GLY" (pdb:residue-name (second residues))))))


(test build/preserves-residue-order-from-first-appearance
  (let* ((atom-1 (make-instance 'pdb:atom
                                :atom-name "N"
                                :atom-serial "1"
                                :atom-residue-name "GLY"
                                :atom-residue-chain "A"
                                :atom-residue-sequence-number 10
                                :atom-residue-insertion-code nil
                                :atom-x 1.0 :atom-y 2.0 :atom-z 3.0
                                :atom-element "N"
                                :atom-charge nil))
         (atom-2 (make-instance 'pdb:atom
                                :atom-name "N"
                                :atom-serial "2"
                                :atom-residue-name "ALA"
                                :atom-residue-chain "A"
                                :atom-residue-sequence-number 11
                                :atom-residue-insertion-code nil
                                :atom-x 4.0 :atom-y 5.0 :atom-z 6.0
                                :atom-element "N"
                                :atom-charge nil))
         (atom-3 (make-instance 'pdb:atom
                                :atom-name "CA"
                                :atom-serial "3"
                                :atom-residue-name "GLY"
                                :atom-residue-chain "A"
                                :atom-residue-sequence-number 10
                                :atom-residue-insertion-code nil
                                :atom-x 7.0 :atom-y 8.0 :atom-z 9.0
                                :atom-element "C"
                                :atom-charge nil))
         (pdb (pdb::build (list atom-1 atom-2 atom-3)))
         (residues (pdb:pdb-residues pdb)))
    (is (= 2 (length residues)))
    (is (string= "GLY" (pdb:residue-name (first residues))))
    (is (string= "ALA" (pdb:residue-name (second residues))))))


(test build/keeps-existing-residue-from-het-and-attaches-atoms-to-it
  (let* ((het (make-instance 'pdb:residue
                             :residue-name "CLR"
                             :residue-sequence-number 412
                             :residue-insertion-code nil
                             :residue-chain "A"
                             :residue-kind :unknown
                             :residue-atoms '()
                             :residue-additional-informations "cholesterol"))
         (atom-1 (make-instance 'pdb:atom
                                :atom-name "C1"
                                :atom-serial "10"
                                :atom-residue-name "CLR"
                                :atom-residue-chain "A"
                                :atom-residue-sequence-number 412
                                :atom-residue-insertion-code nil
                                :atom-x 1.0 :atom-y 2.0 :atom-z 3.0
                                :atom-element "C"
                                :atom-charge nil))
         (atom-2 (make-instance 'pdb:atom
                                :atom-name "C2"
                                :atom-serial "11"
                                :atom-residue-name "CLR"
                                :atom-residue-chain "A"
                                :atom-residue-sequence-number 412
                                :atom-residue-insertion-code nil
                                :atom-x 4.0 :atom-y 5.0 :atom-z 6.0
                                :atom-element "C"
                                :atom-charge nil))
         (pdb (pdb::build (list het atom-1 atom-2)))
         (residue (first (pdb:pdb-residues pdb))))
    (is (= 1 (length (pdb:pdb-residues pdb))))
    (is (eq residue het))
    (is (= 2 (length (pdb:residue-atoms residue))))
    (is (string= "C1" (pdb:atom-name (first (pdb:residue-atoms residue)))))
    (is (string= "C2" (pdb:atom-name (second (pdb:residue-atoms residue)))))
    (is (string= "cholesterol" (pdb:residue-additional-informations residue)))))


(test build/concatenates-title-records-with-newlines
  (let* ((title-1 (make-instance 'pdb::title
                                 :title-content "FIRST TITLE LINE"))
         (title-2 (make-instance 'pdb::title
                                 :title-content "SECOND TITLE LINE"))
         (pdb (pdb::build (list title-1 title-2))))
    (is (string= "FIRST TITLE LINE
SECOND TITLE LINE"
                 (pdb:pdb-title pdb)))))


(test build/mixes-title-and-structural-objects
  (let* ((title (make-instance 'pdb::title
                               :title-content "MY TITLE"))
         (atom (make-instance 'pdb:atom
                              :atom-name "N"
                              :atom-serial "1"
                              :atom-residue-name "GLY"
                              :atom-residue-chain "A"
                              :atom-residue-sequence-number 10
                              :atom-residue-insertion-code nil
                              :atom-x 1.0 :atom-y 2.0 :atom-z 3.0
                              :atom-element "N"
                              :atom-charge nil))
         (pdb (pdb::build (list title atom))))
    (is (string= "MY TITLE" (pdb:pdb-title pdb)))
    (is (= 1 (length (pdb:pdb-residues pdb))))
    (is (string= "GLY" (pdb:residue-name (first (pdb:pdb-residues pdb)))))))


(test finalize/returns-same-pdb-instance
  (let* ((residue (make-instance 'pdb:residue
                                 :residue-name "ALA"
                                 :residue-sequence-number 1
                                 :residue-insertion-code nil
                                 :residue-chain "A"
                                 :residue-kind nil
                                 :residue-atoms '()
                                 :residue-additional-informations nil))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title nil
                             :pdb-sequence nil
                             :pdb-residues (list residue))))
    (is (eq pdb (pdb::finalize pdb)))))


(test finalize/assigns-amino-acid-kind
  (let* ((residue (make-instance 'pdb:residue
                                 :residue-name "ALA"
                                 :residue-sequence-number 1
                                 :residue-insertion-code nil
                                 :residue-chain "A"
                                 :residue-kind nil
                                 :residue-atoms '()
                                 :residue-additional-informations nil))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title nil
                             :pdb-sequence nil
                             :pdb-residues (list residue))))
    (pdb::finalize pdb)
    (is (eql :amino-acid (pdb:residue-kind residue)))))


(test finalize/assigns-water-kind
  (let* ((residue (make-instance 'pdb:residue
                                 :residue-name "HOH"
                                 :residue-sequence-number 10
                                 :residue-insertion-code nil
                                 :residue-chain "A"
                                 :residue-kind nil
                                 :residue-atoms '()
                                 :residue-additional-informations nil))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title nil
                             :pdb-sequence nil
                             :pdb-residues (list residue))))
    (pdb::finalize pdb)
    (is (eql :water (pdb:residue-kind residue)))))


(test finalize/assigns-ion-kind
  (let* ((residue (make-instance 'pdb:residue
                                 :residue-name "NA"
                                 :residue-sequence-number 20
                                 :residue-insertion-code nil
                                 :residue-chain "A"
                                 :residue-kind nil
                                 :residue-atoms '()
                                 :residue-additional-informations nil))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title nil
                             :pdb-sequence nil
                             :pdb-residues (list residue))))
    (pdb::finalize pdb)
    (is (eql :ion (pdb:residue-kind residue)))))


(test finalize/assigns-lipid-kind
  (let* ((residue (make-instance 'pdb:residue
                                 :residue-name "CLR"
                                 :residue-sequence-number 412
                                 :residue-insertion-code nil
                                 :residue-chain "A"
                                 :residue-kind nil
                                 :residue-atoms '()
                                 :residue-additional-informations "cholesterol"))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title nil
                             :pdb-sequence nil
                             :pdb-residues (list residue))))
    (pdb::finalize pdb)
    (is (eql :lipid (pdb:residue-kind residue)))))


(test finalize/assigns-unknown-kind-for-unclassified-residue
  (let* ((residue (make-instance 'pdb:residue
                                 :residue-name "7V7"
                                 :residue-sequence-number 501
                                 :residue-insertion-code nil
                                 :residue-chain "R"
                                 :residue-kind nil
                                 :residue-atoms '()
                                 :residue-additional-informations "ligand"))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title nil
                             :pdb-sequence nil
                             :pdb-residues (list residue))))
    (pdb::finalize pdb)
    (is (eql :unknown (pdb:residue-kind residue)))))


(test finalize/normalizes-multiple-residues-in-one-pass
  (let* ((ala (make-instance 'pdb:residue
                             :residue-name "ALA"
                             :residue-sequence-number 1
                             :residue-insertion-code nil
                             :residue-chain "A"
                             :residue-kind nil
                             :residue-atoms '()
                             :residue-additional-informations nil))
         (hoh (make-instance 'pdb:residue
                             :residue-name "HOH"
                             :residue-sequence-number 2
                             :residue-insertion-code nil
                             :residue-chain "A"
                             :residue-kind nil
                             :residue-atoms '()
                             :residue-additional-informations nil))
         (clr (make-instance 'pdb:residue
                             :residue-name "CLR"
                             :residue-sequence-number 3
                             :residue-insertion-code nil
                             :residue-chain "A"
                             :residue-kind nil
                             :residue-atoms '()
                             :residue-additional-informations nil))
         (unk (make-instance 'pdb:residue
                             :residue-name "7V7"
                             :residue-sequence-number 4
                             :residue-insertion-code nil
                             :residue-chain "A"
                             :residue-kind nil
                             :residue-atoms '()
                             :residue-additional-informations nil))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title nil
                             :pdb-sequence nil
                             :pdb-residues (list ala hoh clr unk))))
    (pdb::finalize pdb)
    (is (eql :amino-acid (pdb:residue-kind ala)))
    (is (eql :water      (pdb:residue-kind hoh)))
    (is (eql :lipid      (pdb:residue-kind clr)))
    (is (eql :unknown    (pdb:residue-kind unk)))))


(test finalize/does-not-change-pdb-title-or-sequence
  (let* ((residue (make-instance 'pdb:residue
                                 :residue-name "ALA"
                                 :residue-sequence-number 1
                                 :residue-insertion-code nil
                                 :residue-chain "A"
                                 :residue-kind nil
                                 :residue-atoms '()
                                 :residue-additional-informations nil))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title "MY TITLE"
                             :pdb-sequence "MY SEQUENCE"
                             :pdb-residues (list residue))))
    (pdb::finalize pdb)
    (is (string= "MY TITLE" (pdb:pdb-title pdb)))
    (is (string= "MY SEQUENCE" (pdb:pdb-sequence pdb)))))
