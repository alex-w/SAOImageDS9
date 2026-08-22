# Agent notes for building SAOImageDS9 from source

This repo is built from this top-level directory. A full build takes
10+ minutes, so prefer the targeted rebuild commands below whenever
possible instead of rebuilding everything from scratch.

## Rebuilding after code changes

- Changed files under `tksao/` (the C++ canvas-item rendering code:
  frames, colorbar, panner, magnifier, etc.)?

  ```
  make tksaoclean tksao ds9clean ds9
  ```

- Changed files under `ds9/` (the Tcl/Tk UI library and app code)?

  ```
  make ds9clean ds9
  ```

`ds9` links against `tksao`, so a `tksao` change requires relinking
`ds9` afterward — the first command handles both in the right order.
Don't fall back to a full top-level rebuild just because a change
touched C++ code; these targeted clean+build pairs are the normal
workflow here.

## Parser/lexer changes (bison/flex)

Several `tksao` subsystems (e.g. `tksao/frame/parser.Y` + `lex.L`) have
generated `.C` files checked in, regenerated via `bison`/`flex` rules in
`tksao/Makefile.in`. These are pickier to rebuild correctly — treat
changes to any `.Y`/`.L` grammar file as needing extra care/verification
beyond the targeted commands above; confirm the specific regen steps
before assuming `make tksaoclean tksao` alone picks them up.
