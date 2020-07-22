# MeshTutor.jl

Bundle of tutorials for the mesh-management library, [`MeshSteward`](https://github.com/PetrKryslUCSD/MeshSteward.jl.git), and the core mesh library, [`MeshCore`](https://github.com/PetrKryslUCSD/MeshCore.jl.git).

![Sample mesh](trunc_cyl_shell_0.png)

## Installation

Clone the package to your working directory:
```
git clone https://github.com/PetrKryslUCSD/MeshTutor.jl.git
```

## Usage

### Using Binder

The tutorials may be executed on `mybinder.org`. 
# [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/PetrKryslUCSD/MeshTutor.jl/master)
The advantage is that no local installation of Julia and of the repository is needed. The disadvantage is that the graphics postprocessing will not be as easy as for local execution, since the binder cannot run the visualization program.  The visualization is still possible by using the "File" menu,  checking the generated file, and downloading it to your computer.


### Using a local of the repository

Change your working directory to `MeshTutor`. Start Julia and run
the following:
```
using Pkg; Pkg.activate("."); Pkg.instantiate()
```

Note that it is possible to generate a Markdown version of the tutorials, which render nicely the code and the accompanying text by running the file `make.jl` as
```
cd("tutorials")
include("make.jl")
```
For instance Google Chrome is capable of displaying such markdown files quite well.

In general the tutorials require the folder `MeshTutor.jl/tutorials` to be the working directory since the scripts assume that the input files will be found in the current directory. So to run a tutorial, do
```
cd("tutorials")
```
open the tutorial file and execute it either in its entirety or line by line. 

## Note

Please note that the tutorials may interfere with each other. Make sure to start a new Julia for each tutorial you wish to execute.
