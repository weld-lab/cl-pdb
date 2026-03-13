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
	   #:atom))



(in-package #:cl-pdb)
