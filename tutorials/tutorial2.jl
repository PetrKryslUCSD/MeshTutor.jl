# # Saving and loading a mesh

# In this tutorial, we will learn
# 
#    -  How to save a mesh to a file.
#    -  How to load a mesh from a file.
#    -  How to find out the number of elements and their type.
#    -  How to find out the characteristics of the shape (shape descriptor).

# We will generate the triangular mesh inside a rectangular block.
# The block will have the dimensions shown below:
a, b = 1.0, 1.0
# The triangles will be generated in a regular pattern, with the number of
# edges per side of the block given as
na, nb = 2, 3

# The mesh will be generated by the package `MeshSteward`. We choose an
# orientation of the diagonals (in other words the pattern in which the block is
# tiled) as labeled `:b`.
using MeshSteward: T3block
conn = T3block(a, b, na, nb, :b);

# The variable `conn` is an incidence relation. This incidence relation will
# become the base relation of the mesh when it gets inserted into the mesh.
using MeshSteward: Mesh, attach!
m = Mesh()
attach!(m, conn);

# The embedding space in which the mesh lives is two-dimensional. We can verify
# that by
using MeshSteward: nspacedims
@show nspacedims(m)

# We can export the mesh into a set of files that are referred to as the MESH
# format. This will actually store the mesh as three separate files. The file
# `"Unit-square-mesh.mesh"` is the directory of the bundle of the mesh files,
# so to speak.
using MeshSteward: save
save(m, "Unit-square-mesh")
# Note the trio of files `"Unit-square-mesh.mesh"` (mesh  "directory"), and
# `"Unit-square-mesh-conn.dat"` (connectivity) and
# `"Unit-square-mesh-xyz.dat"` (locations of vertices).
readdir(".")

# We will now load the mesh we saved just now into another mesh that we create
# specifically for the purpose of comparing the two meshes.
using MeshSteward: load
m2 = load(Mesh(), "Unit-square-mesh");

# Now we compare the number of  elements  stored in those two meshes. First the
# vertices (those are the shapes on the right of the incidence relation).
using MeshCore: nshapes
using MeshSteward: baseincrel
@show nshapes(baseincrel(m).right) == nshapes(baseincrel(m2).right)

# Now  we compare the number of the triangular elements in those two meshes:
@show nshapes(baseincrel(m).left) == nshapes(baseincrel(m2).left)

# What is the name of the shape descriptor of the shape collection on the left 
# (that is what we usually consider the "elements" in a finite element mesh) of
# the base incidence relation of the mesh?
using MeshCore: shapedesc
@show shapedesc(baseincrel(m).left).name

# We would expect it to be the name of a three-node triangle, "T3".

# Are the shape descriptors of the shape collection on the left the same for the
# two meshes?
@show shapedesc(baseincrel(m).left) == shapedesc(baseincrel(m2).left)


# What is the name of the shape descriptor of the shape collection on the right 
# (that is what we usually consider the "nodes" in a finite element mesh) of
# the base incidence relation of the mesh?
using MeshCore: shapedesc
@show shapedesc(baseincrel(m).right).name

# P1 is the shape descriptor of a point shape. So vertices (nodes) are points.

# Are the shape descriptors of the shape collection on the right the same for the
# two meshes?
@show shapedesc(baseincrel(m).right) == shapedesc(baseincrel(m2).right)

