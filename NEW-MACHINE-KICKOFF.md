# New-machine kickoff prompt

Paste the block below into a **fresh Claude Code / Cowork session on the new (NVIDIA) machine**.
It has no memory of the original setup session — this prompt gives it full context so it can
finish the install itself.

---

```
You are helping me set up an "Interior Architect Studio" on this Windows machine, which has
an NVIDIA GPU. Everything is defined in my GitHub repo:
https://github.com/dmatloub-creator/interior-architect-studio

Please:
1. Read the repo's README.md and interior-architect-studio/SETUP.md (especially "Appendix A —
   NVIDIA workstation: local ComfyUI").
2. Run the bootstrap to install prerequisites + Blender + FreeCAD and configure their MCP
   add-ons:
      irm https://raw.githubusercontent.com/dmatloub-creator/interior-architect-studio/main/scripts/studio-bootstrap.ps1 | iex
   (If the one-liner fails on TLS, clone the repo and run scripts/studio-bootstrap.ps1.)
3. Verify the bridges: launch Blender and FreeCAD, then check the Blender scene summary and
   FreeCAD object list. Fix any winget package-ID or path issues you hit.
4. Walk me through the in-Cowork steps (these can't be scripted):
      /plugin marketplace add dmatloub-creator/interior-architect-studio
      /plugin install interior-architect-studio@matloubian-studio
      /plugin marketplace add artokun/comfyui-mcp
   and enabling the Blender, FreeCAD, and Adobe connectors.
5. Set up LOCAL ComfyUI per Appendix A (this machine has a real NVIDIA GPU — use local ComfyUI
   with M-LSD/Canny/Depth ControlNet, not Colab). Confirm comfyui-mcp auto-detects it.
6. Run an end-to-end test: draft a small bathroom plan (FreeCAD) -> block-out + render
   (Blender) -> a quick photo-to-render via ComfyUI -> a BOM. Report what worked.

Context/constraints:
- Free or already-owned tools only (I have Adobe Creative Cloud; do NOT use the Firefly API).
- This machine HAS an NVIDIA GPU, so local ComfyUI + Blender Cycles are available (the other
  machine, my laptop, is GPU-less and uses EEVEE + cloud).
- Output is concept-only; never certify building-code compliance or replace a licensed
  architect/engineer's stamp.
- Save projects under STUDIO_ROOT (the bootstrap sets it).
```

---

After it's installed, start any real job with: "Design a <room> ..." — the plugin's
`design-intake` skill will interview you first and confirm a brief before building.
