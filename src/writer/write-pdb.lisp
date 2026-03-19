(in-package #:cl-pdb)


(defun residue-type-to-string (residue)
  (case (residue-type residue)
    (:hetero "HETATM")
    (otherwise "ATOM  ")))


(defun safe-string (value)
  (if value
      (princ-to-string value)
      ""))


(defun safe-char-string (value)
  (cond
    ((null value) "")
    ((characterp value) (string value))
    (t (princ-to-string value))))


(defun safe-integer (value)
  (cond
    ((integerp value) value)
    ((stringp value)
     (or (parse-integer value :junk-allowed t) 0))
    (t 0)))


(defun safe-float (value)
  (cond
    ((numberp value) (coerce value 'single-float))
    (t 0.0)))


(defun truncate-right (string width)
  (let ((string (safe-string string)))
    (if (> (length string) width)
        (subseq string 0 width)
        string)))


(defun pad-left (string width)
  (format nil (format nil "~~~DA" width)
          (truncate-right string width)))


(defun pad-right (string width)
  (format nil (format nil "~~~D@A" width)
          (truncate-right string width)))


(defun pdb-atom-name-field (name)
  (pad-left name 4))


(defun pdb-residue-name-field (name)
  (pad-right name 3))


(defun pdb-chain-field (chain)
  (truncate-right (safe-char-string chain) 1))


(defun pdb-icode-field (icode)
  (truncate-right (safe-char-string icode) 1))


(defun pdb-element-field (element)
  (pad-left (string-upcase (safe-string element)) 2))


(defun write-title-records (stream title)
  (when title
    (let* ((text (safe-string title))
           (width 70)
           (length (length text)))
      (if (zerop length)
          (write-line "TITLE     " stream)
          (loop for start from 0 below length by width
                for end = (min length (+ start width))
                for chunk = (subseq text start end)
                for index from 1
                do (if (= index 1)
                       (format stream "TITLE     ~A~%" chunk)
                       (format stream "TITLE  ~2D ~A~%" index chunk)))))))


(defun write-atom (stream atom residue)
  "Faudra modifier si on finit par parser toutes les missing lines."
  (let* ((record  (residue-type-to-string residue))
         (serial  (safe-integer (atom-serial atom)))
         (name    (pdb-atom-name-field (atom-name atom)))
         (resname (pdb-residue-name-field (residue-name residue)))
         (chain   (pdb-chain-field (residue-chain residue)))
         (resseq  (or (residue-sequence-number residue) 0))
         (icode   (pdb-icode-field (residue-insertion-code residue)))
         (x       (safe-float (atom-x atom)))
         (y       (safe-float (atom-y atom)))
         (z       (safe-float (atom-z atom)))
         (occupancy 1.00)
         (temp-factor 0.00)
         (element (pdb-element-field (atom-element atom)))
         (charge  "  "))
    (format stream
            "~6A~5D ~4A ~3A ~1A~4D~1A   ~8,3F~8,3F~8,3F~6,2F~6,2F          ~2A~2A~%"
            record
            serial
            name
            resname
            chain
            resseq
            icode
            x
            y
            z
            occupancy
            temp-factor
            element
            charge)))


(defun write-residue-records (stream residues)
  (dolist (residue residues)
    (dolist (atom (residue-atoms residue))
      (write-atom stream atom residue))))


(defun write-residues (residues pathname &key title)
  (with-open-file (stream pathname
                          :direction :output
                          :if-exists :supersede
                          :if-does-not-exist :create)
    (write-title-records stream title)
    (write-residue-records stream residues)
    (write-line "END" stream))
  pathname)


(defun write-pdb (pdb pathname)
  (write-residues (pdb-residues pdb)
                  pathname
                  :title (pdb-title pdb)))
