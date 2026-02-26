# Hub UI Style System

This project now uses a reusable 2D UI framework for the hub:

- `res://ui/style/ui_palette.gd`
- `res://ui/style/ui_metrics.gd`
- `res://ui/style/ui_typography.gd`
- `res://ui/style/ui_theme_builder.gd`
- `res://ui/anim/ui_animator.gd`
- `res://ui/shaders/*.gdshader`

## Palette Tuning

Edit `res://ui/style/ui_palette.gd` and adjust `BASE` colors:

- `accent` and `accent_hot`: primary highlight + selected glow
- `panel`, `panel_alt`, `panel_focus`: core panel material stack
- `text`, `text_dim`: readability contrast
- `fog`: ambient particle tint

Accessibility variants are also defined there:

- `HIGH_CONTRAST`
- `COLORBLIND`

## Glow / Shader Tuning

### Core Rim Glow
File: `res://ui/shaders/ui_glow_rim.gdshader`

- `glow_strength`: global rim intensity
- `inner_glow`: center bloom amount
- `pulse_speed`, `pulse_amount`: pulsing behavior
- `rim_width`: rim thickness

### Tab Specular Sweep
File: `res://ui/shaders/ui_specular_sweep.gdshader`

- `intensity`: sweep brightness
- `sweep_width`: sweep band thickness
- `sweep_angle`: direction of the sweep

### Ring Sweep + Transition Wipe
File: `res://ui/shaders/hub_ring_sweep.gdshader`

- `ring_radius`, `ring_thickness`: ring geometry
- `sweep_speed`, `tick_count`, `tick_strength`: animated ring character
- `overlay_alpha`, `wipe_radius`, `warp_strength`: transition wipe behavior

### Vignette / Grain / Scanlines
File: `res://ui/shaders/vignette_grain.gdshader`

- `vignette_strength`: edge darkening
- `grain_strength`: film grain level
- `fog_strength`: drifting haze
- `scanline_strength`: scanline visibility
- `scanlines_enabled`: runtime toggle (0/1)

## Animation Timing

Edit `res://ui/style/ui_metrics.gd`:

- Hover/press/select timing:
  - `DUR_HOVER_IN`
  - `DUR_HOVER_OUT`
  - `DUR_PRESS`
  - `DUR_SELECT`
- Panel and transition timing:
  - `DUR_PANEL`
  - `DUR_TRANSITION`
- Interaction scale amounts:
  - `SCALE_HOVER`
  - `SCALE_PRESS`
  - `SCALE_SELECTED`

`res://ui/anim/ui_animator.gd` applies these values consistently to tabs and buttons.

## Typography

Edit `res://ui/style/ui_typography.gd`:

- `FONT_*` constants for sizing
- `FONT_CANDIDATES` to load a project font if available

If no listed font exists, it falls back safely to `ThemeDB.fallback_font`.

## Where It Is Applied

Hub entry point:

- Scene: `res://scenes/MainHub.tscn`
- Script: `res://scripts/ui/MainHub.gd`

`MainHub.gd` builds the UI at runtime and applies:

- Theme from `UIThemeBuilder.build_theme(...)`
- Animator helpers from `UIAnimator`
- Shader materials for core rings, specular sweeps, transitions, and FX overlay

## Editor Steps (Optional)

No mandatory editor setup is required because nodes/materials are built in script.

Optional checks in Godot editor:

1. Open `res://scenes/MainHub.tscn`.
2. Run the scene and verify ring tabs, panel slide, and FX overlay.
3. Toggle `SCANLINES` in the status strip.
4. Open Accessibility modal and confirm settings save/reload behavior.
