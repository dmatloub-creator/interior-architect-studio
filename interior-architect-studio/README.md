# Interior Architect Studio

A Cowork plugin that turns Claude into a comprehensive interior architecture studio for a
Los Angeles General-B contracting firm. It drafts 2D plans, builds and renders 3D spaces,
transforms uploaded photos/PDFs into renders, elevations, and 3D, sources materials, and
produces client deliverables — using free or already-owned tools, and working across both a
laptop (no GPU) and an NVIDIA workstation.

## What it does
- **2D plans / DXF** via FreeCAD
- **3D modeling + photoreal renders** via Blender (EEVEE Next default; Cycles on NVIDIA)
- **Photo / sketch / PDF → render or restage** via ComfyUI (ControlNet) or Adobe
- **Photo / PDF → editable vector elevations & plans** via Adobe vectorize / FreeCAD / Freestyle
- **Image → 3D objects** via Meshy (free) or Hunyuan3D/TripoSR (NVIDIA)
- **Bill of Materials, spec sheets, client decks** via xlsx / docx / pdf / pptx

## Components
| Type | Name | Purpose |
|------|------|---------|
| Agent | `interior-architect` | Primary persona; orchestrates CAD/3D/render and ships a BOM |
| Agent | `sourcing-researcher` | Stateless vendor/pricing research → sourcing table |
| Agent | `code-researcher` | LA/CA code clearance lookups (research only, cited) |
| Skill | `design-intake` | Interviews the designer & confirms a written brief before building |
| Skill | `blueprint-draft` | FreeCAD 2D plan + DXF/PDF export |
| Skill | `render-pass` | Blender block-out, PBR, layered lighting, EEVEE render |
| Skill | `photo-to-render` | ComfyUI ControlNet/img2img restage; Adobe fallback |
| Skill | `photo-to-elevation` | Photo/PDF → editable vector or line-art elevation |
| Skill | `image-to-3d` | Single image → GLB → import into Blender |
| Skill | `procurement-bom` | Costed, sourced Bill of Materials (xlsx) |
| Skill | `client-deck` | Compile plans/renders/BOM into a deck or PDF |

## Setup
See **SETUP.md** for full step-by-step instructions (Blender MCP add-on, FreeCAD RPC server,
ComfyUI on both machines, Adobe, environment variables, and verification).

Quick version:
1. Install this plugin in Cowork.
2. Connect/enable: **Blender** (official Blender MCP, port 9876), **FreeCAD** (FreeCADMCP RPC),
   **Adobe** (Creative Cloud), and **ComfyUI** (`/plugin marketplace add artokun/comfyui-mcp`).
3. Set `STUDIO_ROOT` to your projects folder (and `COMFYUI_URL` on the laptop).
4. Launch Blender (start its MCP server) and FreeCAD (start the RPC server) before designing.

## Required tools / connectors
- **Blender** desktop (4.5+/5.x) + official Blender MCP add-on — free
- **FreeCAD** desktop (1.x) + FreeCADMCP add-on — free
- **Adobe** Creative Cloud (already subscribed) via the connected Adobe MCP
- **ComfyUI** (local on NVIDIA, or free Google Colab on the laptop) via comfyui-mcp — free
- Native skills: `xlsx`, `docx`, `pptx`, `pdf`; `WebSearch`; Chrome connector (sourcing)

## Environment variables
- `STUDIO_ROOT` — absolute path to your projects root (per machine). Files save under
  `STUDIO_ROOT/<ProjectName>/{01_plans,02_models,03_renders,04_sourcing,05_deliverables,06_reference}`.
- `COMFYUI_URL` — (laptop only) public URL of a free Colab ComfyUI session.

## Important disclaimer
This plugin produces **concept** designs and **planning estimates** only. It can research and
cite building codes but **cannot certify code compliance** and **does not replace a licensed
architect's or engineer's stamped, permitted drawings**. Pricing is not a binding quote.
