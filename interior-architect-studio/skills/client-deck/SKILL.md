---
name: client-deck
description: >
  This skill should be used when the user wants to package a design for a client — "make the
  client presentation", "put together a deck", "create the proposal", "assemble the design
  package", or "export a PDF/PowerPoint" of the project. It compiles plans, renders, material
  boards, and the BOM into a polished deck or PDF.
metadata:
  version: "0.1.0"
---

Compile the project's outputs into a client-ready presentation.

## Steps
1. **Gather assets** from the project folders: floor plan/DXF (`01_plans`), renders
   (`03_renders`), material board images, and the BOM (`04_sourcing`). Confirm scope: concept
   pitch vs. full design package.
2. **Build the deck** via the `pptx` skill (editable) or `pdf`/`docx` for a flat document.
   Suggested flow:
   - Cover (project name, client, date, firm).
   - Design narrative (concept, palette, materials story).
   - Floor plan.
   - Renders (hero shot first, then secondary views).
   - Material board (swatches/finishes with names + suppliers).
   - Elevations / details (if produced).
   - Budget summary (from the BOM — totals by category; full BOM as appendix/attachment).
   - Next steps + the standard disclaimer slide.
3. **Mood board / material board:** assemble via the Adobe MCP (boards) or a clean grid in the
   deck. Keep typography simple and consistent with a modern aesthetic.
4. **Disclaimer (required):** include a closing note — "Concept presentation only. Not for
   construction. Pricing is a planning estimate, not a binding quote. Does not certify
   building-code compliance or replace stamped, permitted drawings by a licensed professional."
5. **Save** to `05_deliverables/` (resolve root from `STUDIO_ROOT`, else working directory)
   and give the user the file path(s).

## Notes
- Keep the client-facing language plain and benefit-oriented; move technical detail to
  appendices.
- Match the firm's brand if assets exist in `_studio/templates`.
