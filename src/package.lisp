(defpackage #:cl-pdb
  (:nicknames #:pdb)
  (:use #:cl)
  (:shadow #:atom)
  (:export #:pdb
	   #:pdb-tile
	   #:pdb-sequence
	   #:pdb-residues

	   #:residue
	   #:residue-name
	   #:residue-id
	   #:residue-sequence-number
	   #:residue-insertion-code
	   #:residue-chain
	   #:residue-kind
	   #:residue-atoms
	   #:residue-additional-informations

	   #:atom
	   #:atom-name
	   #:atom-serial
	   #:atom-residue-name
	   #:atom-residue-chain
	   #:atom-residue-sequence-number
	   #:atom-residue-insertion-code
	   #:atom-x
	   #:atom-y
	   #:atom-z
	   #:atom-element
	   #:atom-charge))



(in-package #:cl-pdb)
