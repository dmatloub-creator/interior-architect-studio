<#
.SYNOPSIS
  From-scratch setup for the Interior Architect Studio on a fresh Windows machine.

.DESCRIPTION
  Installs prerequisites + design apps (winget), installs and configures the Blender MCP
  add-on (auto-start on :9876) and the FreeCAD MCP add-on (auto_start_rpc on :9875), sets
  STUDIO_ROOT, scaffolds the project folders, and prints the remaining in-Cowork steps
  (connectors + plugin install) that scripts cannot perform.

.PARAMETER StudioRoot
  Where projects are saved. Default: <Desktop>\Interior_Design_Projects

.PARAMETER MarketplaceRepo
  GitHub "owner/repo" hosting the plugin marketplace. Used only for the printed install hint.

.PARAMETER SkipApps
  Skip winget app installation (configure only).

.EXAMPLE
  # One-liner on a fresh machine:
  #   irm https://raw.githubusercontent.com/dmatloub-creator/interior-architect-studio/main/scripts/studio-bootstrap.ps1 | iex
  # Or download and run:
  #   powershell -ExecutionPolicy Bypass -File .\studio-bootstrap.ps1
#>
[CmdletBinding()]
param(
  [string]$StudioRoot = (Join-Path ([Environment]::GetFolderPath('Desktop')) 'Interior_Design_Projects'),
  [string]$MarketplaceRepo = 'dmatloub-creator/interior-architect-studio',
  [switch]$SkipApps
)

$ErrorActionPreference = 'Stop'
function Info($m){ Write-Host "[*] $m" -ForegroundColor Cyan }
function Ok($m){ Write-Host "[OK] $m" -ForegroundColor Green }
function Warn($m){ Write-Host "[!] $m" -ForegroundColor Yellow }
function Step($m){ Write-Host "`n=== $m ===" -ForegroundColor Magenta }

# ---------------------------------------------------------------------------
Step "0. Preflight"
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  throw "winget not found. Install 'App Installer' from the Microsoft Store, then re-run."
}
Ok "winget present"

function Ensure-WingetPackage($id, $cmdProbe) {
  if ($cmdProbe -and (Get-Command $cmdProbe -ErrorAction SilentlyContinue)) { Ok "$id already available ($cmdProbe)"; return }
  $installed = winget list --id $id -e 2>$null | Select-String $id
  if ($installed) { Ok "$id already installed"; return }
  Info "Installing $id ..."
  winget install --id $id -e --source winget --accept-source-agreements --accept-package-agreements -h | Out-Null
  Ok "Installed $id"
}

# ---------------------------------------------------------------------------
Step "1. Install prerequisites + design apps"
if (-not $SkipApps) {
  Ensure-WingetPackage 'Git.Git' 'git'
  Ensure-WingetPackage 'OpenJS.NodeJS.LTS' 'node'
  Ensure-WingetPackage 'astral-sh.uv' 'uv'
  Ensure-WingetPackage 'BlenderFoundation.Blender' $null
  Ensure-WingetPackage 'FreeCAD.FreeCAD' $null
  # Optional: GitHub CLI (handy for pushing the marketplace repo)
  try { Ensure-WingetPackage 'GitHub.cli' 'gh' } catch { Warn "gh optional install skipped" }
  # Refresh PATH for this session
  $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User')
} else { Warn "SkipApps set — not installing apps" }

# ---------------------------------------------------------------------------
Step "2. STUDIO_ROOT + project folders"
[Environment]::SetEnvironmentVariable('STUDIO_ROOT', $StudioRoot, 'User')
$env:STUDIO_ROOT = $StudioRoot
New-Item -ItemType Directory -Force -Path $StudioRoot | Out-Null
foreach ($d in '_studio\material_library','_studio\templates','_studio\setup',
               '_TEMPLATE_PROJECT\01_plans','_TEMPLATE_PROJECT\02_models','_TEMPLATE_PROJECT\03_renders',
               '_TEMPLATE_PROJECT\04_sourcing','_TEMPLATE_PROJECT\05_deliverables','_TEMPLATE_PROJECT\06_reference') {
  New-Item -ItemType Directory -Force -Path (Join-Path $StudioRoot $d) | Out-Null
}
Ok "STUDIO_ROOT = $StudioRoot (set for User; folders created)"

# ---------------------------------------------------------------------------
Step "3. Blender MCP add-on (official Blender Lab)"
$blender = Get-ChildItem "$env:ProgramFiles\Blender Foundation" -Filter blender.exe -Recurse -ErrorAction SilentlyContinue |
           Sort-Object FullName -Descending | Select-Object -First 1 -ExpandProperty FullName
if (-not $blender) { Warn "blender.exe not found — install Blender then re-run step 3." }
else {
  Info "Blender: $blender"
  $tmp = Join-Path $env:TEMP 'blender_mcp_dl'
  if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
  Info "Cloning official Blender MCP add-on..."
  git clone --depth 1 https://projects.blender.org/lab/blender_mcp.git $tmp | Out-Null
  $addonSrc = Join-Path $tmp 'addon\blender_mcp_addon'
  $zip = Join-Path $env:TEMP 'mcp_addon.zip'
  if (Test-Path $zip) { Remove-Item $zip -Force }
  Compress-Archive -Path (Join-Path $addonSrc '*') -DestinationPath $zip -Force
  Info "Installing + enabling extension..."
  & $blender --command extension install-file -r user_default -e $zip | Out-Null
  # Configure: autostart, online access, host/port; save userpref (headless)
  $cfg = Join-Path $env:TEMP 'mcp_setup.py'
@'
import bpy
mod = "bl_ext.user_default.mcp"
try: bpy.context.preferences.system.use_online_access = True
except Exception as e: print("online:", e)
try: bpy.ops.preferences.addon_enable(module=mod)
except Exception as e: print("enable:", e)
a = bpy.context.preferences.addons.get(mod)
if a:
    p = a.preferences
    for k,v in (("host","localhost"),("port",9876),("use_autostart",True)):
        try: setattr(p,k,v)
        except Exception as e: print("set",k,e)
bpy.ops.wm.save_userpref()
print("BLENDER_MCP_CONFIGURED", bool(a))
'@ | Set-Content -Path $cfg -Encoding UTF8
  & $blender -b --python $cfg 2>&1 | Select-String 'BLENDER_MCP_CONFIGURED'
  Ok "Blender MCP add-on installed + auto-start on :9876"
}

# ---------------------------------------------------------------------------
Step "4. FreeCAD MCP add-on (neka-nat/freecad-mcp)"
$freecadcmd = Get-ChildItem "$env:ProgramFiles" -Filter freecadcmd.exe -Recurse -ErrorAction SilentlyContinue |
              Sort-Object FullName -Descending | Select-Object -First 1 -ExpandProperty FullName
$fcTmp = Join-Path $env:TEMP 'freecad_mcp_dl'
if (Test-Path $fcTmp) { Remove-Item $fcTmp -Recurse -Force }
Info "Cloning FreeCAD MCP add-on..."
git clone --depth 1 https://github.com/neka-nat/freecad-mcp.git $fcTmp | Out-Null
$fcAddonSrc = Join-Path $fcTmp 'addon\FreeCADMCP'
$fcModDir = Join-Path $env:APPDATA 'FreeCAD\Mod'
New-Item -ItemType Directory -Force -Path $fcModDir | Out-Null
$fcDest = Join-Path $fcModDir 'FreeCADMCP'
if (Test-Path $fcDest) { Remove-Item $fcDest -Recurse -Force }
if (Test-Path $fcAddonSrc) { Copy-Item $fcAddonSrc $fcDest -Recurse -Force; Ok "FreeCAD add-on copied to $fcDest" }
else { Warn "Add-on folder not found in repo ($fcAddonSrc) — check repo layout." }
# Write auto_start_rpc via FreeCAD's own path resolver
if ($freecadcmd) {
  $fcCfg = Join-Path $env:TEMP 'fc_settings.py'
@'
import FreeCAD, os, json
p = os.path.join(FreeCAD.getUserAppDataDir(), "freecad_mcp_settings.json")
json.dump({"remote_enabled": False, "allowed_ips": "127.0.0.1", "auto_start_rpc": True}, open(p, "w"), indent=2)
print("FREECAD_SETTINGS_WRITTEN", p)
'@ | Set-Content -Path $fcCfg -Encoding UTF8
  & $freecadcmd $fcCfg 2>&1 | Select-String 'FREECAD_SETTINGS_WRITTEN'
  Ok "FreeCAD auto_start_rpc enabled (RPC :9875 on launch)"
} else { Warn "freecadcmd.exe not found — start FreeCAD once, then set auto_start_rpc, or re-run." }

# ---------------------------------------------------------------------------
Step "5. DONE (script part). Remaining steps happen INSIDE Cowork:"
@"
These cannot be scripted (managed by the Cowork app) — do them in Cowork:

  1) Connectors: enable the BLENDER, FREECAD, and ADOBE connectors in Cowork
     (Settings -> Connectors). Launch Blender and FreeCAD BEFORE starting the
     FreeCAD connector (it checks for FreeCAD at its startup).

  2) Install the plugin from the marketplace:
       /plugin marketplace add $MarketplaceRepo
       /plugin install interior-architect-studio@matloubian-studio

  3) (Optional) AI photo->render engine:
       /plugin marketplace add artokun/comfyui-mcp
     - NVIDIA box: install local ComfyUI (+ ControlNet models); auto-detected.
     - No GPU: set COMFYUI_URL to a free Google Colab ComfyUI tunnel URL.

  4) Verify: open Blender + FreeCAD, then ask the agent:
       "Summarize the Blender scene" and "list FreeCAD objects".

Apps were configured to auto-start their MCP servers on launch:
  - Blender  -> localhost:9876
  - FreeCAD  -> localhost:9875  (after the GUI loads)
STUDIO_ROOT = $StudioRoot
"@ | Write-Host -ForegroundColor Green
