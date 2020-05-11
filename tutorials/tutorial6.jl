# # Collecting boundary entities

# In this tutorial, we will learn
# 
#    -  How to access an attribute of an incidence relation.
#    -  How to find the bounding box of the mesh.

# As in the previous tutorials, we import a NASTRAN mesh file.
# This file stores a tetrahedral mesh of a hollow cylinder.
using MeshPorter: import_NASTRAN
connectivities = import_NASTRAN("trunc_cyl_shell_0.nas");

# The mesh is created as before by inserting the incidence relation.
using MeshKeeper: Mesh, insert!
mesh = Mesh()
insert!(mesh, connectivities[1]);

# The base incidence relation of the mesh may be retrieved as:
using MeshKeeper: baseincrel
ir = baseincrel(mesh);

# Let us look at a summary  of this incidence relation:
using MeshKeeper: summary
println(summary(ir))

# We can see that it relates tetrahedral elements with vertices, and the
# vertices shape collection has an attribute known under the name "geom".
# We can retrieve this attribute as
using MeshCore: attribute
geom = attribute(ir.right, "geom")

# Accessing the attribute "geom" provides access to the locations of the
# vertices, and hence to the geometry of the mesh as it consists of
# isoparametric elements. This is how we can calculate the bounding box of the
# mesh.
using MeshFinder: initbox, updatebox!
using MeshCore: nvals
box = initbox(geom.co(1))
for i in 1:nvals(geom.co)
    updatebox!(box, geom.co(i))
end
@show box

# So the vertices of the mesh all have coordinates ``-0.275 \le x  \le  0.275
# ``, ``-0.275 \le y  \le  0.275 ``, and ``0.0   \le z  \le  0.5``.    
