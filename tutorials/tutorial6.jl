# # Collecting boundary entities

# In this tutorial, we will learn
# 
#    -  How to access an attribute of an incidence relation.
#    -  How to find the bounding box of the mesh.

# As in the previous tutorials, we import a NASTRAN mesh file.
# This file stores a tetrahedral mesh of a hollow cylinder.
using MeshPorter: import_ABAQUS
connectivities = import_ABAQUS("block-w-hole.inp");

using MeshKeeper: Mesh, insert!
mesh = Mesh()
insert!(mesh, connectivities[1]);


using MeshPorter: vtkwrite
using MeshKeeper: baseincrel
vtkwrite("block-w-hole", baseincrel(mesh))

using MeshKeeper: boundary
bir = boundary(mesh);
vtkwrite("block-w-hole-boundary", bir)

using MeshFinder: connectedv
vl = connectedv(bir);
using MeshCore: nshapes
@show length(vl)
@show nshapes(baseincrel(mesh).right)

using MeshKeeper: vertices
verts = vertices(mesh)

using MeshCore: subset
ssverts = subset(verts, vl)
using MeshCore: nshapes
@show nshapes(ssverts.left), nshapes(ssverts.right)
vtkwrite("block-w-hole-vertices", ssverts)

