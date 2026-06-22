---
name: render-pass
description: >
  This skill should be used when the user asks to "render the room", "make a 3D view",
  "block out the space", "apply materials and lighting", or "do a render" of an interior.
  It builds or updates a Blender scene, applies PBR materials and layered lighting, and
  renders with EEVEE Next (default) or Cycles (NVIDIA workstation), saving the PNG.
metadata:
  version: "0.1.0"
---

Build/refresh a Blender interior scene and render it. Blender must be running with the
**official Blender MCP server on localhost:9876** (Edit → Preferences → Add-ons → enable
"Blender MCP", panel shows "Server is running").

## Steps
1. **Inspect first:** call `mcp__Blender__get_objects_summary` (and
   `get_object_detail_summary` as needed). Never assume the scene is empty or that a given
   object exists. Match existing naming conventions.
2. **Block out** the room from the plan dimensions: floor, four walls (correct interior
   dims, ~9–10 ft ceiling unless told otherwise), openings, and fixture stand-ins. Prefer
   `mcp__Blender__execute_blender_code` with `bpy`. Set object mode and selection explicitly
   between operations (the active object and selection are distinct).
3. **Materials (PBR):** assign principled BSDF materials matching the spec — e.g. matte
   porcelain floor (low spec, slight roughness), heavily-veined Calacatta on shower walls,
   warm white oak millwork, brushed-brass fixtures. Use texture maps when available in
   `_studio/material_library`.
4. **Layered lighting:** ambient fill (area light or HDRI at low strength) + task
   (recessed/can downlights as emissive or area lights) + accent (cove/under-cabinet
   strips). Use warm 2700–3000K. Avoid a single flat key light.
5. **Camera:** set a realistic eye-level (~5.5 ft) camera with a 24–35mm-equivalent lens and
   a composed view. Use `jump_to_view3d_object_by_name` to verify framing.
6. **Render engine:** default to **EEVEE** (fast, GPU/CPU-friendly; right for the laptop).
   The enum differs by version — Blender 5.x = `BLENDER_EEVEE`, Blender 4.2–4.5 =
   `BLENDER_EEVEE_NEXT`; detect which exists (see patterns). Use Cycles only on the NVIDIA
   workstation for final hero shots. Set a sensible resolution (e.g. 1920x1080), modest samples first.
7. **Render + save:** use `mcp__Blender__render_viewport_to_path` (quick look) or a full
   render via `bpy` to PNG in the project's `03_renders/` folder; save the `.blend` to
   `02_models/`. Resolve project root from `STUDIO_ROOT`, else working directory.
8. Show the render to the user and note it is a concept visualization (see disclaimer rule).

## Notes
- On the laptop, keep EEVEE samples/resolution modest; Cycles will be very slow (no GPU).
- See `references/blender-patterns.md` for block-out, material, lighting, and render snippets.
- If tools error with "Cannot connect to Blender at localhost:9876", tell the user to launch
  Blender and start the Blender MCP server, then retry.
