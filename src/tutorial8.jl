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

module mmeses1
using StaticArrays
using MeshCore: nshapes
using MeshCore: attribute, nrelations, skeleton, boundary, subset
using MeshSteward: import_NASTRAN, vtkwrite, eselect
using Test
function test()
    connectivities = import_NASTRAN("trunc_cyl_shell_0.nas")
    @test length(connectivities) == 1
    connectivity = connectivities[1]
    @test (nshapes(connectivity.right), nshapes(connectivity.left)) == (376, 996)
    vertices = connectivity.right
    geom = attribute(vertices, "geom")
    vtkwrite("trunc_cyl_shell_0-search", connectivity)
    try rm("trunc_cyl_shell_0-search.vtu"); catch end
    
    bir = boundary(connectivity)
    el = eselect(bir; facing = true, direction = x -> [0.0, 0.0, 1.0], dotmin = 0.99)
    @test length(el) == 44
    vtkwrite("trunc_cyl_shell_0-search-z=top", subset(bir, el))
    try rm("trunc_cyl_shell_0-search-z=top.vtu"); catch end
    el = eselect(bir; facing = true, direction = x -> [-x[1], -x[2], 0.0], dotmin = 0.99)
    @test length(el) == 304
    vtkwrite("trunc_cyl_shell_0-search-interior", subset(bir, el))
    try rm("trunc_cyl_shell_0-search-interior.vtu"); catch end
    true
end
end
using .mmeses1
mmeses1.test()


module mmeses2
using StaticArrays
using MeshCore: P1, T3, ShapeColl,  manifdim, nvertices, nshapes, indextype, IncRel
using MeshCore: attribute, nrelations, skeleton, boundary, subset, VecAttrib
using MeshSteward: import_NASTRAN, vtkwrite, eselect, connectedv
using ..samplet3: samplet3mesh
using Test
function test()
    xyz, cc = samplet3mesh()
    # Construct the initial incidence relation
    N, T = size(xyz, 2), eltype(xyz)
    locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
    vrts = ShapeColl(P1, length(locs))
    tris = ShapeColl(T3, size(cc, 1))
    ir = IncRel(tris, vrts, cc)
    vl = connectedv(ir)
    @test length(vl) == size(xyz, 1)
    bir = boundary(ir)
    bir.right.attributes["geom"] = locs
    
    el = eselect(bir; facing = true, direction = x -> [-1.0, 0.0], dotmin = 0.99)
    @test length(el) == 3
    vtkwrite("samplet3mesh-search", ir)
    vtkwrite("samplet3mesh-search-x=0_0", subset(bir, el))
    try rm("samplet3mesh-search" * ".vtu"); catch end
    try rm("samplet3mesh-search-x=0_0" * ".vtu"); catch end
    true
end
end
using .mmeses2
mmeses2.test()

