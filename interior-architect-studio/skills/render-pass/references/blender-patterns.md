# Blender interior patterns (adapt as needed)

Run via `mcp__Blender__execute_blender_code`. Always `get_objects_summary` first. Set mode
and selection explicitly; update the depsgraph before reading computed values.

## Block out a room (floor + walls)
```python
import bpy
FT = 0.3048
W, D, H = 15*FT, 20*FT, 9.5*FT
# floor
bpy.ops.mesh.primitive_plane_add(size=1)
floor = bpy.context.active_object; floor.name = "Floor"
floor.scale = (W/2, D/2, 1); floor.location = (0,0,0)
# one wall (duplicate/rotate for the others)
bpy.ops.mesh.primitive_cube_add(size=1)
wall = bpy.context.active_object; wall.name = "Wall_N"
wall.scale = (W/2, 0.05, H/2); wall.location = (0, D/2, H/2)
bpy.context.view_layer.update()
```

## Principled PBR material
```python
import bpy
def pbr(name, base, rough=0.4, metal=0.0):
    m = bpy.data.materials.get(name) or bpy.data.materials.new(name)
    m.use_nodes = True
    bsdf = m.node_tree.nodes.get("Principled BSDF")
    bsdf.inputs["Base Color"].default_value = (*base, 1)
    bsdf.inputs["Roughness"].default_value = rough
    bsdf.inputs["Metallic"].default_value = metal
    return m
floor = bpy.data.objects["Floor"]
floor.data.materials.clear()
floor.data.materials.append(pbr("PorcelainMatte", (0.12,0.12,0.13), rough=0.6))
```
For stone/wood, add an Image Texture node pointing at a map in `_studio/material_library`.

## Layered lighting (warm)
```python
import bpy
def area(name, loc, energy, size=1.0, k=2900):
    l = bpy.data.lights.new(name, 'AREA'); l.energy = energy; l.size = size
    # warm tint
    l.color = (1.0, 0.85, 0.72)
    o = bpy.data.objects.new(name, l); o.location = loc
    bpy.context.collection.objects.link(o); return o
area("Ambient", (0,0,2.8), 60, size=3.0)      # soft fill
area("Task_Vanity", (0,-2,2.4), 30, size=0.6) # task
area("Accent_Cove", (0,2.6,2.7), 15, size=2.0)# accent
```

## Camera at eye level
```python
import bpy, math
cam_data = bpy.data.cameras.new("Cam"); cam_data.lens = 28
cam = bpy.data.objects.new("Cam", cam_data)
cam.location = (0, -3.0, 1.6); cam.rotation_euler = (math.radians(88), 0, 0)
bpy.context.collection.objects.link(cam); bpy.context.scene.camera = cam
```

## EEVEE render to PNG (default on laptop)
```python
import bpy, os
sc = bpy.context.scene
# Engine enum differs by version: Blender 5.x uses 'BLENDER_EEVEE';
# Blender 4.2–4.5 used 'BLENDER_EEVEE_NEXT'. Pick whichever exists.
valid = {i.identifier for i in sc.render.bl_rna.properties['engine'].enum_items}
sc.render.engine = ('BLENDER_EEVEE' if 'BLENDER_EEVEE' in valid
                    else 'BLENDER_EEVEE_NEXT' if 'BLENDER_EEVEE_NEXT' in valid
                    else 'CYCLES')   # use 'CYCLES' only on the NVIDIA workstation
sc.render.resolution_x, sc.render.resolution_y = 1920, 1080
root = os.environ.get("STUDIO_ROOT", os.getcwd())
out = os.path.join(root, "PrimaryBath", "03_renders"); os.makedirs(out, exist_ok=True)
sc.render.filepath = os.path.join(out, "concept_01.png")
bpy.ops.render.render(write_still=True)
bpy.ops.wm.save_as_mainfile(filepath=os.path.join(root,"PrimaryBath","02_models","primary_bath.blend"))
```

## Freestyle line-art elevation (for the photo-to-elevation skill)
```python
import bpy
sc = bpy.context.scene
sc.render.use_freestyle = True
vl = bpy.context.view_layer; vl.use_freestyle = True
# set an orthographic camera facing the wall, white world, then render for a clean elevation
```
