# # Collecting boundary entities

# In this tutorial, we will learn
# 
#    -  How to access an attribute of an incidence relation.
#    -  How to find the bounding box of the mesh.

include("samplet4.jl")
using Main.samplet4: samplet4mesh

using StaticArrays
using MeshCore: P1, T4, ShapeColl, VecAttrib, IncRel
xyz, cc = samplet4mesh()
N, T = size(xyz, 2), eltype(xyz)
locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
vrts = ShapeColl(P1, length(locs))
tets = ShapeColl(T4, size(cc, 1))
ir = IncRel(tets, vrts, cc)
ir.right.attributes["geom"] = locs

using MeshPorter: vtkwrite
vtkwrite("samplet4-elements", ir)

using MeshCore: boundary
using MeshFinder: eselect

bir = boundary(ir)
bir.right.attributes["geom"] = locs
@show el = eselect(bir; box = [0.0, 3.0, 8.0, 8.0, 0.0, 5.0], inflate = 0.01)

using MeshCore: subset
using MeshPorter: vtkwrite
vtkwrite("samplet4-boundary-y=8", subset(bir, el))

# end
# end
# using .mt4topo1e1
# mt4topo1e1.test()

# using MeshCore: subset
# ssverts = subset(verts, vl)
# using MeshCore: nshapes
# @show nshapes(ssverts.left), nshapes(ssverts.right)
# vtkwrite("block-w-hole-vertices", ssverts)

