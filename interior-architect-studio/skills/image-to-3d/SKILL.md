---
name: image-to-3d
description: >
  This skill should be used when the user wants a 3D model of an object from a picture —
  "make this furniture/fixture into 3D", "turn this photo into a 3D model", "I need a 3D
  asset of this chair/vanity". It generates a GLB from a single image and imports it into the
  Blender scene. Cloud/free on the laptop; local on the NVIDIA workstation.
metadata:
  version: "0.1.0"
---

Generate a 3D asset from a single product/furniture photo and bring it into Blender.

## Engine selection (portable, free)
- **NVIDIA workstation:** run a **Hunyuan3D** (PBR + GLB) or **TripoSR** node inside local
  ComfyUI — free, local, fast. Hunyuan3D gives light-reactive PBR maps; TripoSR is faster but
  bakes lighting.
- **Laptop (no NVIDIA GPU):** use **Meshy** free tier in the browser (Chrome connector) —
  upload the photo, generate (~1 min), download the **GLB**. Local image-to-3D is not viable
  on the Iris Xe GPU.

## Steps
1. Save the source photo to `06_reference/`. A clean, single-object, plain-background shot
   works best — use Adobe background removal first if needed.
2. Generate the model (engine per above); download/export **GLB** to `02_models/assets/`.
   Resolve root from `STUDIO_ROOT`, else working directory.
3. Import into the scene in Blender:
   `bpy.ops.import_scene.gltf(filepath=...)` via `mcp__Blender__execute_blender_code`.
   Then scale to real-world size, set origin, and place it in the layout.
4. Clean up: decimate if heavy, check normals, reassign/repair materials, and confirm it
   reads well under the scene lighting.
5. Note that AI-generated meshes are approximate concept assets, not manufacturing geometry.

## Notes
- Free tiers cap monthly generations — batch the important pieces.
- Prefer real manufacturer 3D/CAD downloads when a spec'd product offers them; reserve
  image-to-3D for one-off or reference pieces.
