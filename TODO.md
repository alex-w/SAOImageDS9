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

## Phase 6 — Menu / command integration

- [ ] Add `Reveal Frames` radiobutton to `FrameMainMenu` in `mframe.tcl`
      (`-variable current(display) -value reveal`), alongside the
      `Fade Frames` entry — Phase 5 already added a `Reveal Bar`
      checkbutton just below that group
- [ ] Add `icons(currentdisplay,reveal)` in `iconsbottom.tcl` plus the
      matching `$mb.layout.m entryconfig` line; without it the bottom
      icon bar shows the *single* icon while reveal is active (it
      degrades via `icons(currentdisplay,default)`, so this is cosmetic)
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

Already validated during Phase 2 (single frame, via the XPA `tcl` entry
point — see "How to smoke-test" in `AGENTS.md`):

- [x] Grammar acceptance: `reveal 400` → ok, `reveal 0` → ok,
      `reveal clear` → ok; negative controls `reveal bogus` and
      `reveal 1.5` both correctly fail with `syntax error`, proving the
      rule is genuinely parsing rather than silently swallowing input
- [x] The clip actually renders: loaded `funtools/funtest/test.fits`
      into a 914x480 frame, `reveal 457` produced a hard pixel edge at
      x=457 with the left half fully intact and the right half absent —
      confirms Phase 1's `displayProc` clip end-to-end
- [x] `reveal clear` restores rendering **byte-identically** to the
      pre-clip PNG capture (same sha256) — no stale clip, which is the
      Phase 8 "round-trip toggling" item's core concern at the C++ level

Also validated during Phase 3 (two frames, live):

- [x] Two frames with different colormaps — hard clip visually correct
      at 0.0 / .25 / .5 / .6 / 1.0
- [x] Fallback correctness: 1 / 3 active frames, and a `3d` frame
      present — including the dynamic case where the frame count changes
      while reveal is already active
- [x] Round-trip toggling reveal ↔ tile/single — `revealClearCmd` runs
      on exit, `ireveal(split)` returns to -1, no stale clip

Still to do:

- [ ] Two frames, different zoom/pan/colormap — verify hard clip is
      visually correct at slider extremes and midpoint
- [ ] Region creation/selection/editing on **both** sides of the split
      (validates the `pointProc` fix)
- [ ] Region work near the **bottom edge** of the frame, where the
      slider overlays the lowest 18 pixels
- [ ] Window resize while in reveal mode (canvas `<Configure>` →
      `LayoutView`)
- [ ] Fallback correctness: 0/1/3+ active frames, and a `3d` frame present
- [ ] Round-trip toggling reveal ↔ **blink/fade** specifically (tile
      and single already covered above)
- [ ] Session save/restore with reveal active
