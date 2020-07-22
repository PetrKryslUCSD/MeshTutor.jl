# MeshTutor.jl

Bundle of tutorials for the mesh-management library, [`MeshSteward`](https://github.com/PetrKryslUCSD/MeshSteward.jl.git), and the core mesh library, [`MeshCore`](https://github.com/PetrKryslUCSD/MeshCore.jl.git).

![Sample mesh](trunc_cyl_shell_0.png)

## Usage

### Executing the tutorial in notebook form with `mybinder`

The tutorials may be executed on `mybinder.org`. 

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/PetrKryslUCSD/MeshTutor.jl/master)

Entered the `tutorials` folder and open one of the tutorial notebooks (for instance `tutorial1.ipynb`). Then execute the notebook, either cell by cell or in its entirety.

The advantage is that no local installation of Julia and of the repository is needed. The disadvantage is that the graphics postprocessing will not be as easy as for local execution, since the binder cannot run the visualization program.  The visualization is still possible by using the "File" menu in the notebook interface, checking the box next to the generated file, and downloading it to your computer.


### Using a local copy of the repository

Clone the package to your working directory:
```
git clone https://github.com/PetrKryslUCSD/MeshTutor.jl.git
```

Change your working directory to `MeshTutor`. Start Julia and run
the following:
```
using Pkg; Pkg.activate("."); Pkg.instantiate()
```

Note that there is a Markdown version of the tutorials, which render nicely the code and the accompanying text. For instance Google Chrome is capable of displaying such markdown files quite well.

In general the tutorials require the folder `MeshTutor.jl/tutorials` to be the working directory since the scripts assume that the input files will be found in the current directory. So to run a tutorial, do
```
cd("tutorials")
```
open the tutorial file and execute it either in its entirety with `include("tutorial1.jl")` or line by line in the IDE (for instance Sublime Text or Visual Studio Code). 

#### Note

Please note that the tutorials may interfere with each other. Make sure to start a new Julia for each tutorial you wish to execute.
