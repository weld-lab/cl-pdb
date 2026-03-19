# cl-pdb

`cl-pdb` is a Common Lisp library for reading, rebuilding, slicing, and writing `.pdb` files.

The project is built around a simple canonical model:

- a `pdb` contains `residue`
- a `residue` contains `atom`

The goal is not only to parse PDB lines one by one, but to reconstruct a usable in-memory representation that can then be queried, transformed, sliced, and written back.

## Current scope

`cl-pdb` currently provides:

- parsing of core structural records such as `ATOM`, `HETATM`, `HET`, `TITLE`, and `SEQRES`
- reconstruction of residues from atom-level records
- normalization of residue kinds (for example amino acids, waters, ions, lipids, unknown residues)
- simple residue and atom views
- a first writer for exporting a full `pdb` or a list of residues

The library is currently centered on manipulation and extraction. Audit/reporting tools are intended to be built on top of this core later.

## Architecture

The code is organized into a few explicit layers.

### `model/`

Stable domain objects.

- `atom.class.lisp`
- `residue.class.lisp`
- `title.class.lisp`
- `seqres.class.lisp`
- `pdb.class.lisp`

The main model exposed to users is:

- `pdb`
- `residue`
- `atom`

`title` and `seqres` are currently raw helper objects used during parsing/building.

### `parse/`

Low-level parsing of PDB records.

This layer turns one textual record into one small raw object.

Examples:

- `ATOM` -> `atom`
- `HETATM` -> `atom`
- `HET` -> `residue`
- `TITLE` -> `title`
- `SEQRES` -> `seqres`

Files:

- `common.lisp`
- `atom.lisp`
- `het.lisp`
- `hetatm.lisp`
- `title.lisp`
- `seqres.lisp`

### `reader/`

Reconstruction of the canonical `pdb` object.

This layer is responsible for:

- dispatching records through `ingest`
- grouping atoms into residues
- accumulating `TITLE`
- accumulating `SEQRES` by chain
- producing the final `pdb`

Files:

- `ingest.lisp`
- `build.lisp`
- `finalize.lisp`
- `read-pdb.lisp`

### `normalize/`

Simple residue normalization.

This currently assigns domain-level residue kinds such as:

- `:amino-acid`
- `:water`
- `:ion`
- `:lipid`
- `:unknown`

File:

- `residue-kind.lisp`

### `view/`

Simple views and slices over already-built structures.

This layer is intended to make `cl-pdb` convenient to use for extraction and manipulation.

Examples of current views:

- `residues-in-chain`
- `residues-of-kind`
- `residues-named`
- `hetero-residues`
- `unknown-residues`
- `atoms-of-residue`
- `atoms-in-chain`
- `atoms-of-kind`

The `pipe`, `pipe-residues`, and `pipe-atoms` macros are meant to make view composition more convenient.

### `writer/`

First writer implementation.

This layer currently supports writing:

- a full `pdb`
- a list of residues

Files:

- `write-pdb.lisp`

## Main entry points

### Read a PDB

```lisp
(defparameter *pdb* (pdb:read-pdb #P"example.pdb"))