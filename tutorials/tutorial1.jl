# # Generating and manipulating a tetrahedral mesh

# In this tutorial, we will learn
# 
#    -  How to generate a simple mesh.
#    -  How to inspect the mesh.
#    -  How to inspect the data stored in the mesh.
#    -  How to export the mesh and visualize it.

# The tutorial comes with a file containing representation of the mesh for
# visualization in the [Paraview](https://www.paraview.org/) format. One can
# visualize this mesh by loading the file `mymesh.vtu` with `paraview.exe`.
# One of the aims of this tutorial is to work with this mesh: the generated,
# and eventually store it in the visualization format.

# [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/PetrKryslUCSD/MeshTutor.jl/master?filepath=https%3A%2F%2Fgithub.com%2FPetrKryslUCSD%2FMeshTutor.jl%2Fblob%2Fmaster%2Ftutorials%2Ftutorial1.ipynb)

using Pkg
for p in ["StaticArrays", "WriteVTK", "MeshCore", "MeshSteward"]
    Pkg.add(p)
end
using StaticArrays, WriteVTK

# We will generate the tetrahedral mesh inside a rectangular block.
# The block will have the dimensions shown below:
a, b, c = 2.0, 2.5, 3.0
# The tetrahedra will be generated in a regular pattern, with the number of
# edges per side of the block given as
na, nb, nc = 2, 2, 3

# The mesh will be generated by the package `MeshSteward`.
using MeshSteward: T4block
conn = T4block(a, b, c, na, nb, nc);

# The variable `conn` is an incidence relation. This will become the base
# relation of the mesh.
using MeshSteward: Mesh, attach!
# The mesh is first created.
m = Mesh()
# Then the ``(3, 0)`` incidence relation, which defines the tetrahedral elements in terms of the vertices at their corners, is attached to it.
attach!(m, conn)

# We can now inspect the mesh by printing its summary.
println(summary(m))

# We can see that the relation links the tetrahedral elements and the vertices.
# In addition to its being the only relation in the mesh (at the moment), it is
# also what is called the *base* incidence relation.

# The relations in the mesh are accessed by code. The base relation  is
# described by the code:
using MeshSteward: basecode
@show irc = basecode(m)

# We can retrieve the base incidence relation from the mesh as
using MeshSteward: increl
conn = increl(m, basecode(m))

# We can access the data stored in the incidence relation as follows. For
# instance, the connectivity of the mesh can be accessed with `retrieve`. The
# numbers of the vertices for the first tetrahedron are:
using MeshCore: retrieve
@show retrieve(conn, 1)

# We can check that the incidence relation stores four vertices per tetrahedron as
using MeshCore: nentities
@show nentities(conn, 1) == 4
# We checked it for the first tetrahedron, but for this type of incidence
# relation all relations store the same number of entities.

# The vertex shape collection stores the locations of the vertices as an
# attribute.
using MeshCore: attribute
@show geom = attribute(conn.right, "geom")

# The coordinates of the vertices of the first tetrahedron can be accessed as
for j in 1:nentities(conn, 1)
    k = retrieve(conn, 1, j)
    println("Vertex $(j): global number $(k)")
    println("   $(geom[k])")
end

# The mesh may be exported for viewing with the "Paraview" visualization
# program. Note that a file of this name is provided with the installation.
# When you run this tutorial  you should get the same file. So a quick way of
# checking that things are working as expected is to  visualize what you
# should get by loading the file `mymesh.vtu` with `paraview.exe`, and only
# then running the export in the two lines below and looking at the results again.
using MeshSteward: vtkwrite
vtkwrite("mymesh", conn)

# Start "Paraview", load the file `mymesh.vtu` and select for instance view as
# "Surface with Edges".

# Provided `paraview.exe` is installed and in the path where your operating
# system searches for executables, you may be able to run the following command
# to bring up the visualization program.
@async run(`paraview mymesh.vtu`)

# The executable will load the mesh. The mesh can then be visualized in
# different ways, for instance as a surface with edges.
