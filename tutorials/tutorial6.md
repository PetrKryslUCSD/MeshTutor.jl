# Collecting and visualizing boundary vertices

In this tutorial, we will learn

   -  How to import an Abaqus file.
   -  How to find the vertices on the boundary of the mesh.
   -  How to visualize the vertices on the boundary of the mesh.

The tutorial will produce files for mesh visualization in the
[Paraview](https://www.paraview.org/) format (VTK). One can display this
information by loading the file with `paraview.exe`. When the tutorial is
executed in `mybinder.org`, the graphics file needs to be downloaded to your
desktop, and then visualized locally.

In this tutorial we import an Abaqus mesh. It represents a rectangular block
with a circular opening, meshed with quadrilaterals.

```julia
using MeshSteward: import_ABAQUS
connectivities = import_ABAQUS("block-w-hole.inp");
```

The imported incidence relations are stored in an array, `connectivities`. In
the present case is just one such incidence relation in the file, and we will
use it to create the mesh of the block.

```julia
using MeshSteward: Mesh, attach!
mesh = Mesh()
attach!(mesh, connectivities[1]);
```

We can visualize the mesh by exporting the base relation of the mesh as a VTK
file.

```julia
using MeshSteward: vtkwrite
using MeshSteward: baseincrel
vtkwrite("block-w-hole", baseincrel(mesh))
```

The boundary of the mesh consists of curve (line) segments, and may be
extracted as:

```julia
using MeshSteward: boundary
bir = boundary(mesh);
vtkwrite("block-w-hole-boundary", bir)
```

To collect all vertices connected by the boundary segments, we can do:

```julia
using MeshSteward: connectedv
vl = connectedv(bir);
```

The result is a list of integer identifiers of the connected vertices. By
comparing the length of the list of the vertices on the boundary with the total
number of vertices (the number of shapes on the right of the incidence
relation), we can see that less than one fourth of the vertices lies on the
boundary.

```julia
using MeshCore: nshapes
@show length(vl)
@show nshapes(baseincrel(mesh).right)
```

The shape collection `baseincrel(mesh).right` represents the vertices in the
mesh. The very same collection may be retrieved from the mesh as:

```julia
using MeshSteward: vertices, summary
verts = vertices(mesh);
summary(verts)
```

The incidence relation `(0, 0)` that represents just the vertices on the
boundary can be created as a subset of all the vertices in the mesh.

```julia
using MeshCore: ir_subset, summary
ssverts = ir_subset(verts, vl);
summary(ssverts)
```

The vertices on the boundary may be exported for visualization into a VTK
file.

```julia
using MeshCore: nshapes
@show nshapes(ssverts.left), nshapes(ssverts.right)
```

Here we inspect the incidence relation. We can see that the shape collection on the left is called "shapes".

```julia
using MeshSteward: summary
@show summary(ssverts)
```

Hence, we instruct the export function to incorporate into the output file the
shape collection on the left of the incidence relation. We do that by
specifying the tag "shapes". The information will be written out as cell
data, and can be visualized with the glyphs. The entities represented in the
file are simply points. In paraview, they may be visualized with "3D glyphs"
as little balls: choose "Representation" to be "3D glyphs", and then the
glyph type "Sphere".

```julia
vtkwrite("block-w-hole-boundary-vertices", ssverts, [(name = "shapes",)])
```

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

