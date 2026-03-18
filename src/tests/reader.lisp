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
