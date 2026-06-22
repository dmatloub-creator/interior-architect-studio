# Matloubian Studio — Interior Architect (Cowork plugin + bootstrap)

A Claude Cowork **plugin marketplace** plus a one-command **Windows bootstrap** that sets up a
full interior-architecture studio on a fresh machine: 2D plans (FreeCAD), 3D + renders
(Blender/EEVEE), photo/PDF → render / elevation / 3D, material sourcing, BOMs, and client decks.
The agent **interviews the designer first** (design-intake) to lock intent before building.

## Fresh-machine setup (Windows)

### 1. Run the bootstrap (installs apps + add-ons + folders)
In PowerShell:
```powershell
# One-liner (after this repo is on GitHub):
irm https://raw.githubusercontent.com/<owner>/<repo>/main/scripts/studio-bootstrap.ps1 | iex

# …or clone and run with options:
git clone https://github.com/<owner>/<repo>.git
powershell -ExecutionPolicy Bypass -File .\<repo>\scripts\studio-bootstrap.ps1 `
  -StudioRoot "C:\Users\<you>\Desktop\Interior_Design_Projects" `
  -MarketplaceRepo "<owner>/<repo>"
```
This auto-installs (via winget) Git, Node.js, uv, **Blender**, **FreeCAD**; installs and
configures the **Blender MCP** add-on (auto-start on :9876) and the **FreeCAD MCP** add-on
(auto-start RPC on :9875); sets `STUDIO_ROOT`; and scaffolds the project folders.

### 2. Finish inside Cowork (can't be scripted)
```
/plugin marketplace add <owner>/<repo>
/plugin install interior-architect-studio@matloubian-studio
```
- Enable the **Blender**, **FreeCAD**, and **Adobe** connectors in Cowork settings.
- Launch Blender + FreeCAD **before** starting the FreeCAD connector.
- (Optional AI render) `/plugin marketplace add artokun/comfyui-mcp`; local ComfyUI on an
  NVIDIA box, or set `COMFYUI_URL` to a free Colab tunnel on a GPU-less machine.

### 3. Verify
Open Blender + FreeCAD, then ask the agent to "summarize the Blender scene" and "list FreeCAD
objects." Then: "Design a 15x20 primary bath" — it will run intake first.

## What's in here
```
.claude-plugin/marketplace.json     # marketplace manifest
interior-architect-studio/          # the plugin (agents, skills, docs)
scripts/studio-bootstrap.ps1        # fresh-machine Windows installer
```

## Notes & limits
- Free / already-owned tooling only (uses your Adobe Creative Cloud; no Firefly API).
- A GPU-less machine can't run local AI render / image-to-3D — use the NVIDIA box or free cloud.
- Concept output only — not a building-code certification; does not replace stamped, permitted
  drawings by a licensed professional.
- Other design apps you have on the machine are unaffected; this only adds the above.
