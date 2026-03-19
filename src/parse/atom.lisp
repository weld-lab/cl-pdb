(in-package #:cl-pdb)


(defun parse-atom (atom)
;;; ATOM record
;;; 1-6    : record name ("ATOM")
;;; 7-11   : serial     -- atom serial number
;;; 13-16  : name       -- atom name
;;; 17     : altLoc     -- alternate location indicator
;;; 18-20  : resName    -- residue name
;;; 22     : chainID    -- chain identifier
;;; 23-26  : resSeq     -- residue sequence number
;;; 27     : iCode      -- insertion code
;;; 31-38  : x          -- orthogonal X coordinate in angstroms
;;; 39-46  : y          -- orthogonal Y coordinate in angstroms
;;; 47-54  : z          -- orthogonal Z coordinate in angstroms
;;; 55-60  : occupancy  -- occupancy
;;; 61-66  : tempFactor -- temperature factor
;;; 77-78  : element    -- element symbol, right-justified            
;;; 79-80  : charge     -- atom charge
  (let ((serial (trim-or-nil  (subseq atom 6 11)))
	(name (trim-or-nil (subseq atom 12 16)))
	(altLoc (trim-or-nil (subseq atom 16 17)))
	(resname (trim-or-nil (subseq atom 17 20)))
	(chainID (trim-or-nil (subseq atom 21 22)))
	(resSeq (parse-integer (subseq atom 22 26)))
	(iCode (trim-or-nil (subseq atom 26 27)))
	(x (parse-float (subseq atom 30 38)))
	(y (parse-float (subseq atom 38 46)))
	(z (parse-float (subseq atom 46 54)))
	(occupancy (parse-float (subseq atom 54 60)))
	(tempFactor (parse-float (subseq atom 60 66)))
	(element (trim-or-nil (subseq atom 76 78)))
	(charge (parse-float (subseq atom 78 80))))
    (make-instance 'atom
		   :atom-name name
		   :atom-alternative-location altLoc
		   :atom-serial serial
		   :atom-residue-name resname
		   :atom-residue-chain chainID
		   :atom-residue-sequence-number resSeq
		   :atom-residue-insertion-code iCode
		   :atom-x x :atom-y y :atom-z z
		   :atom-occupancy occupancy
		   :atom-temperature-factor tempFactor
		   :atom-element element
		   :atom-charge charge)))


