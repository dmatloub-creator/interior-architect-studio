# ComfyUI endpoints — portable setup (free)

The same `comfyui-mcp` plugin works on both machines; only the endpoint differs.

## Install the engine plugin (once, per machine)
```
/plugin marketplace add artokun/comfyui-mcp
```
This gives ~89 ComfyUI tools + ControlNet/img2img/inpaint skills. MIT, free.

## NVIDIA workstation — local ComfyUI (best, free)
1. Install ComfyUI (Desktop or from source) and ComfyUI-Manager.
2. Install ControlNet models: M-LSD, Canny, Depth, Scribble (+ an interior-friendly SDXL or
   Flux checkpoint). Optionally a Hunyuan3D node for image-to-3D.
3. Start ComfyUI (default http://127.0.0.1:8188). comfyui-mcp auto-detects it.
4. Render speed is GPU-fast; you can also use Cycles in Blender here for hero shots.

## Laptop (Intel Iris Xe, no NVIDIA) — free Google Colab ComfyUI
1. Open a free ComfyUI Colab notebook (e.g. a community "ComfyUI + ControlNet" notebook).
2. Run it; it prints a public tunnel URL (Cloudflare/localtunnel), e.g.
   `https://xxxx.trycloudflare.com`.
3. Point the MCP at it for this machine:
   ```
   setx COMFYUI_URL "https://xxxx.trycloudflare.com"
   ```
   (or set it in the plugin's MCP env). Restart Cowork so the value is picked up.
4. Caveats: free Colab has session time limits and may queue; fine for a handful of renders.

## If no ComfyUI is available
Fall back to the Adobe MCP (generative fill/expand, vectorize) for lighter restage edits, or
the browser SaaS tools via the Chrome connector. Never run local SD on the Iris Xe GPU.
