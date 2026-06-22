---
name: blueprint-draft
description: >
  This skill should be used when the user asks to "draft a floor plan", "draw the layout",
  "make a blueprint", "lay out the room", "dimension the plan", or export a plan to DXF/PDF.
  It drafts a scaled 2D residential floor plan in FreeCAD and exports construction-reference
  DXF/PDF, with fixtures, walls, dimensions, and clearance notes.
metadata:
  version: "0.1.0"
---

Draft a scaled 2D floor plan in FreeCAD and export it. FreeCAD must be running with the
**FreeCADMCP RPC server started** (Tools/Addons → FreeCADMCP → Start RPC Server).

## Steps
1. **Confirm inputs:** room name, interior dimensions (ft/in), wall thickness, fixtures and
   their sizes, door/window positions, and which wall is "north." If a reference photo or PDF
   plan was provided, note dimensions taken from it (and that they must be field-verified).
2. **Check state:** call `mcp__freecad__list_objects` before creating geometry. If a document
   is open with prior work, confirm before adding to or clearing it.
3. **Build the plan** (work in millimeters internally; 1 ft = 304.8 mm):
   - Use `mcp__freecad__execute_python_script` for precise drafting. Create a new document,
     draw wall centerlines/faces as a Sketch or Draft wires, place fixture rectangles to
     real sizes, and add Draft dimensions. Prefer the Draft workbench for 2D.
   - Keep everything on clear layers/groups: Walls, Fixtures, Dimensions, Notes.
4. **Annotate clearances:** for code-sensitive layouts (baths, stairs, egress), call the
   `code-researcher` subagent for the relevant clearances and add them as text notes — with
   the disclaimer that figures are research-only and not a compliance certification.
5. **Export:** save the `.fcstd` and export `.dxf` (and a PDF if requested) to the project's
   `01_plans/` folder via `mcp__freecad__save_document` + a Draft/TechDraw DXF export in the
   python script. Resolve the project root from `STUDIO_ROOT`, else the working directory.
6. **Stamp the deliverable** with: "Concept only — not for construction. Not a code-compliance
   certification; does not replace a licensed architect's/engineer's stamped drawings."

## Notes
- For a true dimensioned construction sheet, use the **TechDraw** workbench to place the plan
  on a sheet with a title block before PDF export.
- See `references/freecad-patterns.md` for ready-to-adapt drafting snippets.
- If the RPC bridge is down (tool errors with "FreeCAD failed to start"), tell the user to
  open FreeCAD and start the FreeCADMCP RPC server, then retry.
