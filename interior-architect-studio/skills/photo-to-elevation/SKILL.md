---
name: photo-to-elevation
description: >
  This skill should be used when the user wants to turn a photo, PDF, or scan into a clean
  line drawing — "make an elevation from this photo", "vectorize this", "turn this PDF plan
  into something editable", "give me a line-art elevation/plan". It produces editable vector
  elevations/plans from raster input, or line-art elevations from the 3D model.
metadata:
  version: "0.1.0"
---

Produce a clean, editable line drawing (elevation or plan) from an image/PDF or from the
3D model. No GPU required for any path here.

## Pick the path
1. **Photo/scan → editable vector (Adobe):** for an existing photo of a wall/cabinet run or a
   hand sketch. Use the Adobe MCP `image_vectorize` (Image Trace) to get vector paths; clean
   up to a line elevation. Use background removal / fill first if the photo is busy. Best when
   the user wants an *editable* vector they can dimension later.
2. **PDF plan → editable/scaled:** rasterize the PDF page to PNG (pdf skill), then either
   (a) vectorize via Adobe for a quick editable trace, or (b) trace key dimensions into
   **FreeCAD** (blueprint-draft skill) for a true *scaled* plan with real measurements.
   Always tell the user traced dimensions must be field-verified.
3. **3D model → line-art elevation (Blender Freestyle):** when a Blender model exists, set an
   orthographic camera squared to the wall, enable Freestyle with a white world, and render a
   clean black-line elevation. See the render-pass `blender-patterns.md` Freestyle snippet.

## Steps
1. Save the source to `06_reference/`. Confirm whether the user needs *editable vector*,
   *scaled/dimensioned*, or *presentation line-art* — that decides the path above.
2. Produce the drawing; export SVG/DXF (vector) or PNG (line-art) to `01_plans/`
   (technical) or `05_deliverables/` (presentation). Resolve root from `STUDIO_ROOT`.
3. Add a scale note and the standard "concept only / not for construction / field-verify /
   not a code certification" disclaimer.

## Notes
- Vectorized photo traces are approximate — good for concepts and redlines, not for permit
  sets. For dimensioned accuracy, go through FreeCAD.
- Adobe operations consume Creative Cloud generative/processing credits.
