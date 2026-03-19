(in-package #:cl-pdb)


(defun residue-key (chain seqNum insertion-code name)
  (list chain seqNum insertion-code name))


(defun key-from-atom (atom)
  (residue-key
   (atom-residue-chain atom)
   (atom-residue-sequence-number atom)
   (atom-residue-insertion-code atom)
   (atom-residue-name atom)))


(defun key-from-residue (residue)
  (residue-key
   (residue-chain residue)
   (residue-sequence-number residue)
   (residue-insertion-code residue)
   (residue-name residue)))


(defun ensure-residue (object index order)
  (macrolet ((is (type)
               `(typep object ,type)))
    (let* ((key (cond
                  ((is 'atom) (key-from-atom object))
                  ((is 'residue) (key-from-residue object))
                  (t (error "Cannot build a residue key from object"))))
           (known (gethash key index)))
      (if known
          (values known order)
          (let ((residue (cond
                           ((is 'residue) object)
                           ((is 'atom)
                            (make-instance 'residue
                                           :residue-name (atom-residue-name object)
                                           :residue-sequence-number (atom-residue-sequence-number object)
                                           :residue-chain (atom-residue-chain object)
                                           :residue-insertion-code (atom-residue-insertion-code object))))))
            (setf (gethash key index) residue)
            (values residue (push residue order)))))))



(defun build-title (title title-parts)
  (push (title-content title) title-parts))


(defun build-seqres (seqres sequence-index sequence-order)
  (let* ((chain (seqres-chain seqres))
         (known (gethash chain sequence-index)))
    (unless known
      (push chain sequence-order)
      (setf known '()))
    (setf (gethash chain sequence-index)
          (append known (seqres-residue-names seqres)))
    sequence-order))


(defun build-structural-object (object residue-index residue-order)
  (multiple-value-bind (residue new-order)
      (ensure-residue object residue-index residue-order)
    (when (typep object 'atom)
      (push object (residue-atoms residue)))
    new-order))


(defun assemble-title (title-parts)
  (format nil "~{~a~}" (nreverse title-parts)))


(defun assemble-sequence (sequence-index sequence-order)
  (loop for chain in (nreverse sequence-order)
        collect (cons chain (gethash chain sequence-index))))


(defun assemble-residues (residue-order)
  (mapcar (lambda (residue)
            (setf (residue-atoms residue)
                  (nreverse (residue-atoms residue)))
            residue)
          (nreverse residue-order)))


(defun build (ingested)
  (let ((residue-index (make-hash-table :test #'equal))
        (residue-order '())
        (title-parts '())
        (sequence-index (make-hash-table :test #'equal))
        (sequence-order '()))
    (dolist (object ingested)
      (unless (null object)
        (macrolet ((is (type)
                     `(typep object ,type)))
          (cond
            ((is 'title)
             (setf title-parts
                   (build-title object title-parts)))
            ((is 'seqres)
             (setf sequence-order
                   (build-seqres object sequence-index sequence-order)))
            (t
             (setf residue-order
                   (build-structural-object object residue-index residue-order)))))))
    (make-instance 'pdb
                   :pdb-title (assemble-title title-parts)
                   :pdb-sequence (assemble-sequence sequence-index sequence-order)
                   :pdb-residues (assemble-residues residue-order))))
