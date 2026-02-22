# Ash and Oil UI Audit: Home Base + Forum Market

Date: 2026-02-22  
Scope: `scenes/MainHub.tscn`, `scenes/ShopUI.tscn`, `scripts/ui/MainHub.gd`, `scripts/ui/ShopUI.gd`

## 1) Screen-by-Screen Breakdown

### Home Base (previous implementation)
- Structure: single vertical stack inside one scroll container.
- Sections: title, gold/status, meters, squad, mission list, action buttons.
- Mission entries: text + button in linear rows.
- No visual zoning between strategic info (meters/squad), progression info (missions), and navigation actions.

### Forum Market (previous implementation)
- Structure: single vertical stack with title, gold label, message, list of cards, back button.
- Cards displayed as text rows with buy button.
- No gear section.
- No preview pane; decision context was compressed into one line per card.

## 2) Font Size Audit (previous implementation)

### Home Base (`scripts/ui/MainHub.gd`)
- 22px: title
- 14px: gold label
- 13px: section titles and buttons
- 12px: meters/body rows
- 11px: status label
- 10px: mission description

Below 12px findings:
- 11px status line (location/completion/ending)
- 10px mission descriptions

### Forum Market (`scripts/ui/ShopUI.gd`)
- 22px: title
- 14px: gold label
- 12px: message, card info, buttons

Below 12px findings:
- None (but 12px is still too small for dense scanning at desktop distance)

## 3) Information Hierarchy Assessment

### Home Base pain points
- Primary focus was unclear: title and section headers had similar visual weight.
- Strategic data (meters, squad, missions) appeared as text blocks rather than actionable cards.
- Footer actions visually under-emphasized for high-frequency navigation.
- Mission detail context required reading dense tiny text in-line.

### Forum Market pain points
- Market lacked two-level interaction model (browse first, inspect second).
- No persistent detail panel meant every item was “summarized,” never “explained.”
- No gear visibility made progression loop feel card-only.
- Flat list presentation increased search time and reduced comparability.

## 4) Usability Pain Points

- Readability: body/secondary text was commonly 10-12px.
- Scanability: no strong column or card structure for quick target finding.
- Comparison friction: no side-by-side item detail and list context.
- Decision confidence: no pre-buy detail panel for full effect/stat review.
- Discoverability: no rarity badge hierarchy or explicit owned-state badges.

## 5) Industry Comparison (Hierarchy + Readability)

### Slay the Spire
- Uses high-contrast, card-forward browse model with large, legible cost and title anchors.
- Shop interactions emphasize quick visual parsing + inspect before commit.

### Monster Train
- Strong lane/card hierarchy and clear rarity/effect framing.
- Better categorization and chunking of information than previous Ash and Oil market.

### Ash and Oil (before redesign)
- Smaller fonts and text-heavy rows made it harder to parse than both references.
- Lacked hover/preview model, forcing mental parsing from condensed strings.

## 6) What Changed in This Pass

- Home Base rebuilt into explicit zones:
  - Header
  - Character status
  - Three-column strategic area
  - Footer action rail
- Forum Market rebuilt with:
  - Header stats
  - Cards grid section
  - Gear grid section
  - Footer navigation + feedback
- Added side preview prefabs for card and gear details with slide animations.
- Added hover scaling and tooltips for item affordance.
- Added owned gear state + equip-on-buy flow.

## 7) Screenshot and Measurement Note

Automated screenshot capture/annotation was not completed in this shell session due local runtime logging constraints in the headless environment.  
Manual verification path in editor:
1. Open `scenes/MainHub.tscn` and `scenes/ShopUI.tscn`.
2. Set window size to 1920x1080.
3. Capture before/after and verify body text >=14px, section headers >=24px.

