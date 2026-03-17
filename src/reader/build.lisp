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
			   ((is 'atom) (make-instance 'residue
						      :residue-name (atom-residue-name object)
						      :residue-sequence-number (atom-residue-sequence-number object)
						      :residue-chain (atom-residue-chain object)
						      :residue-insertion-code (atom-residue-insertion-code object))))))
	    (setf (gethash key index) residue)
	    (values residue (push residue order)))))))



(defun build (ingested)
  (let ((residue-index (make-hash-table :test #'equal))
        (residue-order '()))
    (dolist (object ingested)
      (unless (null object)
        (multiple-value-bind (residue new-order)
            (ensure-residue object residue-index residue-order)
          (setf residue-order new-order)
          (when (typep object 'atom)
            (push object (residue-atoms residue))))))
    (make-instance 'pdb
                   :pdb-title nil
                   :pdb-sequence nil
                   :pdb-residues
                   (mapcar (lambda (residue)
                             (setf (residue-atoms residue)
                                   (nreverse (residue-atoms residue)))
                             residue)
                           (nreverse residue-order)))))
