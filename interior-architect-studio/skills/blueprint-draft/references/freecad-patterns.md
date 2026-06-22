# FreeCAD drafting patterns (adapt as needed)

All run through `mcp__freecad__execute_python_script`. Units: model in mm; 1 ft = 304.8 mm.
Always `list_objects` first; never assume an empty document.

## New document + room shell (Draft wires)
```python
import FreeCAD as App, Draft
doc = App.newDocument("PrimaryBath")
FT = 304.8
w, d = 15*FT, 20*FT           # interior 15' x 20'
t = 4.5*25.4                  # ~4.5in wall
# interior boundary
pts = [App.Vector(0,0,0), App.Vector(w,0,0), App.Vector(w,d,0),
       App.Vector(0,d,0), App.Vector(0,0,0)]
interior = Draft.make_wire(pts, closed=True)
interior.Label = "Walls_Interior"
doc.recompute()
```

## Place a fixture footprint (rectangle)
```python
import Draft, FreeCAD as App
FT, IN = 304.8, 25.4
tub = Draft.make_rectangle(length=66*IN, height=32*IN)   # 66x32 freestanding tub
tub.Placement.Base = App.Vector(1*FT, 16*FT, 0)
tub.Label = "Fixture_Tub"
App.ActiveDocument.recompute()
```

## Add a dimension (Draft)
```python
import Draft, FreeCAD as App
dim = Draft.make_dimension(App.Vector(0,0,0), App.Vector(15*304.8,0,0))
dim.Label = "Dim_Width"
App.ActiveDocument.recompute()
```

## Export DXF (and save)
```python
import FreeCAD as App, importDXF, os
doc = App.ActiveDocument
root = os.environ.get("STUDIO_ROOT", os.getcwd())
out = os.path.join(root, "PrimaryBath", "01_plans")
os.makedirs(out, exist_ok=True)
objs = [o for o in doc.Objects]
importDXF.export(objs, os.path.join(out, "primary_bath_plan.dxf"))
doc.saveAs(os.path.join(out, "primary_bath.fcstd"))
```

## TechDraw sheet (for a titled PDF)
```python
import FreeCAD as App, TechDraw
doc = App.ActiveDocument
page = doc.addObject('TechDraw::DrawPage','Page')
tmpl = doc.addObject('TechDraw::DrawSVGTemplate','Template')
# point tmpl.Template at an A3/Arch template .svg, then add a DrawViewPart of the plan
doc.recompute()
```

Tip: keep Walls / Fixtures / Dimensions / Notes as separate Draft groups so layers map
cleanly into the exported DXF.
