---
name: procurement-bom
description: >
  This skill should be used when the user asks for a "bill of materials", "BOM", "material
  takeoff", "spec list", "sourcing", "pricing", or "where to buy" the materials/fixtures in a
  design. It researches real products and local suppliers and produces a costed BOM spreadsheet.
metadata:
  version: "0.1.0"
---

Turn a design's specified materials and fixtures into a costed, sourced Bill of Materials.

## Steps
1. **Assemble the spec list** from the current design (finishes, fixtures, millwork,
   hardware, lighting). If quantities aren't known, compute them from the plan dimensions
   (e.g. floor area, wall area for tile; linear feet for trim/cabinets).
2. **Research** with the `sourcing-researcher` subagent: for each line, get product, size,
   unit, coverage/unit, ballpark unit price, lead time, and a supplier — prioritizing
   showrooms reachable from Sherman Oaks / Encino. Cite sources; mark unknowns as "quote
   required."
3. **Compute quantities & cost:** apply coverage to areas, add a **10–15% waste/contingency**
   line per material category, and subtotal by category and overall.
4. **Build the spreadsheet** via the `xlsx` skill with columns: Category, Item, Spec/Finish,
   Size, Unit, Coverage/Unit, Est. Qty, Est. Unit $, Est. Extended $, Lead Time, Supplier,
   Contact, Source URL, Notes. Add a footer: "Planning estimate, not a binding quote; verify
   with suppliers."
5. **Save** to the project's `04_sourcing/` folder (resolve root from `STUDIO_ROOT`, else
   working directory) and summarize total, longest-lead items, and any assumptions.

## Notes
- Keep estimate vs. quoted prices clearly distinct. Never fabricate a price.
- Free/public sources only; no paid data services.
