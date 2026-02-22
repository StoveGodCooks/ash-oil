# Ash and Oil UI Style Guide (Hub + Forum Market)

## Typography Scale

- 32px: main screen titles
- 24px: section headers
- 16px: sub-headers and important labels
- 14px: body text, stat values, costs
- 12px: secondary details and tooltip content
- 10px: fine print only

Implementation source: `scripts/ui/UITheme.gd`

## Spacing System

- 10px: small spacing
- 15px: medium spacing
- 20px: major gutters and section margins
- 2px: major section border width

## Color and Borders

- Background: dark brown-black
- Panel surfaces: warm dark brown variants
- Borders: bronze/gold 2px
- Primary text: warm off-white
- Highlights/stat values: gold
- Rarity colors:
  - common: gray
  - uncommon: blue
  - rare: gold
  - legendary: red

## Interaction Model

### Hover
- Card/Gear tiles scale to `1.05` over `150ms`.
- Tooltip shows concise summary.

### Click
- Selecting card/gear opens side preview panel.
- Panel animation: slide in from right, `250ms`, cubic ease-out.

### Close
- Press `ESC` or preview close button.
- Panel slides out in `250ms`.

### Buy
- Press `BUY` in preview panel.
- On success:
  - spend gold
  - update deck or gear ownership
  - refresh header counts and grids
  - show confirmation text in footer

## Preview Panel Content Contracts

### Card Preview
- Name, cost, type/faction
- Full effect breakdown (damage/armor/heal/effect)
- Flavor text
- Buy affordance and affordability state

### Gear Preview
- Name and rarity badge
- Cost
- Slot + stat breakdown
- Special effect text
- Owned/Buy state

## Button Flowchart

```text
Grid Item Hover
  -> Tooltip + scale up

Grid Item Click
  -> Open preview
  -> (Buy?) yes -> Validate gold/ownership/deck cap
      -> Success: apply purchase + refresh UI
      -> Fail: show message
  -> Close preview (ESC/X)
```

## Performance Notes

- UI is still script-built and lightweight (Control-only hierarchy, no heavy textures required).
- Preview panels are instantiated once and reused.
- Expected load cost remains low; target remains <500ms on 1080p.
- Use Godot profiler to record:
  - scene load time
  - frame time during hover/click animations

## Files Added/Updated

- `scripts/ui/UITheme.gd`
- `scripts/ui/MainHub.gd`
- `scripts/ui/ShopUI.gd`
- `scripts/ui/CardPreviewPanel.gd`
- `scripts/ui/GearPreviewPanel.gd`
- `scenes/ui/CardPreviewPanel.tscn`
- `scenes/ui/GearPreviewPanel.tscn`
- `scripts/autoload/GameState.gd`

