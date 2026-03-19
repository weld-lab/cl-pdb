(in-package #:cl-pdb/tests)

(5am:in-suite :cl-pdb.tests)

;;; ------------------------------------------------------------------
;;; ingest
;;; ------------------------------------------------------------------

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
    (is (= 23.137      (pdb:atom-z object)))))

(test ingest/hetatm-record-returns-atom
  (let* ((record "HETATM 3722  C2  PLM A 415     -58.012  31.828   5.279  1.00 93.74           C  ")
         (object (pdb::ingest record)))
    (is (typep object 'pdb:atom))
    (is (string= "C2"  (pdb:atom-name object)))
    (is (string= "PLM" (pdb:atom-residue-name object)))
    (is (string= "A"   (pdb:atom-residue-chain object)))
    (is (= 415         (pdb:atom-residue-sequence-number object)))
    (is (= -58.012     (pdb:atom-x object)))
    (is (= 31.828      (pdb:atom-y object)))
    (is (= 5.279       (pdb:atom-z object)))))

(test ingest/het-record-returns-residue
  (let* ((record "HET    CLR  A 412      28                                                        ")
         (object (pdb::ingest record)))
    (is (typep object 'pdb:residue))
    (is (string= "CLR" (pdb:residue-name object)))
    (is (= 412        (pdb:residue-sequence-number object)))
    (is (string= "A"  (pdb:residue-chain object)))
    (is (eql :unknown (pdb:residue-kind object)))
    (is (eql :hetero  (pdb::residue-type object)))))

(test ingest/title-record-returns-title
  (let* ((record "TITLE     FENTANYL-BOUND MU-OPIOID RECEPTOR-GI COMPLEX                          ")
         (object (pdb::ingest record)))
    (is (typep object 'pdb::title))
    (is (string= "FENTANYL-BOUND MU-OPIOID RECEPTOR-GI COMPLEX                          "
                 (pdb::title-content object)))))

(test ingest/seqres-record-returns-seqres
  (let* ((record "SEQRES   1 A  500  ASP TYR LYS ASP ASP ASP ALA MET GLY GLN PRO GLY ASN          ")
         (object (pdb::ingest record)))
    (is (typep object 'pdb::seqres))
    (is (= 1   (pdb::seqres-serial-number object)))
    (is (string= "A" (pdb::seqres-chain object)))
    (is (= 500 (pdb::seqres-residue-count object)))
    (is (equal '("ASP" "TYR" "LYS" "ASP" "ASP" "ASP"
                 "ALA" "MET" "GLY" "GLN" "PRO" "GLY" "ASN")
               (pdb::seqres-residue-names object)))))

(test ingest/remark-record-returns-nil
  (let ((record "REMARK   3  REFINEMENT.                                                          "))
    (is (null (pdb::ingest record)))))

(test ingest/header-record-returns-nil
  (let ((record "HEADER    SIGNALING PROTEIN                       08-SEP-22   8EF5              "))
    (is (null (pdb::ingest record)))))

(test ingest/unknown-record-returns-nil
  (let ((record "FOOBAR    SOMETHING THAT SHOULD NOT MATCH                                          "))
    (is (null (pdb::ingest record)))))

;;; ------------------------------------------------------------------
;;; build helpers
;;; ------------------------------------------------------------------

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
                             :atom-occupancy 1.0
                             :atom-temperature-factor 0.0
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
                                :residue-additional-informations ""
                                :residue-type :sequence)))
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
                              :atom-occupancy 1.0
                              :atom-temperature-factor 0.0
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

(test ensure-residue/reuses-existing-residue-for-second-atom
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
                                :atom-occupancy 1.0
                                :atom-temperature-factor 0.0
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
                                :atom-occupancy 1.0
                                :atom-temperature-factor 0.0
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
                                 :residue-additional-informations "cholesterol"
                                 :residue-type :hetero)))
    (multiple-value-bind (found new-order)
        (pdb::ensure-residue residue index order)
      (is (eq found residue))
      (is (equal (list residue) new-order))
      (is (eq residue (gethash '("A" 412 nil "CLR") index))))))

(test ensure-residue/signals-error-on-unsupported-object
  (let ((index (make-hash-table :test #'equal))
        (order '()))
    (signals error
      (pdb::ensure-residue 42 index order))))

(test build-title/pushes-title-content
  (let* ((title (make-instance 'pdb::title :title-content "HELLO"))
         (parts '()))
    (is (equal '("HELLO")
               (pdb::build-title title parts)))))

(test build-seqres/creates-first-chain-entry
  (let* ((seqres (make-instance 'pdb::seqres
                                :seqres-serial-number 1
                                :seqres-chain "A"
                                :seqres-residue-count 4
                                :seqres-residue-names '("ALA" "GLY")))
         (index (make-hash-table :test #'equal))
         (order '())
         (new-order (pdb::build-seqres seqres index order)))
    (is (equal '("A") new-order))
    (is (equal '("ALA" "GLY")
               (gethash "A" index)))))

(test build-seqres/appends-to-existing-chain-entry
  (let* ((seqres-1 (make-instance 'pdb::seqres
                                  :seqres-serial-number 1
                                  :seqres-chain "A"
                                  :seqres-residue-count 4
                                  :seqres-residue-names '("ALA" "GLY")))
         (seqres-2 (make-instance 'pdb::seqres
                                  :seqres-serial-number 2
                                  :seqres-chain "A"
                                  :seqres-residue-count 4
                                  :seqres-residue-names '("SER" "THR")))
         (index (make-hash-table :test #'equal))
         (order '()))
    (setf order (pdb::build-seqres seqres-1 index order))
    (setf order (pdb::build-seqres seqres-2 index order))
    (is (equal '("A") order))
    (is (equal '("ALA" "GLY" "SER" "THR")
               (gethash "A" index)))))

(test build-structural-object/attaches-atom-to-created-residue-order
  (let* ((index (make-hash-table :test #'equal))
         (order '())
         (atom (make-instance 'pdb:atom
                              :atom-name "CA"
                              :atom-serial "1"
                              :atom-residue-name "ALA"
                              :atom-residue-chain "A"
                              :atom-residue-sequence-number 42
                              :atom-residue-insertion-code nil
                              :atom-x 1.0 :atom-y 2.0 :atom-z 3.0
                              :atom-occupancy 1.0
                              :atom-temperature-factor 0.0
                              :atom-element "C"
                              :atom-charge nil))
         (new-order (pdb::build-structural-object atom index order))
         (residue (first new-order)))
    (is (= 1 (length new-order)))
    (is (= 1 (length (pdb:residue-atoms residue))))
    (is (eq atom (first (pdb:residue-atoms residue))))))

(test assemble-title/concatenates-title-parts-in-reading-order
  (is (string= "FIRSTSECOND"
               (pdb::assemble-title '("SECOND" "FIRST")))))

(test assemble-sequence/returns-alist-in-chain-order
  (let ((index (make-hash-table :test #'equal)))
    (setf (gethash "A" index) '("ALA" "GLY"))
    (setf (gethash "B" index) '("SER"))
    (is (equal '(("A" "ALA" "GLY")
                 ("B" "SER"))
               (mapcar (lambda (x) (cons (car x) (cdr x)))
                       (pdb::assemble-sequence index '("B" "A")))))))

(test assemble-residues/restores-atom-order
  (let* ((atom-1 (make-instance 'pdb:atom
                                :atom-name "N"
                                :atom-serial "1"
                                :atom-residue-name "ALA"
                                :atom-residue-chain "A"
                                :atom-residue-sequence-number 42
                                :atom-residue-insertion-code nil
                                :atom-x 1.0 :atom-y 2.0 :atom-z 3.0
                                :atom-occupancy 1.0
                                :atom-temperature-factor 0.0
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
                                :atom-occupancy 1.0
                                :atom-temperature-factor 0.0
                                :atom-element "C"
                                :atom-charge nil))
         (residue (make-instance 'pdb:residue
                                 :residue-name "ALA"
                                 :residue-sequence-number 42
                                 :residue-insertion-code nil
                                 :residue-chain "A"
                                 :residue-kind :unknown
                                 :residue-type :sequence
                                 :residue-atoms (list atom-2 atom-1)
                                 :residue-additional-informations ""))
         (assembled (pdb::assemble-residues (list residue))))
    (is (= 1 (length assembled)))
    (is (string= "N"  (pdb:atom-name (first (pdb:residue-atoms (first assembled))))))
    (is (string= "CA" (pdb:atom-name (second (pdb:residue-atoms (first assembled))))))))

;;; ------------------------------------------------------------------
;;; build
;;; ------------------------------------------------------------------

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
                              :atom-occupancy 1.0
                              :atom-temperature-factor 0.0
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
                                :atom-occupancy 1.0
                                :atom-temperature-factor 0.0
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
                                :atom-occupancy 1.0
                                :atom-temperature-factor 0.0
                                :atom-element "C"
                                :atom-charge nil))
         (pdb (pdb::build (list atom-1 atom-2)))
         (residue (first (pdb:pdb-residues pdb)))
         (atoms (pdb:residue-atoms residue)))
    (is (= 1 (length (pdb:pdb-residues pdb))))
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
                                :atom-occupancy 1.0
                                :atom-temperature-factor 0.0
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
                                :atom-occupancy 1.0
                                :atom-temperature-factor 0.0
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
                                :atom-occupancy 1.0
                                :atom-temperature-factor 0.0
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
                                :atom-occupancy 1.0
                                :atom-temperature-factor 0.0
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
                                :atom-occupancy 1.0
                                :atom-temperature-factor 0.0
                                :atom-element "C"
                                :atom-charge nil))
         (pdb (pdb::build (list atom-1 atom-2 atom-3)))
         (residues (pdb:pdb-residues pdb)))
    (is (= 2 (length residues)))
    (is (string= "GLY" (pdb:residue-name (first residues))))
    (is (string= "ALA" (pdb:residue-name (second residues))))))

(test build/keeps-existing-het-residue-and-attaches-atoms-to-it
  (let* ((het (make-instance 'pdb:residue
                             :residue-name "CLR"
                             :residue-sequence-number 412
                             :residue-insertion-code nil
                             :residue-chain "A"
                             :residue-kind :unknown
                             :residue-type :hetero
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
                                :atom-occupancy 1.0
                                :atom-temperature-factor 0.0
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
                                :atom-occupancy 1.0
                                :atom-temperature-factor 0.0
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

(test build/concatenates-title-records-without-separator
  (let* ((title-1 (make-instance 'pdb::title
                                 :title-content "FIRST"))
         (title-2 (make-instance 'pdb::title
                                 :title-content "SECOND"))
         (pdb (pdb::build (list title-1 title-2))))
    (is (string= "FIRSTSECOND"
                 (pdb:pdb-title pdb)))))

(test build/assembles-seqres-by-chain
  (let* ((seqres-a1 (make-instance 'pdb::seqres
                                   :seqres-serial-number 1
                                   :seqres-chain "A"
                                   :seqres-residue-count 4
                                   :seqres-residue-names '("ALA" "GLY")))
         (seqres-a2 (make-instance 'pdb::seqres
                                   :seqres-serial-number 2
                                   :seqres-chain "A"
                                   :seqres-residue-count 4
                                   :seqres-residue-names '("SER" "THR")))
         (seqres-b1 (make-instance 'pdb::seqres
                                   :seqres-serial-number 1
                                   :seqres-chain "B"
                                   :seqres-residue-count 2
                                   :seqres-residue-names '("MET" "LYS")))
         (pdb (pdb::build (list seqres-a1 seqres-a2 seqres-b1))))
    (is (equal '(("A" "ALA" "GLY" "SER" "THR")
                 ("B" "MET" "LYS"))
               (mapcar (lambda (x) (cons (car x) (cdr x)))
                       (pdb:pdb-sequence pdb))))))

(test build/mixes-title-seqres-and-structural-objects
  (let* ((title (make-instance 'pdb::title
                               :title-content "MY TITLE"))
         (seqres (make-instance 'pdb::seqres
                                :seqres-serial-number 1
                                :seqres-chain "A"
                                :seqres-residue-count 2
                                :seqres-residue-names '("GLY" "ALA")))
         (atom (make-instance 'pdb:atom
                              :atom-name "N"
                              :atom-serial "1"
                              :atom-residue-name "GLY"
                              :atom-residue-chain "A"
                              :atom-residue-sequence-number 10
                              :atom-residue-insertion-code nil
                              :atom-x 1.0 :atom-y 2.0 :atom-z 3.0
                              :atom-occupancy 1.0
                              :atom-temperature-factor 0.0
                              :atom-element "N"
                              :atom-charge nil))
         (pdb (pdb::build (list title seqres atom))))
    (is (string= "MY TITLE" (pdb:pdb-title pdb)))
    (is (equal '(("A" "GLY" "ALA"))
               (mapcar (lambda (x) (cons (car x) (cdr x)))
                       (pdb:pdb-sequence pdb))))
    (is (= 1 (length (pdb:pdb-residues pdb))))
    (is (string= "GLY" (pdb:residue-name (first (pdb:pdb-residues pdb)))))))

;;; ------------------------------------------------------------------
;;; finalize
;;; ------------------------------------------------------------------

(test finalize/returns-same-pdb-instance
  (let* ((residue (make-instance 'pdb:residue
                                 :residue-name "ALA"
                                 :residue-sequence-number 1
                                 :residue-insertion-code nil
                                 :residue-chain "A"
                                 :residue-kind nil
                                 :residue-atoms '()
                                 :residue-additional-informations ""
                                 :residue-type :sequence))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title ""
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
                                 :residue-additional-informations ""
                                 :residue-type :sequence))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title ""
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
                                 :residue-additional-informations ""
                                 :residue-type :hetero))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title ""
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
                                 :residue-additional-informations ""
                                 :residue-type :hetero))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title ""
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
                                 :residue-additional-informations "cholesterol"
                                 :residue-type :hetero))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title ""
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
                                 :residue-additional-informations "ligand"
                                 :residue-type :hetero))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title ""
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
                             :residue-additional-informations ""
                             :residue-type :sequence))
         (hoh (make-instance 'pdb:residue
                             :residue-name "HOH"
                             :residue-sequence-number 2
                             :residue-insertion-code nil
                             :residue-chain "A"
                             :residue-kind nil
                             :residue-atoms '()
                             :residue-additional-informations ""
                             :residue-type :hetero))
         (clr (make-instance 'pdb:residue
                             :residue-name "CLR"
                             :residue-sequence-number 3
                             :residue-insertion-code nil
                             :residue-chain "A"
                             :residue-kind nil
                             :residue-atoms '()
                             :residue-additional-informations ""
                             :residue-type :hetero))
         (unk (make-instance 'pdb:residue
                             :residue-name "7V7"
                             :residue-sequence-number 4
                             :residue-insertion-code nil
                             :residue-chain "A"
                             :residue-kind nil
                             :residue-atoms '()
                             :residue-additional-informations ""
                             :residue-type :hetero))
         (pdb (make-instance 'pdb:pdb
                             :pdb-title ""
                             :pdb-sequence nil
                             :pdb-residues (list ala hoh clr unk))))
    (pdb::finalize pdb)
    (is (eql :amino-acid (pdb:residue-kind ala)))
    (is (eql :water      (pdb:residue-kind hoh)))
    (is (eql :lipid      (pdb:residue-kind clr)))
    (is (eql :unknown    (pdb:residue-kind unk)))))

;;; ------------------------------------------------------------------
;;; read-pdb
;;; ------------------------------------------------------------------
(test read-pdb/reads-builds-and-finalizes
  (uiop:with-temporary-file (:pathname path
                             :stream stream
                             :direction :output)
    (write-line "TITLE     TEST STRUCTURE                                                    " stream)
    (write-line "SEQRES   1 A    2  ALA GLY                                                  " stream)
    (write-line "ATOM      1  N   ALA A   1      11.000  12.000  13.000  1.00 20.00           N  " stream)
    (write-line "ATOM      2  CA  ALA A   1      12.000  13.000  14.000  1.00 20.00           C  " stream)
    (write-line "HET    CLR  A 412      28                                                        " stream)
    (write-line "HETATM 3722  C2  CLR A 412     -58.012  31.828   5.279  1.00 93.74           C  " stream)
    (finish-output stream)
    (let* ((pdb (pdb::read-pdb path))
           (residues (pdb:pdb-residues pdb)))
      (is (typep pdb 'pdb:pdb))
      (is (string= "TEST STRUCTURE                                                    "
                   (pdb:pdb-title pdb)))
      (is (equal '(("A" "ALA" "GLY"))
                 (mapcar (lambda (x) (cons (car x) (cdr x)))
                         (pdb:pdb-sequence pdb))))
      (is (= 2 (length residues)))
      (is (string= "ALA" (pdb:residue-name (first residues))))
      (is (eql :amino-acid (pdb:residue-kind (first residues))))
      (is (string= "CLR" (pdb:residue-name (second residues))))
      (is (eql :lipid (pdb:residue-kind (second residues))))
      (is (= 2 (length (pdb:residue-atoms (first residues)))))
      (is (= 1 (length (pdb:residue-atoms (second residues))))))))
