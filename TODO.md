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

## Phase 0 — Design decisions — RESOLVED

- [x] Confirm: "first" = `[lindex $ds9(active) 0]` (top, left-revealed),
      "second" = `[lindex $ds9(active) 1]` (bottom, right-revealed)
- [x] Confirm: hard pixel-edge clip for v1, no feathering at the boundary
- [x] 3D-frame handling: **reveal is unavailable if either active frame
      is type `3d`** — `RevealAvail` returns 0 and `DisplayMode` falls
      back. Note this is a deliberate product decision, not a technical
      limit: the clip lives in `Widget::displayProc` and `Frame3dBase`
      inherits `Widget`, so 3d frames were verified to clip correctly
      (tested directly — a 3d frame at `reveal 457` produced the same
      clean hard edge as a base frame). Unlike `fade`, which *must*
      special-case 3d because its `[$next get]` pixel-buffer composite
      has no 3d equivalent, reveal excludes 3d purely by choice.
- [x] Confirm colorbar/graphs stay tied to `current(frame)` only, same
      ambiguity `fade` already has today — confirmed in testing: the
      colorbar shows `current(frame)`'s colormap regardless of which
      side of the split is being looked at

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

## Phase 2 — C++: grammar wiring — DONE

Decision: use the `parser.Y`/`lex.L` grammar route, matching how `fade`
and every other frame subcommand are implemented, rather than the
`WidgetObjParse` direct-dispatch shortcut (considered, rejected for
consistency with the existing architecture — see note below).

Version risk (bison/flex): **retired.** The Mac's stock toolchain is
bison **2.3** and flex **2.6.4**, which are exactly the versions stamped
in the checked-in `parser.C` (`made by GNU Bison 2.3`) and `lex.C`
(`YY_FLEX 2.6.4`). Verified empirically before editing anything: ran
`make parser` with no source changes and `git diff` was **zero lines**
across `parser.C`/`lex.C`/`parser.H` — regeneration is byte-identical,
so any diff is only our own change. No Homebrew bison on `PATH`; keep it
that way, since bison 3.x would rewrite these files wholesale.

- [x] Add `REVEAL_` token to `tksao/frame/lex.L` — `reveal {return
      REVEAL_;}`, placed alphabetically after `resolution` (`lex.L:300`)
- [x] Add `%token REVEAL_` to `tksao/frame/parser.Y` (`parser.Y:380`,
      after `RESOLUTION_`)
- [x] Add `| REVEAL_ reveal` to the top-level `command` list
      (`parser.Y:542`)
- [x] Add grammar rule (`parser.Y:2905`, alphabetically before `rgb`):
      `reveal : INT {fr->revealCmd($1);} | CLEAR_ {fr->revealClearCmd();}`
      — `fr` is `Base*` and `class Base : public Widget` (`base.h:82`),
      so this resolves directly to the Phase 1 `Widget::revealCmd`; no
      virtual stub in `base.h` (unlike `fadeCmd`/`fadeClearCmd` at
      `base.h:814`)
- [x] Regenerated via `make parser` from `tksao/` — bison reported no
      grammar conflicts; diff confined to the 5 expected files
      (`lex.L`, `parser.Y` + generated `lex.C`, `parser.C`, `parser.H`);
      no unrelated parsers touched
- [x] Rebuilt (`make tksaoclean tksao ds9clean ds9`) — no errors. The
      one warning in `parser.C` (`variable 'frnerrs' set but not used`)
      is pre-existing bison boilerplate; every untouched generated
      parser (`ciaoparser.C`, `saoparser.C`, ...) emits its own copy.
- [x] Smoke-tested live over XPA (see Testing notes below) — grammar
      accepts, clip renders, `clear` round-trips

Deviation from the original plan — **`INT`, not `numeric`**: the draft
rule mirrored `fade`, but `numeric` is `%type <real>` (double) matching
`fadeCmd(float)`, whereas `revealCmd(int)` takes an int. Bare `INT`
(`%token <integer>`) is well-precedented here for integer setters
(`threadsCmd`, `binDepthCmd`, `irafAlignCmd`). Used `INT` — no cast
needed.

**Carry-forward for Phase 4:** because the rule takes `INT`, the Tcl
side must pass an integer. `$fr reveal [expr {int($frac*$w)}]`, never a
bare float — `reveal 1.5` is a hard `syntax error` at runtime
(verified). This is the one sharp edge the `INT` choice introduces.

Build gotcha (applies to any future `.Y`/`.L` change): `make parser` is
a **dependency-free phony target** (`tksao/Makefile.in:232`) — plain
`make tksaoclean tksao` does *not* regenerate. The correct sequence is
`make parser` from `tksao/` first, then `make tksaoclean tksao ds9clean
ds9` from the top. Use the narrow `parser` target, not `make parsers`,
which would regenerate every grammar in the tree and invite unrelated
drift.

Note: `WidgetObjParse` (`tksao/widget/widget.C:174-204`) does special-
case `config`/`pdf` via plain `strcmp` before falling through to the
bison-generated grammar, which would have let `reveal` skip bison/flex
entirely. Not used here — grammar-based wiring keeps `reveal` consistent
with `fade` and the rest of the frame command surface.

## Phase 3 — Tcl: display-mode plumbing (`ds9/library`) — DONE

- [x] Add `RevealDef` (`layout.tcl`, alphabetically between `FadeDef`
      and `TileDef`; registered in `ds9.tcl`'s init list before
      `RGBDef`). State: `reveal(split)` = split as a **fraction** of
      frame width (default `.5`, backed up to `preveal` for Phase 7),
      and `ireveal(split)` = the applied split in **canvas pixels**,
      `-1` when no clip is applied.
- [x] Add `reveal` case to `DisplayMode` (`frame.tcl`), gated on a new
      `RevealAvail` helper. Fallback: exactly 2 non-3d active frames →
      `reveal`; more than 1 active frame otherwise → `tile`; else →
      `single`.
- [x] Add `reveal` handling to the layout switch — `LayoutFrameReveal`
      in `layout.tcl`, mirroring `LayoutFrameOne`'s per-frame loop
      (both frames configured identically full-size, fully overlapping)
      but showing **both** frames via a new `RevealRaise`, then applying
      the clip via `RevealUpdateClip`. Colorbar/graphs follow
      `current(frame)` only, exactly as `single` does.
- [x] Update `GotoFrame` so switching `current(frame)` in reveal mode
      doesn't hide either frame (`reveal -` added to the `tile {}`
      no-hide branch) and doesn't `LayoutRaise $current(frame)` — that
      would put the second frame above the first and destroy the
      stacking the clip depends on. Calls `RevealRaise` instead.

Supporting helpers added: `RevealAvail` (`frame.tcl`, next to
`BlinkTimer`/`FadeTimer`), and `RevealRaise` / `RevealUpdateClip` /
`RevealClear` (`layout.tcl`, next to `LayoutFrameReveal`).

Implementation notes:
- `RevealUpdateClip` does the fraction → pixel conversion and the
  `int()` rounding the Phase 2 `INT` grammar rule requires, and clamps
  to `[0,width]`. Phase 4's slider should set `reveal(split)` and call
  this rather than talking to the frame command directly.
- `RevealClear` walks `$ds9(frames)`, not `$ds9(active)`, so a frame
  that was clipped and then deactivated cannot keep a stale clip.
- The clear-on-exit in `DisplayMode` is guarded on
  `$ireveal(split) != -1`. Without the guard it would call
  `revealClearCmd` — and therefore `redraw()` — on every frame on
  *every* `DisplayMode` call, including for users who never touch
  reveal.
- Falling back to `tile` (rather than `single`) when there are >2 active
  frames is a judgement call: there are multiple frames worth showing,
  so tile is the closer intent. <2 frames falls back to `single`,
  matching what `blink`/`fade` already do.

Verified live (two frames, same FITS, different colormaps so the split
is unambiguous):
- [x] Entering reveal splits the canvas correctly — left half frame 1,
      right half frame 2, hard edge at the split
- [x] Moving `reveal(split)` to .25 / .5 / .6 / 0.0 / 1.0 tracks
      correctly, including both extremes
- [x] Round-trip reveal → tile → reveal → single → reveal all restore
      correctly; `ireveal(split)` goes to `-1` on every exit and the
      chosen split is remembered across the round trip
- [x] `GotoFrame` between the two frames keeps both shown, preserves
      stacking, and leaves the clip untouched
- [x] Dynamic fallback: adding a 3rd frame **while in reveal** drops to
      `tile` and clears the clip automatically (via `UpdateActiveFrames`
      → `DisplayMode`); deleting back to 2 restores reveal
- [x] Fallbacks by state: 1 active → `single`; 3 active → `tile`;
      2 active with one `3d` → `tile`

**Carry-forward for Phase 6:** `iconsbottom.tcl` defines
`icons(currentdisplay,single|tile|blink|fade)` and an
`icons(currentdisplay,default)`. There is no `reveal` entry, so the
bottom icon bar's layout menubutton falls back to the *single* icon
while reveal is active. It degrades gracefully (no error), but Phase 6
should add `icons(currentdisplay,reveal)` and the matching
`$mb.layout.m entryconfig` line.

## Phase 4 — Tcl: slider UI — DONE

- [x] Bare `ttk::scale` (not the composite `slider.tcl` widget, which is
      a label+scale+entry+ticks assembly meant for dialogs), embedded
      via `canvas create window`, spanning the frame width at the bottom
      edge of the frame bbox, repositioned on every layout pass
- [x] Slider `-command` → `RevealSliderCmd`, which sets `reveal(split)`
      and calls `RevealUpdateClip` (the Phase 3 proc already handles the
      fraction → pixel conversion, `int()` rounding and clamping)
- [x] Show/hide across mode changes and resize
- [x] Drag-event rate evaluated — see below

Widget is `$ds9(main).revealslider`, parented to `ds9(main)` rather than
the canvas, matching how the graphs are parented. Created lazily on
first show, since `ds9(main)` does not exist yet when `RevealDef` runs.

Deviation from the plan — **show/hide follows `GraphShow`/`GraphHide`,
not `LayoutViewInit`'s pack/forget.** Panner and magnifier are
grid/pack-managed panels in the `ds9(main)` grid; the slider is a canvas
window item, so the right analogue is the graphs' create-window/delete
pattern: `RevealSliderHide` deletes the canvas item (keeping the widget
for reuse) and is called from `LayoutFrames` alongside `colorbar hide`
and `GraphHide`, while `RevealSliderShow` re-creates it from
`LayoutFrameReveal`. That way every mode change and every resize goes
through the existing hide-everything-then-show-what-is-needed pass with
no special-casing.

Note `raise $sl` after placing it: as the graph code already comments,
canvas `raise` has no effect on window items, and embedded Tk windows
always float above canvas items — so the slider is never occluded by
either frame.

**Two-way sync.** `RevealUpdateClip` also moves the thumb, via
`RevealSliderSync`. Without this the thumb only tracked `reveal(split)`
on a layout pass, so setting the split from anywhere else left the
slider visibly wrong — found by screenshot: the clip sat at 50% while
the thumb was pinned to the far right. This matters for Phase 6 (an XPA
command setting the split) and Phase 7 (a restored pref). Two flags keep
it from chasing its own tail: `ireveal(slider,sync)` makes
`RevealSliderCmd` ignore the callback that `[$sl set]` triggers, and
`ireveal(slider,fromslider)` stops `RevealUpdateClip` from pushing the
thumb back at the user mid-drag.

**Drag rate: no coalescing needed.** Measured on this Mac:

| | ms/update | sustainable rate |
|---|---|---|
| `RevealUpdateClip` alone | 0.009 | — |
| full redraw, 900x650 canvas | 3.6 | ~280/sec |
| full redraw, 1600x707 canvas @ zoom 40 | 8.8 | ~113/sec |

Even the large-canvas worst case clears the 60-120 events/sec a mouse
drag can produce, so the `MotionDispatch` coalescing the plan floated
(`layout.tcl:363`, Aqua-only) is unnecessary. The reason it is this
cheap is Phase 1's choice to call `redraw()` rather than
`invalidPixmap()` — dragging re-blits cached pixmaps instead of
re-rendering them. If that ever changes, revisit this.

**Carry-forward for Phase 8:** the slider occupies the bottom
`ireveal(slider,height)` (18) pixels of the frame area, so clicks there
hit the slider rather than the frame. Worth confirming this does not get
in the way of region creation/editing near the bottom edge of the image.

## Phase 5 — Tcl: demarcation bar — DONE

- [x] `view(reveal,bar)` boolean in `ViewDef` (default on), so it rides
      along in `pview` with the other view toggles
- [x] Canvas line item at the split, full frame height, raised above
      both frames, shown/hidden per the pref — `RevealBarUpdate` /
      `RevealBarHide` in `layout.tcl`
- [x] Toggle wired to a `Reveal Bar` checkbutton in `FrameMainMenu`
      (`mframe.tcl`), just below the display-mode radiobuttons

Appearance lives in `reveal(bar,color)` (default `cyan`, following
`threed(highlite,color)`, the closest existing precedent for a UI
overlay line) and `reveal(bar,width)` (default 1). Only the on/off
boolean is exposed in the menu; the colour/width are prefs with no UI
yet. Note the pref is deliberately split across two arrays — the
visibility toggle in `view` with the other view toggles as the plan
specified, the appearance in `reveal` with the rest of the reveal state.

`RevealBarUpdate` is called from the tail of `RevealUpdateClip`, so the
bar follows the split for free on drags, layout passes and resizes
without a separate update path. `RevealBarHide` is called from
`LayoutFrames` next to `RevealSliderHide`.

The bar is **not** tagged `graphic`. That tag marks user illustrate
items and is what `LayoutRaise` treats as its ceiling; tagging the bar
with it would pull a piece of chrome into the illustrate machinery. It
gets an explicit `$ds9(canvas) raise` instead, which puts it above both
frames. The slider is a canvas *window* item and so still floats above
the bar, which is the wanted order.

No `TileDialog`-style "Reveal Parameters" dialog was added — the single
boolean did not justify one. If colour/width ever want UI, that is the
moment to build it.

Verified live with **two frames sharing one colormap** (grey/grey,
different zoom), so the bar is the only thing marking the split:
- [x] Bar drawn full height at the split, clearly visible over both
      frames, slider thumb aligned directly beneath it
- [x] Toggling `view(reveal,bar)` off deletes the item, on recreates it
- [x] Bar tracks the split while the slider moves (x=180 at .2, x=720
      at .8)
- [x] Leaving reveal removes the bar; re-entering restores it at the
      remembered split
- [x] Menu entry present and correctly wired
      (`checkbutton "Reveal Bar" var=view(reveal,bar) cmd=RevealBarUpdate`)

**Carry-forward for Phase 7:** `view(reveal,bar)` is already inside
`pview` via `ViewDef`, so it should round-trip with the existing view
prefs. `reveal(split)`, `reveal(bar,color)` and `reveal(bar,width)` land
in `preveal`, which is a **new array that still needs registering** in
`prefs.tcl`.

## Phase 6 — Menu / command integration — DONE

- [x] `Reveal Frames` radiobutton in `FrameMainMenu` (`mframe.tcl`),
      after `Fade Frames`
- [x] Bottom icon bar (`iconsbottom.tcl`): `IconMenuButton` entry, the
      `icons(currentdisplay,reveal)` image, and the `entryconfig 4` line
- [x] New `frame_reveal.png` icon, both light and dark themes
- [x] XPA/SAMP/command-line parity via a new `reveal` command

There is **no generic `display <mode>` path** — the plan assumed one.
Each mode is its own access point (`xpaset ds9 blink`, `... tile`), so
reveal needed its own. Command surface:

| command | effect |
|---|---|
| `xpaset -p ds9 reveal` | enter reveal mode |
| `xpaset -p ds9 reveal yes\|no` | enter / leave (leave → single) |
| `xpaset -p ds9 reveal split 0.25` | set split, as a fraction |
| `xpaset -p ds9 reveal bar yes\|no` | toggle the demarcation bar |
| `xpaget ds9 reveal` | `yes`/`no` |
| `xpaget ds9 reveal split` | the fraction |
| `xpaget ds9 reveal bar` | `yes`/`no` |

Also reachable as `-reveal` on the command line and over SAMP.

New files: `ds9/parsers/revealparser.tac`, `reveallex.fcl`,
`revealsendparser.tac`, `revealsendlex.fcl`. Touched: `frame.tcl`
(`ProcessRevealCmd`, `ProcessSendRevealCmd`, `RevealSendCmd`,
`RevealSendCmdSplit`, `RevealSendCmdBar`), `xpa.tcl` (`xpacmdadd` +
`XPASendReveal`/`XPARcvdReveal`), `comm.tcl` (both the set and get
switches — this is what SAMP dispatches through, via `CommSet`/
`CommGet` at `samp.tcl:785,814`), `command.tcl` (`-reveal`).

### Notes on the Tcl parser toolchain

Unlike the C++ side, this is **self-contained and automatic**. `ds9/
make.include` has wildcard-driven pattern rules
(`SRCP = $(wildcard .../*.tac)`), so dropping in new `.tac`/`.fcl`
files is enough — no file list to update. The rules run
`taccle -p <ns> -d` and `fickle -P <ns>`, then prepend
`package provide DS9 1.0`, and `pkg_mkIndex` re-runs. Never hand-run
the generators and commit the output; let `make ds9` own the generated
`.tcl`/`.tab.tcl`.

Two gotchas worth recording:
- The bundled `taccle`/`fickle` report versions 1.4/2.2 while the
  checked-in generated files say 1.3/2.1. This is **cosmetic only** —
  confirmed with the maintainer that the version was bumped after the
  fact with no code change, and a no-op regen showed the generated body
  byte-identical apart from the banner.
- `yes-no.trl` (nonterminals `yes`/`no`) and `yesno.trl` (nonterminal
  `yesno`) cannot both be included — they derive from the same tokens
  and no existing `.tac` includes both. `revealparser.tac` uses
  `yes-no.trl` plus a two-line local `revealBar` rule instead. Verified
  conflict-free with `taccle -w -v`.

The `reveal` parser namespace coexists with the global `reveal(...)`
array. That looks alarming but is the established pattern — `blink`,
`tile` and `fade` all do exactly the same thing.

Verified live:
- [x] Every row of the command table above, set and get, including that
      the split survives leaving and re-entering reveal
- [x] `xpaset -p ds9 reveal split 0.25` drives the whole chain
      coherently: `reveal(split)=0.25`, clip at 227px, slider thumb at
      0.25, bar at x=227
- [x] Menu entries present and wired (`radiobutton "Reveal Frames"
      value=reveal`, `checkbutton "Reveal Bar"`)
- [x] Icon bar: 5 entries with `Reveal` at index 4, and the menubutton
      correctly switches to the reveal icon when the mode is active
- [x] `ds9 -frame new f.fits -frame new f.fits -frame delete 1 -reveal`
      starts directly in reveal mode

Not tested live: the **SAMP** path, which needs a running hub. It is
wired through the same `comm.tcl` switches as `blink`/`fade`, so it is
correct by symmetry, but it has not been exercised.

### Documentation

- [x] `ds9/doc/ref/xpa.html`, `samp.html`, `command.html` — a `reveal`
      entry each, in the same Syntax/Example shape as `blink`/`fade`,
      alphabetically between `restore` and `rgb`, with the matching
      index link. Note the reference docs live in `doc/ref`, not
      `doc/reference`.
- [x] `ds9/doc/release/r8.8.html` — a Beta 2 highlight plus a
      "Reveal frames" subsection under user-facing details. These notes
      are maintained per-feature this cycle (the recent grid dash-list
      work is already in them), so a new display mode belongs there.

The reveal entries are wordier than `fade`'s one-liner on purpose:
reveal has a precondition (exactly two active, non-3d frames) and
silently falls back when it is not met, so that has to be stated.

Docs are copied into the bundle by `make ds9` via
`$(LIBDIR)/doc : $(prefix)/ds9/doc` — no file list to update.
Rendering of both the ref entry and the release note was checked in a
browser, not just grepped.

## Phase 7 — Persistence — DONE

- [x] `prefs.tcl` — `reveal`/`preveal` block in `SavePrefs`, alongside
      `blink`/`fade`/`tile`
- [x] `backup.tcl` — `reveal`/`preveal` block in `BackupGUI`, same
      neighbourhood
- [x] Preferences dialog (`mframe.tcl`, `PrefsDialogFrameMenu`) —
      a `Reveal Frames` radiobutton for `pcurrent(display)`, and a
      `Frame Parameters` &rarr; `Reveal` cascade with a `Show Bar`
      checkbutton (`pview(reveal,bar)`) and a `Bar Color` menu
      (`preveal(bar,color)`)

Nothing was needed for `pcurrent`/`pview` themselves — `pcurrent(display)`
already exists from `CurrentDef`, and `view(reveal,bar)` has ridden in
`pview` since Phase 5, both via the whole-array save.

Two arrays, two jobs, and it matters which is which:
- `preveal`/`pview`/`pcurrent` are **startup defaults**, edited by the
  Preferences dialog and written to `~/.ds9/ds9.<ver>.prf`.
- `reveal`/`view`/`current` are **live session state**, written into
  `.bck` session files.
This is the existing ds9 split, not something reveal invents: a slider
drag changes `reveal(split)` but deliberately does not touch
`preveal(split)`, exactly as toggling `View` &rarr; `Colorbar` does not
change `pview(colorbar)`.

`FixVar pcurrent(display) ds9(display,user)` (`prefs.tcl:1071`) is
old-prefs migration only and needed no change.

Session restore works because `BackupRestore` ends with
`LayoutView` &rarr; `UpdateActiveFrames` &rarr; ... and
`UpdateActiveFrames` finishes by calling `DisplayMode`. So a restored
`current(display) reveal` is re-derived through the `RevealAvail` gate
rather than being trusted blindly — restoring a reveal session into a
state that no longer qualifies falls back cleanly.

Note `pcurrent(display)` can now be `reveal`, which means ds9 can start
up wanting reveal with 0 or 1 frames. That is safe: `DisplayMode` falls
back to `single`, same as it already does for `blink`/`fade`.

Verified live:
- [x] **Session round-trip.** Saved a `.bck` with a deliberately
      non-default state (split `0.31`, bar off). The file contains
      `current(display) reveal`, `view(reveal,bar) 0`,
      `reveal(split) 0.31`, with `preveal`/`pview` still holding the
      defaults. Restoring into a fresh ds9 came back with reveal
      active, split `0.31`, bar off, both frames present.
- [x] **Restored state is internally coherent**, not just the reported
      values: `ireveal(split)` = 282 on a 910px frame (= `int(910*.31)`),
      the slider exists with its thumb at `0.31`, and the bar item is
      absent because the pref is off.
- [x] **Prefs round-trip.** Set `preveal(split) .42`,
      `preveal(bar,color) magenta`, `pview(reveal,bar) 0`, saved, and
      restarted: all three came back. (The real
      `~/.ds9/ds9.8.8.prf` was copied aside first and restored
      byte-identically afterwards — do the same if you re-run this.)
- [x] Preferences dialog entries present and bound to the right
      variables (`Reveal Frames` &rarr; `pcurrent(display)`,
      `Show Bar` &rarr; `pview(reveal,bar)`, `Bar Color` &rarr;
      `preveal(bar,color)`, 11 colours)

## Phase 8 — Testing — MOSTLY DONE

### Regression tests added to the suite

`Tests/` is a **separate git repo** (`SAOImageDS9/Tests`), untracked by
the main repo, so these changes are uncommitted *there*, not here.

- [x] `Tests/xpa.sh` — a `reveal` block (alphabetical, before `rgb`)
      exercising get of `reveal`/`reveal split`/`reveal bar` and set of
      every verb, plus a golden file `Tests/xpa/reveal.xpa`
      (`no` / `.5` / `yes`)
- [x] `Tests/command.sh` — a `reveal` block covering `-reveal`,
      `-reveal yes|no`, `-reveal split`, `-reveal bar`
- [x] `Tests/samp.sh` + new `Tests/samp/reveal.samp` — the same verbs
      over SAMP

Run individually (do **not** run the whole suite — it is slow and hits
external services):

```
cd Tests
PATH=/path/to/reveal/bin:$PATH sh xpa.sh reveal
PATH=/path/to/reveal/bin:$PATH sh command.sh reveal
PATH=/path/to/reveal/bin:$PATH sh samp.sh reveal
```

All three pass. The xpa golden file was checked to be a real assertion,
not a vacuous one: corrupting it to `.99` produces `FAILED` with a diff,
and restoring it produces `PASSED`. Note `command.sh`'s `doit` prints
`PASSED` unconditionally by design — it is a smoke test that ds9 accepts
the options and exits, not an output assertion.

Caveat: `Tests/samp.tcl` hardcodes source paths into a **sibling
checkout** (`/Users/kjg/DS9/SAOImageDS9/...`). Those files are SAMP
client plumbing, unrelated to reveal, so the test is valid — but the
harness will not run without that checkout present.

### Verified

- [x] **SAMP** — the Phase 6 hold-out. `get reveal` &rarr; `no`,
      `get reveal split` &rarr; `.5`, `get reveal bar` &rarr; `yes`, and
      every setter returns `samp.ok`. No longer "correct by symmetry".
- [x] **Hit-testing across the split** — the direct validation of the
      Phase 1 `pointProc`/`areaProc` change. With the split at 455,
      canvas `find closest` returns the *first* (clipped, top) frame at
      x=453 and the *second* frame at x=457. `find overlapping` and
      canvas focus agree. So the clipped-away region of the top frame
      really does read as "outside" and events fall through to the
      frame beneath.
- [x] Two frames, different zoom/pan/colormap — hard clip correct at
      0.0 / .25 / .5 / .6 / .75 / 1.0
- [x] Window resize in reveal mode — slider length and position and the
      clip all rescale (the split is a fraction, so it survives)
- [x] Fallbacks: 1 / 3 active frames and a 3d frame, including the
      dynamic case where the count changes while reveal is active
- [x] **Round-trip reveal ↔ single / tile / blink / fade** — on every
      exit `ireveal(split)` returns to -1 and the bar and slider canvas
      items are deleted; on re-entry all three come back at the
      remembered split. Blink and fade timers start and stop correctly
      across the transitions.
- [x] Session save/restore and prefs round-trip (Phase 7)

### Still needs a human with a mouse

Synthetic `event generate` input proved unreliable against Tk's canvas
current-item tracking — it fired the frame bindings once and then
stopped, at identical coordinates, with the bindings, hit-test, focus
and button-state flags all verified correct in between. A control in
`single` mode created a region from the same synthetic drag, so the
harness itself works; the flakiness is in synthetic-vs-real pointer
events, not in reveal. These two therefore remain unverified:

- [ ] Region create / select / edit **interactively** on both sides of
      the split, with a real mouse
- [ ] Region work near the **bottom edge**, where the slider overlays
      the lowest 18 pixels of the frame

Worth knowing while testing that by hand: `Button1Frame`
(`frame.tcl`) is click-to-focus. Clicking a frame that is not
`current(frame)` only calls `GotoFrame` and returns — the region is
created on the *second* click. In reveal this means the first click
after crossing the split switches frames and the next one draws. That
is pre-existing behaviour shared with tile mode, not something reveal
introduces, but it is more noticeable here because the two frames
occupy the same screen area.
