# # Mesh with implicit geometry

# In this tutorial, we will learn
# 
#    -  How to create a mesh using an implicit definition of the geometry.
#    -  

# The tutorial will produce files for mesh visualization in the 
# [Paraview](https://www.paraview.org/) format (VTK). One can display this
# information by loading the file with `paraview.exe`. When the tutorial is
# executed in `mybinder.org`, the graphics file needs to be downloaded to your
# desktop, and then visualized locally.

# We load the truncated cylindrical shell mesh from a file:
using StaticArrays

L, W, H = 1.5*pi, 3.0, 1.5
M, N, K = 13, 4, 2
linix = LinearIndices((M+1, N+1, K+1))
sn(m, n, k) = linix[m, n, k]
# sn(m, n, k) = m + (M+1)*(n-1) + (M+1)*(N+1)*(k-1)

C = SVector{8, Int}[]
for k in 1:K, n in 1:N, m in 1:M
    c = (
        sn(m, n, k), sn(m+1, n, k), sn(m+1, n+1, k), sn(m, n+1, k), 
        sn(m, n, k+1), sn(m+1, n, k+1), sn(m+1, n+1, k+1), sn(m, n+1, k+1)
        )
    push!(C, SVector{8, Int}(c))
end
loc = SVector{3, Float64}[]
for k in 1:K+1, n in 1:N+1, m in 1:M+1
    push!(loc, SVector{3, Float64}((m-1)/M*L, (n-1)/N*W, (k-1)/K*H))
end

using MeshCore: ShapeColl, H8, P1
elements = ShapeColl(H8, length(C), "elements")
vertices = ShapeColl(P1, length(loc), "vertices")
using MeshCore: VecAttrib
vertices.attributes["geom"] = VecAttrib(loc)
using MeshCore: IncRel
connectivities = IncRel(elements, vertices, C)

# We now write out a postprocessing file with the elements. Note that we pass
# the `connectivity` incidence relation to get the elements stored in the
# file.
using MeshSteward: vtkwrite
vtkwrite("block", connectivities)

cart = CartesianIndices((M+1, N+1, K+1))
using MeshCore: FunAttrib
R = 4.0
access_location(i) = let 
    ci  = cart[i]
    m, n, k = ci[1], ci[2], ci[3]
    a = (m-1)/M*L
    x, y, z = (R+(n-1)/N*W) * cos(a), (R+(n-1)/N*W) * sin(a), (k-1)/K*H * (1 + a)
    SVector{3, Float64}(x, y, z)
end
vertices.attributes["geom"] = FunAttrib(0.0, prod((M+1, N+1, K+1)), access_location);
vtkwrite("block2", connectivities)

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


