---
name: photo-to-render
description: >
  This skill should be used when the user uploads a photo, sketch, or screenshot and asks to
  "turn this into a render", "restage this room", "redesign this space", "make it look modern",
  or "virtually stage" it. It uses ComfyUI (ControlNet + img2img) to transform an existing
  image into a styled photoreal interior, with Adobe as a no-GPU fallback for lighter edits.
metadata:
  version: "0.1.0"
---

Transform an uploaded image into a styled interior render. Choose the engine by what's
reachable on the current machine.

## Engine selection (portable)
1. **Preferred — ComfyUI** (`mcp__comfyui__*` once the comfyui-mcp plugin is installed and a
   ComfyUI instance is reachable):
   - **NVIDIA workstation:** local ComfyUI (auto-detected; free, fast).
   - **Laptop (Intel Iris Xe, no GPU):** point ComfyUI-MCP at a **free Google Colab** ComfyUI
     session via its public URL (set `COMFYUI_URL`). See `references/comfyui-endpoints.md`.
2. **Fallback — Adobe MCP** (always available; uses Creative Cloud credits): good for
   restage-by-edit — generative fill to swap furniture/finishes, generative expand to widen a
   shot, background removal. Not a full structural re-render but needs no GPU.
3. **Last resort — browser SaaS** (InteriorAI / ReRoom / MyArchitectAI) via the Chrome
   connector: free tiers, watermarks/limits, least controllable.

## ComfyUI workflow (the controllable path)
1. Save the input to `06_reference/`. Confirm the goal (style, keep-structure vs. free
   redesign, which elements to preserve).
2. Pick the ControlNet that fits:
   - **M-LSD** (straight lines) → preserve room architecture/perspective (best for interiors).
   - **Canny** → preserve edges/detail; **Depth** → preserve spatial layout;
     **Scribble** → loose sketch → render.
3. Run a ControlNet + img2img graph: load image → preprocess (mlsd/canny/depth) → apply
   ControlNet → KSampler with an interior-design prompt (e.g. "modern primary bath, large-
   format Calacatta, warm layered lighting, white oak millwork, photoreal, architectural
   photography") → save. Use a denoise that keeps structure (≈0.4–0.6 for restage, higher for
   bold redesign). IP-Adapter can carry a reference style image.
4. Iterate 2–4 variations; save PNGs to `03_renders/`. Resolve root from `STUDIO_ROOT`.
5. Label outputs as AI concept visualizations, non-binding (see disclaimer rule).

## Notes
- Do not attempt local Stable Diffusion on the laptop's Iris Xe GPU — it lacks the VRAM; use
  Colab or the NVIDIA machine.
- For PDFs, first rasterize a page to PNG (pdf skill) and treat it as the input image.
- See `references/comfyui-endpoints.md` for setting the per-machine ComfyUI endpoint.
