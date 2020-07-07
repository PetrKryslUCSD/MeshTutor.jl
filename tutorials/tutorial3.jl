# # Searching a mesh

# In this tutorial, we will learn
# 
#    -  How to import an incidence relation from a file.
#    -  How to create a mesh from this incidence relation.
#    -  How to print the summary of the mesh.
#    -  How to search for some vertices.
#    -  How to export the selected vertices for visualization.

# First  we will use a `MeshSteward` function to import a NASTRAN mesh file.
# This file stores a tetrahedral mesh of a hollow cylinder.
using MeshSteward: import_NASTRAN
connectivities = import_NASTRAN("trunc_cyl_shell_0.nas");

# The result, `connectivities`, is an an array of incidence relations (in this
# case there is just one entry in this array). We can create a mesh
# from this incidence relation as
using MeshSteward: Mesh, attach!
mesh = Mesh()
attach!(mesh, connectivities[1]);

# Let us print the summary information for the mesh:
using MeshSteward: summary
println(summary(mesh))

# `(3, 0)` means relationship between three-dimensional finite elements and the
# zero dimensional vertices (dimension in the sense of manifolds). It is
# referred to as the code of the incidence relation. The final piece of
# information shows the attributes of the vertex shape collection: `geom`
# provides access to the locations of the vertices.

# The imported mesh can be exported, this time in a different format,
# suitable for visualization. The tetrahedral elements are the base incidence
# relation of the mesh.
using MeshSteward: baseincrel
using MeshSteward: vtkwrite
vtkwrite("trunc_cyl_shell_0-elements", baseincrel(mesh))

# Start "Paraview", load the file `"trunc_cyl_shell_0-elements.vtu"` and
# select for instance view as "Surface with Edges". The result will be a view
# of the surface of the tetrahedral mesh.
@async run(`paraview trunc_cyl_shell_0-elements.vtu`)

# Now we will locate some vertices. In particular, let us say we wish to select
# the vertices  in one of the cross-sections of the hollow cylinder, one at $$Z
# = 0.5$$. We shall use the method of a bounding box:  all vertices inside the
# bounding box will be selected. The bounding box will initially start as
# totally flat (zero volume), and in order to capture the vertices which are not
# *precisely* at $$Z = 0.5$$ (given the vagaries of floating-point numbers), we
# shall inflate the box to all sides by a small amount.
using MeshSteward: boundingbox, inflatebox!
box = boundingbox([-Inf -Inf 0.5; Inf Inf 0.5])
box = inflatebox!(box, 0.001)

# The function `vselect` will create an incidence relation that consists of the
# selected vertices.
using MeshSteward: vselect
selectedv = vselect(mesh, box = box)

# This is how many vertices  have been found in that cross-section:
using MeshCore: nshapes
@show nshapes(selectedv.left)

# The incidence relation consisting of the selected vertices may be exported for viewing
# with the "Paraview" visualization program. Select to visualize this mesh as
# "Points", and select the size of the points as 8.
using MeshSteward: vtkwrite
vtkwrite("trunc_cyl_shell_0-selected-vertices", selectedv)

# Note that a file of this name, `"trunc_cyl_shell_0-selected-vertices.vtu"` is
# provided with the installation. When you run this tutorial  you should get a
# file with the same contents. The selected  vertices may be visualized with the
# point glyphs ("Point Gaussian") in Paraview. Provided the Paraview executable
# is in your path, the line below should start it.
@async run(`paraview trunc_cyl_shell_0-selected-vertices.vtu`)

# It is also possible to start `paraview` and then manually load both
# files, `"trunc_cyl_shell_0-elements.vtu"` and
# `"trunc_cyl_shell_0-selected-vertices.vtu"` into the same visualization.

