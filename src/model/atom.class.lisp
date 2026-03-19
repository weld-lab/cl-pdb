(in-package #:cl-pdb)


(defclass atom ()
  ((atom-name :initarg :atom-name
	      :initform nil
	      :accessor atom-name)
   (atom-alternative-location :initarg :atom-alternative-location
			      :initform nil
			      :accessor atom-alternative-location)
   (atom-serial :initarg :atom-serial
		:initform nil
		:accessor atom-serial)
   (atom-residue-name :initarg :atom-residue-name
		      :initform nil
		      :accessor atom-residue-name)
   (atom-residue-chain :initarg :atom-residue-chain
		       :initform nil
		       :accessor atom-residue-chain)
   (atom-residue-sequence-number :initarg :atom-residue-sequence-number
			  :initform nil
			  :accessor atom-residue-sequence-number)
   (atom-residue-insertion-code :initarg :atom-residue-insertion-code
				:initform nil
				:accessor atom-residue-insertion-code)
   (atom-x :initarg :atom-x
	   :initform nil
	   :accessor atom-x)
   (atom-y :initarg :atom-y
	   :initform nil
	   :accessor atom-y)
   (atom-z :initarg :atom-z
	   :initform nil
	   :accessor atom-z)
   (atom-occupancy :initarg :atom-occupancy
		   :initform nil
		   :accessor atom-occupancy)
   (atom-temperature-factor :initarg :atom-temperature-factor
			    :initform nil
			    :accessor atom-temperature-factor)
   (atom-element :initarg :atom-element
		 :initform nil
		 :accessor atom-element)
   (atom-charge :initarg :atom-charge
		:initform nil
		:accessor atom-charge)))



(defmethod print-object ((obj atom) stream)
  (print-unreadable-object (obj stream)
    (format stream "~a (~a ; ~a ; ~a)"
	    (atom-element obj)
	    (atom-x obj)
	    (atom-y obj)
	    (atom-z obj))))
