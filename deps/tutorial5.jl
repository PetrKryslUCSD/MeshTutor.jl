# # Accessing attributes and finding the bounding box

# In this tutorial, we will learn
# 
#    -  How to access an attribute of an incidence relation.
#    -  How to access the values in an attribute.
#    -  How to find the bounding box of the mesh.

# As in the previous tutorials, we import a NASTRAN mesh file.
# This file stores a tetrahedral mesh of a hollow cylinder.
using MeshSteward: import_NASTRAN
connectivities = import_NASTRAN("trunc_cyl_shell_0.nas");

# The mesh is created as before and the incidence relation is attached to it.
using MeshSteward: Mesh, attach!
mesh = Mesh()
attach!(mesh, connectivities[1]);

# The base incidence relation of the mesh may be retrieved as:
using MeshSteward: baseincrel
ir = baseincrel(mesh);

# Let us look at a summary  of this incidence relation:
using MeshSteward: summary
println(summary(ir))

# We can see that it relates tetrahedral elements with vertices, and the
# vertices shape collection has an attribute known under the name "geom".
# We can retrieve this attribute as
using MeshSteward: geometry
geom = geometry(mesh);

# The attribute holds one value per entity with which it is associated. In
# particular, for the geometry attribute we retrieved above from the mesh,
# there is one value (coordinate tuple) for each vertex. For instance, the
# location of vertex 1 is
@show geom[1]

# The number of values stored in the attribute should match the number of
# vertices in the mesh
using MeshCore: nshapes
@show length(geom) == nshapes(ir.right)

# Accessing the attribute "geom" provides access to the locations of the
# vertices, and hence to the geometry of the mesh as it consists of
# isoparametric elements. This is how we can calculate the bounding box of the
# mesh.
using MeshSteward: initbox, updatebox!
box = initbox(geom[1])
for i in 1:length(geom)
    updatebox!(box, geom[i])
end
@show box

# So the vertices of the mesh all have coordinates ``-0.275 \le x  \le  0.275
# ``, ``-0.275 \le y  \le  0.275 ``, and ``0.0   \le z  \le  0.5``.    
