(in-package #:cl-pdb/tests)

(5am:in-suite :cl-pdb.tests.parse)

(test trim-or-nil/returns-trimmed-string
  (is (string= "ALA" (pdb::trim-or-nil "  ALA  "))))


(test trim-or-nil/returns-nil-on-blank-string
  (is (null (pdb::trim-or-nil "      "))))


(test parse-float/parses-float
  (is (= 128.003 (pdb::parse-float " 128.003 "))))


(test parse-float/returns-nil-on-blank-string
  (is (null (pdb::parse-float "   "))))


(test record-type/detects-atom
  (let ((record "ATOM      1  N   ASP A  29     -52.822  -1.611  23.137  1.00 98.48           N  "))
    (is (eql :atom (pdb::record-type record)))))


(test record-type/detects-hetatm
  (let ((record "HETATM 3722  C2  PLM A 415     -58.012  31.828   5.279  1.00 93.74           C  "))
    (is (eql :hetatm (pdb::record-type record)))))


(test record-type/detects-het
  (let ((record "HET    CLR  A 412      28                                                        "))
    (is (eql :het (pdb::record-type record)))))


(test record-type/detects-title
  (let ((record "TITLE     FENTANYL-BOUND MU-OPIOID RECEPTOR-GI COMPLEX                          "))
    (is (eql :title (pdb::record-type record)))))


(test record-type/detects-remark
  (let ((record "REMARK   3  REFINEMENT.                                                          "))
    (is (eql :remark (pdb::record-type record)))))


(test record-type/detects-seqres
  (let ((record "SEQRES   1 A  500  ASP TYR LYS ASP ASP ASP ALA MET GLY GLN PRO GLY ASN          "))
    (is (eql :seqres (pdb::record-type record)))))


(test record-type/detects-header
  (let ((record "HEADER    SIGNALING PROTEIN                       08-SEP-22   8EF5              "))
    (is (eql :header (pdb::record-type record)))))


(test record-type/returns-nil-on-unknown-record
  (let ((record "FOOBAR    SOMETHING THAT SHOULD NOT MATCH                                          "))
    (is (null (pdb::record-type record)))))


(test parse-atom/from-standard-record
  (let* ((record "ATOM      1  N   ASP A  29     -52.822  -1.611  23.137  1.00 98.48           N  ")
         (atom   (pdb::parse-atom record)))
    (is (typep atom 'pdb:atom))

    ;; valeurs
    (is (string= "N"   (pdb:atom-name atom)))
    (is (null          (pdb::atom-alternative-location atom)))
    (is (string= "1"   (pdb:atom-serial atom)))
    (is (string= "ASP" (pdb:atom-residue-name atom)))
    (is (string= "A"   (pdb:atom-residue-chain atom)))
    (is (= 29          (pdb:atom-residue-sequence-number atom)))
    (is (null          (pdb:atom-residue-insertion-code atom)))
    (is (= -52.822     (pdb:atom-x atom)))
    (is (= -1.611      (pdb:atom-y atom)))
    (is (= 23.137      (pdb:atom-z atom)))
    (is (= 1.00        (pdb::atom-occupancy atom)))
    (is (= 98.48       (pdb::atom-temperature-factor atom)))
    (is (string= "N"   (pdb:atom-element atom)))
    (is (null          (pdb:atom-charge atom)))

    ;; types
    (is (typep (pdb:atom-name atom) 'string))
    (is (typep (pdb:atom-serial atom) 'string))
    (is (typep (pdb:atom-residue-name atom) 'string))
    (is (typep (pdb:atom-residue-chain atom) 'string))
    (is (typep (pdb:atom-residue-sequence-number atom) 'integer))
    (is (floatp (pdb:atom-x atom)))
    (is (floatp (pdb:atom-y atom)))
    (is (floatp (pdb:atom-z atom)))
    (is (floatp (pdb::atom-occupancy atom)))
    (is (floatp (pdb::atom-temperature-factor atom)))
    (is (typep (pdb:atom-element atom) 'string))))


(test parse-atom/parses-altloc
  (let* ((record "ATOM   3201  CG ACYS A 242     128.003 125.608 196.380  0.50 12.34           C  ")
         (atom   (pdb::parse-atom record)))
    (is (typep atom 'pdb:atom))
    (is (string= "CG"   (pdb:atom-name atom)))
    (is (string= "A"    (pdb::atom-alternative-location atom)))
    (is (string= "CYS"  (pdb:atom-residue-name atom)))
    (is (= 0.50         (pdb::atom-occupancy atom)))
    (is (= 12.34        (pdb::atom-temperature-factor atom)))))

(test parse-het/from-record
  (let* ((record "HET    CLR  A 412      28                                                        ")
         (residue (pdb::parse-het record)))
    (is (typep residue 'pdb:residue))

    ;; valeurs
    (is (string= "CLR" (pdb:residue-name residue)))
    (is (= 412        (pdb:residue-sequence-number residue)))
    (is (string= "A"  (pdb:residue-chain residue)))
    (is (null         (pdb:residue-insertion-code residue)))
    (is (eql :unknown (pdb:residue-kind residue)))
    (is (equal '()    (pdb:residue-atoms residue)))
    (is (stringp      (pdb:residue-additional-informations residue)))
    (is (eql :hetero  (pdb::residue-type residue)))))


(test parse-het/preserves-free-text
  (let* ((record "HET    7V7  R 501      25                             bla                       ")
         (residue (pdb::parse-het record)))
    (is (typep residue 'pdb:residue))
    (is (string= "7V7" (pdb:residue-name residue)))
    (is (= 501        (pdb:residue-sequence-number residue)))
    (is (string= "R"  (pdb:residue-chain residue)))
    (is (string= "                        bla             "
                 (pdb:residue-additional-informations residue)))))


(test parse-hetatm/from-record
  (let* ((record "HETATM 3722  C2  PLM A 415     -58.012  31.828   5.279  1.00 93.74           C  ")
         (atom   (pdb::parse-hetatm record)))
    (is (typep atom 'pdb:atom))

    ;; valeurs
    (is (string= "C2"   (pdb:atom-name atom)))
    (is (null           (pdb::atom-alternative-location atom)))
    (is (string= "3722" (pdb:atom-serial atom)))
    (is (string= "PLM"  (pdb:atom-residue-name atom)))
    (is (string= "A"    (pdb:atom-residue-chain atom)))
    (is (= 415          (pdb:atom-residue-sequence-number atom)))
    (is (null           (pdb:atom-residue-insertion-code atom)))
    (is (= -58.012      (pdb:atom-x atom)))
    (is (= 31.828       (pdb:atom-y atom)))
    (is (= 5.279        (pdb:atom-z atom)))
    (is (= 1.00         (pdb::atom-occupancy atom)))
    (is (= 93.74        (pdb::atom-temperature-factor atom)))
    (is (string= "C"    (pdb:atom-element atom)))
    (is (null           (pdb:atom-charge atom)))))


(test parse-title/from-record
  (let* ((record "TITLE     FENTANYL-BOUND MU-OPIOID RECEPTOR-GI COMPLEX                          ")
         (title  (pdb::parse-title record)))
    (is (typep title 'pdb::title))
    (is (string= "FENTANYL-BOUND MU-OPIOID RECEPTOR-GI COMPLEX                          "
                 (pdb::title-content title)))))


(test parse-title/keeps-leading-column-11-space-when-present
  (let* ((record "TITLE    2 BOUND TO AN ENGINEERED G PROTEIN                                     ")
         (title  (pdb::parse-title record)))
    (is (typep title 'pdb::title))
    (is (string= " BOUND TO AN ENGINEERED G PROTEIN                                     "
                 (pdb::title-content title)))))


(test parse-seqres/from-record
  (let* ((record "SEQRES   1 A  500  ASP TYR LYS ASP ASP ASP ALA MET GLY GLN PRO GLY ASN          ")
         (seqres (pdb::parse-seqres record)))
    (is (typep seqres 'pdb::seqres))

    ;; valeurs
    (is (= 1    (pdb::seqres-serial-number seqres)))
    (is (string= "A" (pdb::seqres-chain seqres)))
    (is (= 500  (pdb::seqres-residue-count seqres)))
    (is (equal '("ASP" "TYR" "LYS" "ASP" "ASP" "ASP"
                 "ALA" "MET" "GLY" "GLN" "PRO" "GLY" "ASN")
               (pdb::seqres-residue-names seqres)))))


(test parse-seqres/returns-list-of-residue-names
  (let* ((record "SEQRES   2 A  500  LEU VAL ILE SER PHE GLY THR LEU GLU ALA ALA GLY GLY          ")
         (seqres (pdb::parse-seqres record)))
    (is (typep seqres 'pdb::seqres))
    (is (every (lambda (x) (typep x 'string))
               (pdb::seqres-residue-names seqres)))
    (is (= 13 (length (pdb::seqres-residue-names seqres))))))
