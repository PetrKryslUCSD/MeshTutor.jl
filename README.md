# MeshTutor.jl

Bundle of tutorials for MeshKeeper and its dependencies (all the way down to MeshCore.jl)

## Installation

Clone the package to your working directory:
```
git clone https://github.com/PetrKryslUCSD/MeshTutor.jl.git
```
Change your working directory to `MeshTutor`.
Run the following:
```
using Pkg; Pkg.activate("."); Pkg.instantiate()
```

Note that it is possible to generate a Markdown version of the tutorials, which render nicely the code and the accompanying text by running the file make.jl as
```
cd("tutorials")
include("make.jl")
```
For instance Google Chrome is capable of displaying such markdown files quite well.
