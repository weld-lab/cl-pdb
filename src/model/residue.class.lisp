(in-package #:cl-pdb)


; quand il faudra normaliser, ça va être important de prendre
; des pdb et simplement de voir tous ceux qui sont marqués ":unknown"
; et de remplir à la main gentiment



(defclass residue ()
  ((residue-name :initarg :residue-name
		 :initform nil
		 :accessor residue-name
		 :documentation "Contient le nom du résidu. Typiquement, le code à trois caractères 7V7 qui identifie le fentanyl.")
   (residue-id :initarg :residue-id ; c'est également un seqNum pour les het
	       :initform nil
	       :accessor residue-id
	       :documentation "Pas sûr pour le moment.")
   (residue-sequence-number :initarg :residue-sequence-number
			    :initform nil
			    :accessor residue-sequence-number)
   (residue-insertion-code :initarg :residue-insertion-code
			   :initform nil
			   :accessor residue-insertion-code)
   (residue-chain :initarg :residue-chain
		  :initform nil
		  :accessor residue-chain
		  :documentation "Nom de la chaîne.")
   (residue-kind :initarg :residue-kind
		 :initform :unknown
		 :accessor residue-kind
		 :documentation "Contient un keyword 'métier', par exemple :water, :ligand ou :amino-acids. On a :other pour ceux qui n'entrent pas dans les catégories à définir, et :unknown quand pas encore défini. Faudra bien sûr passer par une étape de normalisation ; ex H2O et HOH entrent dans le residue-kind :water.")
   (residue-atoms :initform '()
		  :initarg :residue-atoms
		  :accessor residue-atoms)
   (residues-additional-informations :initarg :residue-additional-informations
				     :initform ""
				     :accessor residue-additional-informations)
   (residue-type :initarg :residue-type
		 :initform :sequence
		 :accessor residue-type))
  (:documentation "Classe qui représente un résidu, au sens structural."))


(defmethod print-object ((obj residue) stream)
  (print-unreadable-object (obj stream)
    (format stream "~a:~a (~a:~a) of kind ~a in chain ~a"
	    (residue-type obj)
	    (residue-name obj)
	    (residue-sequence-number obj)
	    (residue-insertion-code obj)
	    (residue-kind obj)
	    (residue-chain obj))))
