# # Collecting and visualizing boundary vertices

# In this tutorial, we will learn
# 
#    -  How to import an Abaqus file.
#    -  How to find the vertices on the boundary of the mesh.
#    -  How to visualize the vertices on the boundary of the mesh.

# In this tutorial we import an Abaqus mesh. It represents a rectangular block
# with a circular opening, meshed with quadrilaterals. 
using MeshSteward: import_ABAQUS
connectivities = import_ABAQUS("block-w-hole.inp");

# The imported incidence relations are stored in an array, `connectivities`. In
# the present case is just one such incidence relation in the file, and we will
# use it to create the mesh of the block.
using MeshSteward: Mesh, attach!
mesh = Mesh()
attach!(mesh, connectivities[1]);

# We can visualize the mesh by exporting the base relation of the mesh as a VTK
# file.
using MeshSteward: vtkwrite
using MeshSteward: baseincrel
vtkwrite("block-w-hole", baseincrel(mesh))

# The boundary of the mesh would consist of line segments, and may be extracted
# as:
using MeshSteward: boundary
bir = boundary(mesh);
vtkwrite("block-w-hole-boundary", bir)

# To collect all vertices connected by the boundary segments, we can do:
using MeshSteward: connectedv
vl = connectedv(bir);

# The result is a list of integer identifiers of the connected vertices. By
# comparing the length of the list of the vertices on the boundary with the total
# number of vertices (the number of shapes on the right of the incidence
# relation), we can see that less than one fourth of the vertices lies on the
# boundary. 
using MeshCore: nshapes
@show length(vl)
@show nshapes(baseincrel(mesh).right)

# The shape collection `baseincrel(mesh).right` represents the vertices in the
# mesh. The very same collection may be retrieved from the mesh as: 
using
MeshSteward: vertices 
verts = vertices(mesh)

# The incidence relation `(0, 0)` that represents just the vertices on the
# boundary can be created as a subset of all the vertices in the mesh.
using MeshCore: ir_subset
ssverts = ir_subset(verts, vl)

# The vertices on the boundary may be exported for visualization into a VTK
# file. The entities represented in the file are simply points. They may be
# visualized with "Point Gaussian" as little balls.
using MeshCore: nshapes
@show nshapes(ssverts.left), nshapes(ssverts.right)
vtkwrite("block-w-hole-vertices", ssverts)

