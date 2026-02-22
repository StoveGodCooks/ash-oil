# Ash & Oil — UI Style Decisions

Last updated: 2026-02-22

This document captures the agreed UI/UX and art direction choices so future work stays consistent.

## Art Tone

- Dark and gritty, illustrated (not photorealistic).
- High contrast silhouettes, readable shapes, limited palette per faction.

## UI Theme

- Parchment and wax aesthetic.
- Warm, aged paper backgrounds with gold borders and muted text.
- Buttons styled like dark leather with gold trim.

## Card Presentation

- In-hand cards are compact.
- Hover reveals a larger portrait preview panel.
- The preview panel uses the parchment theme and shows:
  - Name, cost, faction
  - Stats line (damage/armor/heal)
  - Effect text
  - Placeholder art block tinted by faction until final art is available

## Overworld vs. Board

- Recommended future approach: city district map with clickable zones.
- Existing mission data includes `location` so this is a UI replacement, not a systems rewrite.
- Safe to retrofit later without changing mission logic.

## Parchment Palette Reference

These are the baseline colors used across UI files:

- Background: `Color(0.08, 0.065, 0.050)`
- Panel: `Color(0.14, 0.110, 0.080)`
- Border: `Color(0.42, 0.320, 0.160)`
- Accent: `Color(0.86, 0.700, 0.360)`
- Text: `Color(0.90, 0.840, 0.680)`
- Muted: `Color(0.58, 0.520, 0.400)`
