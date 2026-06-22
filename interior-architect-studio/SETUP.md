# Setup Guide — Interior Architect Studio

Step-by-step setup with confidence levels. Do Part 1 once. Parts 2–3 are per machine.
Everything here is free or uses your existing Adobe Creative Cloud subscription.

Legend: **[HIGH]** = verified/standard, **[MED]** = generally works, watch for variation.

---

## Part 0 — What's already true on your laptop (verified)
- Blender 5.1 and FreeCAD 1.1 are installed. **[HIGH]**
- `uv`/`uvx`, `node`/`npx`, `python` are installed. **[HIGH]**
- FreeCAD MCP and Blender MCP are connected as Cowork connectors, but their **live app
  bridges were down** (apps weren't running their servers). **[HIGH]**
- FreeCADMCP add-on is already installed in FreeCAD. The Blender MCP **add-on still needs to
  be installed inside Blender**. **[HIGH]**
- GPU is Intel Iris Xe (~2 GB), no NVIDIA → AI image rendering and local image-to-3D must run
  on the NVIDIA machine or free cloud. Blender uses EEVEE here. **[HIGH]**

---

## Part 1 — Install the plugin (once)
1. In Cowork, install `interior-architect-studio` (accept the `.plugin` file, or add its
   folder as a plugin). **[HIGH]**
2. Confirm the agents (`interior-architect`, `sourcing-researcher`, `code-researcher`) and
   the seven skills appear. **[HIGH]**

---

## Part 2 — Bring the design apps online (per machine)

### 2A. FreeCAD (2D / DXF) — **[HIGH]**
The FreeCADMCP add-on is installed **and set to `auto_start_rpc: true`**, so the RPC server
(port **9875**) comes up by itself when FreeCAD's GUI launches — no button to click.
1. **Launch FreeCAD first**, before the connector tries to reach it. (RPC verified healthy:
   `ping -> True` on :9875.)
2. **Order matters:** the Cowork freecad connector checks for FreeCAD at *its* startup and
   gives up if FreeCAD isn't up yet (symptom: "FreeCAD failed to start within 30 seconds"
   even though FreeCAD is running). If you see that, **restart the freecad connector in
   Cowork** (toggle it off/on in connector settings, or restart Cowork) *after* FreeCAD is
   open. The connector then attaches to the live RPC server.
3. Keep FreeCAD open while you work. Each session: open FreeCAD, then ensure the connector
   (re)starts.
4. Verify: ask the agent to run `list_objects` — an empty list/doc is success.

### 2B. Blender (3D / render) — **[HIGH] (install is a one-time GUI step)**
The connected server is the **official Blender MCP** (Blender Lab), which supports Blender
4.5+ — so your 5.1 is compatible.
1. Get the official Blender MCP add-on from the Blender Lab MCP page
   (blender.org → Lab → MCP Server). Use the drag-and-drop install (it adds the Blender Lab
   repository first, then installs the add-on — you drop it twice), **or** download the
   add-on file and use **Edit → Preferences → Add-ons → ▾ → Install from Disk**.
2. In **Edit → Preferences → Add-ons**, search "MCP" and **enable** "Blender MCP".
3. Expand its preferences: confirm **Host = localhost**, **Port = 9876**; optionally enable
   **Auto Start**. The panel should read **"Server is running"** (start it if not).
4. Leave Blender open while you work.
5. Verify in Cowork: ask the agent for a scene summary (`get_objects_summary`). If you see
   "Cannot connect to Blender at localhost:9876", the server isn't running.

### 2C. Adobe (image edits / vectorize) — **[HIGH]**
- The Adobe connector is already connected and uses your Creative Cloud subscription's
  generative credits. No extra setup. Used for generative fill/expand, background removal,
  and vectorize (photo → editable elevation).

### 2D. Set your project root — **[HIGH]**
Set `STUDIO_ROOT` so files save to a consistent place on each machine:
- Laptop (PowerShell):
  `setx STUDIO_ROOT "C:\Users\dmatl\OneDrive - Daniel J. Matloubian Esq\Desktop\TrustAdvisor_Design_Projects"`
- NVIDIA machine: set it to that machine's projects folder.
Restart Cowork after `setx`. If unset, the agent uses the current working directory.

---

## Part 3 — AI render engine (ComfyUI) — portable, free

Install the engine plugin once per machine:
```
/plugin marketplace add artokun/comfyui-mcp
```
(MIT, free; ~89 tools + ControlNet/img2img/inpaint skills.)

### 3A. NVIDIA workstation — local ComfyUI (best, free) — **[MED-HIGH]**
1. Install ComfyUI (Desktop or source) + ComfyUI-Manager.
2. Install ControlNet models (M-LSD, Canny, Depth, Scribble) and an interior-friendly SDXL or
   Flux checkpoint. Optional: a Hunyuan3D node for image-to-3D.
3. Start ComfyUI (http://127.0.0.1:8188). comfyui-mcp auto-detects it. No `COMFYUI_URL` needed.

### 3B. Laptop (no NVIDIA) — free Google Colab ComfyUI — **[MED]**
1. Open a free ComfyUI + ControlNet Colab notebook and run it.
2. Copy the public tunnel URL it prints (e.g. `https://xxxx.trycloudflare.com`).
3. `setx COMFYUI_URL "https://xxxx.trycloudflare.com"` and restart Cowork.
4. Caveats: free Colab has time limits / queues — fine for a handful of renders per session.
5. No ComfyUI handy? Use the Adobe fallback (generative fill/expand) or browser SaaS
   (InteriorAI/ReRoom/MyArchitectAI free tiers) via the Chrome connector. **Do not** run local
   Stable Diffusion on the Iris Xe GPU — insufficient VRAM.

### 3C. Image → 3D — **[HIGH]**
- NVIDIA: Hunyuan3D/TripoSR node in ComfyUI (free, local).
- Laptop: Meshy free tier in the browser → download GLB → the agent imports it into Blender.

---

## Part 4 — Daily workflow
1. Start FreeCAD (RPC on) and Blender (server running). Start/point ComfyUI if you'll do AI renders.
2. Ask the `interior-architect` agent for the job, e.g.:
   - "Draft a 15x20 primary bath in FreeCAD — freestanding tub, double vanity, walk-in shower —
     export DXF."
   - "Block it out in Blender, matte porcelain floor, Calacatta shower walls, warm recessed
     LEDs, EEVEE render."
   - "I uploaded an inspiration photo — restage my kitchen to match." (photo-to-render)
   - "Build the BOM and a client deck."
3. Outputs land under `STUDIO_ROOT/<ProjectName>/...`.

---

## Part 5 — Verify end-to-end
1. FreeCAD `list_objects` and Blender `get_objects_summary` both respond. **[HIGH]**
2. Draft a small plan → DXF in `01_plans`. **[HIGH]**
3. Block-out + EEVEE render → PNG in `03_renders`; `.blend` in `02_models`. **[HIGH]**
4. Photo-to-render via ComfyUI (or Adobe fallback) → PNG in `03_renders`. **[MED]**
5. BOM xlsx in `04_sourcing`; client deck in `05_deliverables`. **[HIGH]**

---

## Known limits / not possible
- **No code certification** — research only; a licensed pro must stamp permit drawings. **[HIGH]**
- **Laptop can't do local AI render or local image-to-3D** (no NVIDIA GPU). Use NVIDIA machine
  or free cloud. **[HIGH]**
- **Cycles photoreal on the laptop is very slow** (CPU). Use EEVEE there. **[HIGH]**
- **Firefly *API* is enterprise-only** (~$1k/mo) — not used; the Adobe app/connector path uses
  your existing subscription instead. **[HIGH]**
- **Free Colab / SaaS free tiers** have session/usage limits and possible watermarks. **[MED]**
- **Adobe generative ops** consume your Creative Cloud generative credits. **[MED]**
- **Higgsfield/Runway** connectors are paid — left out of this free build. **[HIGH]**
