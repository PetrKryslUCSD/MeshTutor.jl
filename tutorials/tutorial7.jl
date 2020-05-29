# # Selecting boundary faces

# In this tutorial, we will learn
# 
#    -  How to use some low-level functionality of the MeshCore library.
#    -  How to find the boundary of the mesh.
#    -  How to select pieces of the boundary surfaces.

# As an example we generate a regular tetrahedral mesh from hardwired arrays for
# the locations of the nodes and the connectivities of the elements.
include("samplet4.jl")
using Main.samplet4: samplet4mesh
xyz, cc = samplet4mesh()
# The two arrays `xyz`, `cc`, define the locations of the vertices (one per
# row), and  the numbers of the vertices connected by the tetrahedral elements 
# (again, one element per row of the array `cc`).

# Here we show some low-level operations using the core mesh library. The
# locations of the vertices are stored in static arrays in order to achieve fast
# access and processing.
using StaticArrays

# First we find out how many space coordinate dimensions there are (there should be 3).
N, T = size(xyz, 2), eltype(xyz)
# Now we can create an attribute for the vertex  shape collection to represent
# the locations of the vertices.
using MeshCore: VecAttrib
locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])

# Now we can create two shape collections, one for the vertices, and one for the
# tetrahedral elements. We also attach the geometry attribute to the vertex
# shape collection.
using MeshCore: P1, T4, ShapeColl
vrts = ShapeColl(P1, length(locs))
vrts.attributes["geom"] = locs
tets = ShapeColl(T4, size(cc, 1))

# Finally we connect the two shaped collections in an incidence relation. 
using MeshCore: IncRel
ir = IncRel(tets, vrts, cc)

# The incidence relation (which really represents what is meant by "mesh"), can
# be written out to a file for visualization.
using MeshSteward: vtkwrite
vtkwrite("samplet4-elements", ir)

# The boundary of the tetrahedral mesh may be derived by a topological operation
# that constructs the skeleton of the mesh and identifies faces that are on the
# boundary.
using MeshCore: boundary
bir = boundary(ir)

# Now we select the boundary faces which are inside a box. The box is defined by
# the six numbers, and then increased in all directions by a small amount in
# order to be able to capture vertices whose location is not precisely in the
# original box. This is important because the original box is in fact of zero
# volume,  being of zero thickness in the Y direction (both the lower and upper
# bound in Y are 8.0).
using MeshSteward: eselect
@show el = eselect(bir; box = [0.0, 3.0, 8.0, 8.0, 0.0, 5.0], inflate = 0.01)

# A subset of the boundary within the box (the faces given by the list `el`) may
# now be extracted and written out for visualization into a file.. Both the file
# exported above and this one can now be loaded into a visualization software 
# (`paraview`), and the correctness of the selection may be verified visually.
using MeshCore: subset
using MeshSteward: vtkwrite
vtkwrite("samplet4-boundary-y=8", subset(bir, el))


