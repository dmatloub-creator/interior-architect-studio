---
name: design-intake
description: >
  This skill should be used at the START of any interior design request — whenever the user
  says "design", "redesign", "lay out", "render", "start a project", "I want to do my
  kitchen/bath/room", or uploads an inspiration image — BEFORE drafting, modeling, rendering,
  or sourcing. It interviews the designer with targeted clarifying questions, confirms a
  written Design Brief, and only then hands off to the production skills, so output matches
  intent.
metadata:
  version: "0.1.0"
---

Run a structured intake interview before producing anything. The goal is zero-rework:
surface every decision the design depends on, confirm it in writing, then build.

## Operating rules
1. **Always intake first.** Do not draft, model, render, or source until the brief is
   confirmed — unless the user explicitly says "skip questions / just go."
2. **Only ask what's missing or ambiguous.** Parse what the user already gave; never re-ask
   answered items. If they uploaded a photo/PDF, acknowledge what you can infer from it and
   ask only to fill gaps.
3. **Ask with AskUserQuestion, in batches (max 4 per round).** Prefer concrete multiple-choice
   options with a recommended default first; the user can always type a custom answer. Group
   related questions; don't fire one-at-a-time.
4. **Stop asking when you have enough.** Aim for 1–2 rounds (the essentials), a 3rd only if the
   project is complex. Don't interrogate.
5. **Confirm before building.** Write the Design Brief, then read back a short summary and ask
   for a single confirmation ("Build to this brief? — yes / adjust"). Treat that as sign-off.
6. **Re-confirm on change.** If the user later changes scope, dimensions, style, or budget,
   update the brief and re-confirm the changed parts only.

## What to cover (the intake checklist)
Ask only for what's unknown. See `references/intake-questions.md` for ready-to-use
AskUserQuestion option sets.
- **Project & scope:** room(s); full remodel vs. refresh vs. concept-only; what stays/goes.
- **Dimensions & existing conditions:** room size, ceiling height, window/door locations,
  plumbing/electrical to keep, structural constraints. Offer to work from an uploaded
  plan/photo (note field-verification required).
- **Style direction:** aesthetic (modern/transitional/etc.), reference images, the firm's
  default lean (warm-minimal, custom millwork, large-format stone, layered lighting).
- **Materials & finishes:** preferred and to-avoid materials, stone/tile, cabinetry/millwork
  finish, metals; any allergy/maintenance constraints.
- **Color & mood:** palette (light/warm/moody), feeling words.
- **Lighting:** layered lighting preferences, color temperature, daylight priorities.
- **Fixtures/appliances/furniture:** specific items, brands, must-keeps, spec'd products.
- **Budget tier & quantities:** good/better/best; any hard cap; areas to splurge vs. save.
- **Compliance/accessibility:** aging-in-place/ADA needs, known permit constraints (research
  only — never certify compliance).
- **Deliverables & format:** what she wants out — plan/DXF, render(s), elevation, BOM,
  client deck/PDF — and audience (client vs. trades).
- **Timeline & priorities:** deadline; what matters most if trade-offs are needed.

## Output: the Design Brief
1. Create/locate the project folder (resolve root from `STUDIO_ROOT`, else cwd) and write
   `06_reference/design-brief.md` using `references/brief-template.md`.
2. Echo a concise summary (5–10 lines) of the brief in chat.
3. Ask for confirmation. On "yes," hand off to the right production skills (`blueprint-draft`,
   `render-pass`, `photo-to-render`, `photo-to-elevation`, `image-to-3d`, `procurement-bom`,
   `client-deck`). On "adjust," revise and re-confirm.
4. Keep the brief as the source of truth; reference it in every downstream deliverable and in
   the required concept/compliance disclaimers.
