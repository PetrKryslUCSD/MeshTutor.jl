# # Searching boundary entities

# In this tutorial, we will learn
# 
#    -  How to access an attribute of an incidence relation.
#    -  How to find the bounding box of the mesh.

# The tutorial will produce files for mesh visualization in the 
# [Paraview](https://www.paraview.org/) format (VTK). One can display this
# information by loading the file with `paraview.exe`. When the tutorial is
# executed in `mybinder.org`, the graphics file needs to be downloaded to your
# desktop, and then visualized locally.

# We load the truncated cylindrical shell mesh from a file:
using StaticArrays
using MeshSteward: import_NASTRAN

connectivities = import_NASTRAN("trunc_cyl_shell_0.nas")
# There should be only a single incidence relation here:
@show length(connectivities) == 1

# The incidence relation is now extracted from the array:
connectivity = connectivities[1]

# We can check that the mesh was loaded correctly (of course in this case we
# know how many vertices and how many elements there should be).
using MeshCore: nshapes
@show (nshapes(connectivity.right), nshapes(connectivity.left)) == (376, 996)

# The vertices are the shape collection on the right of the incidence relation.
vertices = connectivity.right

# We now write out a postprocessing file with the elements. Note that we pass
# the `connectivity` incidence relation to get the elements stored in the
# file.
using MeshSteward: vtkwrite
vtkwrite("trunc_cyl_shell_0-search", connectivity)

# Compute the boundary incidence relation: the facets bounding the domain.
using MeshCore: ir_boundary
bir = ir_boundary(connectivity)

# Select the boundary faces whose normals point in the direction `[0.0, 0.0,
# 1.0]`, in the sense that the dot product between the normal in this
# direction  >= 0.99. 
using MeshSteward: eselect
el = eselect(bir; facing = true, direction = x -> [0.0, 0.0, 1.0], dotmin = 0.99)

# We know how many triangles compose this part of the boundary: check the length
# of the list of the triangles.
@show length(el) == 44

# Now export the triangles as a VTK file. This can now be displayed side-by-side
# with the original mesh in `"trunc_cyl_shell_0-search.vtk"`. The subset
# defined by the list `el` from the boundary incidence relation is extracted
# and passed to `vtkwrite`.
using MeshCore: ir_subset
vtkwrite("trunc_cyl_shell_0-search-z=top", ir_subset(bir, el))

# Similar procedure can be applied to select the triangular faces on the
# cylindrical surface inside the shell. The direction is now defined by taking
# the location of the point where the normal is calculated, connecting it with
# the axis of revolution.
el = eselect(bir; facing = true, direction = x -> [-x[1], -x[2], 0.0], dotmin = 0.99)

# Again, we know how many triangles compose this part of the boundary: check the
# length of the list of the triangles.
@show length(el) == 304

# Now export the triangles as a VTK file. This can now be displayed side-by-side
# with the original mesh in `"trunc_cyl_shell_0-search.vtk"`.
vtkwrite("trunc_cyl_shell_0-search-interior", ir_subset(bir, el))


