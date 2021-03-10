# # Mesh with implicit geometry

# In this tutorial, we will learn
# 
#    -  How to create a mesh of hexahedra.
#    -  How to create a mesh using an implicit definition of the geometry.

# The geometry is a ramp in the form of 3/4 part of a circle.

# The tutorial will produce files for mesh visualization in the 
# [Paraview](https://www.paraview.org/) format (VTK). One can display this
# information by loading the file with `paraview.exe`. When the tutorial is
# executed in `mybinder.org`, the graphics file needs to be downloaded to your
# desktop, and then visualized locally.

# We shall use static arrays for the connectivities and the coordinates.
using StaticArrays

# We start with a parametric domain: a rectangular block, with dimensions of
# different physical units. The extent of the domain: the first
# coordinate is angular. The next two coordinates are in the plane generating
# section.
L, W, H = 1.5*pi, 3.0, 1.5
R = 4.0

# This is the number of element edges along each dimension.
M, N, K = 13, 4, 2

# Now we define the indexing of the vertices. The linear index converts the
# triple of indexes along the three dimensions into a single number. the
# dimensions correspond to the number of nodes along direction.
linix = LinearIndices((M+1, N+1, K+1))
# The serial-number function converts the triple of indexes into a single linear
# index.
sn(m, n, k) = linix[m, n, k]

# Now we create the connectivities of the individual hexahedral cells. The
# numbering is given by the topologically regular character of the block domain.
C = SVector{8, Int}[]
for k in 1:K, n in 1:N, m in 1:M
    c = (
        sn(m, n, k), sn(m+1, n, k), sn(m+1, n+1, k), sn(m, n+1, k), 
        sn(m, n, k+1), sn(m+1, n, k+1), sn(m+1, n+1, k+1), sn(m, n+1, k+1)
        )
    push!(C, SVector{8, Int}(c))
end

# The locations of the vertices is also perfectly regular within the parametric
# domain. The nodes are distributed uniformly along each direction. the location
# in the physical space is computed from the parametric coordinates: the first
# coordinate is used as an angle, and `R` is the interior radius of the circular
# ramp.
loc = SVector{3, Float64}[]
for k in 1:K+1, n in 1:N+1, m in 1:M+1
    a = (m-1)/M*L
    x, y, z = (R+(n-1)/N*W) * cos(a), (R+(n-1)/N*W) * sin(a), (k-1)/K*H * (1 + a)
    push!(loc, SVector{3, Float64}(x, y, z))
end

# At this point we can create the shape collections.
using MeshCore: ShapeColl, H8, P1
# This is the collection of hexahedral shapes.
elements = ShapeColl(H8, length(C), "elements")
# And this is the collection of the vertices.
vertices = ShapeColl(P1, length(loc), "vertices")

# The geometry is attached is an attribute. Here we use vector attribute which
# actually stores three coordinates per vertex.
using MeshCore: VecAttrib
vertices.attributes["geom"] = VecAttrib(loc)
using MeshCore: IncRel
connectivities = IncRel(elements, vertices, C)

# We now write out a postprocessing file with the elements. Note that we pass
# the `connectivities` incidence relation to get the elements stored in the
# file.
using MeshSteward: vtkwrite
vtkwrite("block", connectivities)

# Now we will define another shape collection. This one will refer to geometry
# defined implicitly: through a function that returns the coordinates  of a
# vertex based on its serial number. Remember that serial numbers are stored in
# the connectivities.

vertices2 = ShapeColl(P1, prod((M+1, N+1, K+1)), "vertices2")

# The Cartesian indices will allow us to map the linear index to a Cartesian
# triple of indices.
cart = CartesianIndices((M+1, N+1, K+1))
using MeshCore: FunAttrib

# Note that this function defines the same geometry in physical space as the
# loop above. However, the geometry is not stored, it is returned as a triple of
# numbers.
access_location(i) = let 
    ci  = cart[i]
    m, n, k = ci[1], ci[2], ci[3]
    a = (m-1)/M*L
    x, y, z = (R+(n-1)/N*W) * cos(a), (R+(n-1)/N*W) * sin(a), (k-1)/K*H * (1 + a)
    SVector{3, Float64}(x, y, z)
end

# The geometry attribute is defined by providing access to the locations of the
# vertices through the function `access_location`.
vertices2.attributes["geom"] = FunAttrib(0.0, prod((M+1, N+1, K+1)), access_location);
connectivities = IncRel(elements, vertices2, C)
vtkwrite("block2", connectivities)

# Now both data sets have been written out. Load them into
# [Paraview](https://www.paraview.org/) and it should be possible to verify that
# those two meshes sets overlap perfectly.

true
