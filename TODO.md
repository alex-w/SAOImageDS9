# "Reveal" Frame Layout Mode — Implementation TODO

Goal: a new `ds9(display)` mode, `reveal`, available only when exactly two
frames are active. The two frames fully overlap; the first frame (top,
`[lindex $ds9(active) 0]`) is revealed on the left, the second frame
(bottom, `[lindex $ds9(active) 1]`) is revealed on the right, split by a
draggable slider at the bottom of the frame area. An optional vertical bar
marks the split line.

## Architecture decision

Implemented as a **canvas-blit clip**, not a pixel-buffer composite (like
`fade` uses). Both frames stay fully rendered and genuinely `show`n,
stacked with the first raised above the second. The first frame's final
pixmap-to-canvas blit (`Widget::displayProc`) is clipped to `[0, splitX)`;
the second frame is left unclipped and shows through wherever the first
doesn't paint. Because each frame's regions/markers are already drawn onto
its own pixmap before this blit step, they get clipped at the split
automatically — no changes needed to marker-drawing code.

This supersedes an earlier idea of reusing `fade`'s `alphaComposite`
mechanism (uniform alpha blend of two full-image buffers via a shared
`frameptr_` global) — that approach could not cleanly clip regions, since
markers are drawn onto the pixmap *after* that composite step.

## Phase 0 — Design decisions

- [ ] Confirm: "first" = `[lindex $ds9(active) 0]` (top, left-revealed),
      "second" = `[lindex $ds9(active) 1]` (bottom, right-revealed)
- [ ] Confirm: hard pixel-edge clip for v1, no feathering at the boundary
- [ ] Decide 3D-frame handling: reveal unavailable if either active frame
      is type `3d` (mirrors `fade`'s existing exclusion in `FadeTimer`)
- [ ] Confirm colorbar/graphs stay tied to `current(frame)` only, same
      ambiguity `fade` already has today

## Phase 1 — C++: the clip primitive (`tksao/widget`) — DONE

- [x] Add a clip field to `Widget` (`int revealWidth`, `-1` = disabled;
      plain class member, not a `Tk_ConfigSpec` option, so it bypasses
      `configure()`'s automatic `invalidPixmap()`) — `widget.h`,
      initialized in the `Widget` constructor in `widget.C`
- [x] Extend `Widget::displayProc` to intersect `pmX/pmWidth` with
      `revealWidth` when set, and bail out early if the clipped width/
      height is `<= 0` (avoids a zero/negative-size `XCopyArea`)
- [x] Add `Widget::revealCmd(int width)` — sets the field, calls
      `redraw()` (**not** `invalidPixmap()`, so dragging re-blits cached
      pixmaps instead of re-rendering)
- [x] Add `Widget::revealClearCmd()` — disables the clip, calls `redraw()`
- [x] Extend `Widget::pointProc`/`areaProc` so the clipped-away region
      reads as "outside" the item, via an effective `x2` clamped to
      `item.x1 + revealWidth` — fixes hit-testing/region-editing on the
      revealed side of the top frame
- [x] Rebuilt (`make tksaoclean tksao ds9clean ds9`) — compiles clean, no
      new warnings in `widget.C`, `bin/ds9` runs

Notes for later phases:
- `revealWidth` and the Tcl-facing `revealCmd`/`revealClearCmd` live on
  the base `Widget` class (not `FrameBase`/`Base`), since clipping the
  final canvas blit is subtype-agnostic — no FITS/pixel-format-specific
  code needed, unlike `fade`. `Base` (used as the grammar's `Base* fr`
  parse-param type) inherits from `Widget`, so Phase 2's grammar rule can
  call `fr->revealCmd($1)` directly — no virtual stub needed in `base.h`
  the way `fadeCmd`/`fadeClearCmd` required.
- Not yet wired to anything — no Tcl grammar/command exposes `revealCmd`/
  `revealClearCmd` yet (that's Phase 2). This phase only proves the
  primitive compiles and the existing render/hit-test paths are
  untouched when `revealWidth == -1` (the default, so no behavior change
  for existing display modes).

## Phase 2 — C++: command wiring — REVISED, avoids bison/flex

Original plan (grammar rule in `parser.Y`/`lex.L`, regenerated via
`bison`/`flex`) is on hold: those generated files are tied to an old
bison version (the one macOS ships), and upgrading them is a known can
of worms — do not touch `.Y`/`.L` files for this feature.

Workaround found instead: `WidgetObjParse` (`tksao/widget/widget.C:174-
204`) — the single dispatch point every frame Tcl subcommand passes
through — already special-cases `config` and `pdf` via plain
`strcmp`/`strncmp` on `objv[1]`, handled directly in C++ *before*
falling through to the bison-generated `parse()` grammar in its `else`
branch. `reveal` can be added the same way, as a third special case,
with zero grammar/bison/flex involvement. (Note: `WidgetParse`, the
non-`Obj` sibling, is dead code — declared but never registered with
Tcl — so only `WidgetObjParse` needs the new case.)

- [ ] Add a `reveal` special case to `WidgetObjParse`
      (`widget.C:174-204`), alongside the existing `config`/`pdf` cases:
      `reveal <width>` → `revealCmd(width)`, `reveal clear` →
      `revealClearCmd()`
- [ ] Rebuild via `make tksaoclean tksao ds9clean ds9`, confirm clean
      compile (same workflow as Phase 1 — no bison/flex step needed)

## Phase 3 — Tcl: display-mode plumbing (`ds9/library`)

- [ ] Add `RevealDef` (default state vars) alongside `TileDef`/`BlinkDef`/
      `FadeDef` in `layout.tcl`
- [ ] Add `reveal` case to `DisplayMode` (`frame.tcl:2133`), with fallback
      to `single`/`tile` when active-frame count ≠ 2 or either is `3d`
- [ ] Add `reveal` handling to the layout switch (`layout.tcl:793`) — lay
      out **both** active frames identically full-size (reuse
      `LayoutFrameOne` sizing), `show` both, `LayoutRaise` first above
      second, initialize the clip via `[first] reveal <width>`
- [ ] Update `GotoFrame`'s per-mode branch (`frame.tcl:2072-2096`) so
      switching `current(frame)` in reveal mode doesn't hide either frame
      — only affects colorbar/info panel target

## Phase 4 — Tcl: slider UI

- [ ] New slider control (bare `ttk::scale`, not the heavier `slider.tcl`
      widget) embedded via `canvas create window`, positioned at the
      bottom edge of the frame bbox, resized in `LayoutView`/`LayoutFrames`
- [ ] `RevealUpdate` proc wired to `-command`: convert slider fraction →
      pixel `splitX`, call `[first] reveal $splitX`, move the
      demarcation line
- [ ] Show/hide slider (and destroy/recreate on resize) mirroring how
      panner/magnifier are packed/forgotten in `LayoutViewInit`
- [ ] Evaluate drag-event rate; adapt the existing `MotionDispatch`
      coalescing pattern (`layout.tcl:363`, currently Aqua-only) to all
      platforms if dragging feels choppy — likely a non-issue now since
      redraw is cheap, but worth checking on a large image

## Phase 5 — Tcl: demarcation bar

- [ ] Add `view(reveal,bar)` pref (boolean) in `ViewDef`
- [ ] Canvas line item at the slider's x-position, raised above both
      frames, shown/hidden per the pref
- [ ] Toggle wired into a menu checkbutton (and/or a small "Reveal
      Parameters" dialog, modeled on `TileDialog`)

## Phase 6 — Menu / command integration

- [ ] Add `Reveal Frames` radiobutton to `FrameMainMenu` in `mframe.tcl`
      (`-variable current(display) -value reveal`)
- [ ] Add XPA/SAMP parity: confirm `display reveal` flows through the
      existing generic mode-set path; add `Process*Cmd`/`SendCmd` pairs
      for slider position if it should be scriptable (pattern at
      `frame.tcl:2657-2730` for blink/fade)

## Phase 7 — Persistence

- [ ] Add reveal state to `prefs.tcl` backup/restore arrays (`pcurrent`,
      `pview`) so Edit ▸ Preferences and session save/restore round-trip
      it
- [ ] Add to `backup.tcl` if display mode is serialized into `.bck`/
      session files

## Phase 8 — Testing

- [ ] Two frames, different zoom/pan/colormap — verify hard clip is
      visually correct at slider extremes and midpoint
- [ ] Region creation/selection/editing on **both** sides of the split
      (validates the `pointProc` fix)
- [ ] Window resize while in reveal mode (canvas `<Configure>` →
      `LayoutView`)
- [ ] Fallback correctness: 0/1/3+ active frames, and a `3d` frame present
- [ ] Round-trip toggling reveal ↔ tile/blink/fade/single (confirm
      `revealClearCmd` runs on exit, no stale clip)
- [ ] Session save/restore with reveal active
