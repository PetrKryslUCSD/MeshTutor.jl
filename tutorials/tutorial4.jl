# # Constructing a boundary of a mesh

# In this tutorial, we will learn
# 
#    -  How to extract the boundary of the mesh.
#    -  How to understand the summary of the mesh.
#    -  How to export individual incidence relations for visualization.

# As in the previous tutorials, we import a NASTRAN mesh file.
# This file stores a tetrahedral mesh of a hollow cylinder.
using MeshPorter: import_NASTRAN
connectivities = import_NASTRAN("trunc_cyl_shell_0.nas");

# The mesh is created as before by inserting the incidence relation.
using MeshKeeper: Mesh, insert!
mesh = Mesh()
insert!(mesh, connectivities[1]);

# Now we extract an incidence relation for the boundary of the tetrahedral
# mesh.
using MeshKeeper: boundary
bir = boundary(mesh);

# Let us print the summary information for the mesh:
using MeshKeeper: summary
println(summary(mesh))

# The summary will look like this:
# ```
# Mesh mesh: (3, 0) = (elements, vertices): elements = 996 x T4, vertices = 376 x P1 {geom,};  (2, 0) = skeleton: shapes = 2368 x T3 {isboundary,}, vertices = 376 x P1 {geom,};     
# ```

# The information states that in the base incidence relation (`(3, 0)`) there
# are 996 T4 tetrahedral elements, 376 vertices. The second  incidence
# relation stored in the mesh (`(2, 0)`) is the skeleton of the tetrahedral
# mesh, i. e. collection of the faces of the tetrahedra. The vertices store as
# attribute their locations. The triangular faces of the skeleton also store
# an attribute, a Boolean flag that indicates whether or not the triangle is
# part of the boundary.

# We can access this information also through the boundary incidence relation computed above:
println(summary(bir))

# We can see that the boundary consists of 752 triangular facets. In order to
# visualize the boundary we will export it as a VTK file. 
using MeshKeeper: baseincrel
using MeshPorter: vtkwrite

# We shall also produce a file with all the  vertices so that we can visualize
# the vertices and the boundary in one plot. In order to get an incidence
# relation with the vertices, which is of code `(0, 0)`, we will use the
# `vertices` function.
using MeshKeeper: vertices

vtkwrite("trunc_cyl_shell_0-vertices", vertices(baseincrel(mesh)))

# And then we also export the triangular boundary facets.
vtkwrite("trunc_cyl_shell_0-facets", bir)

# Start "Paraview", load the two files, and
# select for instance view as "Surface with Edges" with transparency. The result will be a view
# of the surface of the triangular mesh of the surface and the vertices will be shown as dots.
@async run(`paraview `)