# MeshTutor.jl

Bundle of tutorials for the mesh-management library, [`MeshSteward`](https://github.com/PetrKryslUCSD/MeshSteward.jl.git), and the core mesh library, [`MeshCore`](https://github.com/PetrKryslUCSD/MeshCore.jl.git).

![Sample mesh](trunc_cyl_shell_0.png)

## Usage

### Visualization

The tutorial will produce files for mesh visualization in the[Paraview]
(https://www.paraview.org/) format (VTK). One can display this information by
loading the file with `paraview.exe`. When the tutorial is executed in
`mybinder.org`, the graphics file needs to be downloaded to your desktop, and
then visualized locally. Executing the notebooks locally may start
`paraview.exe` automatically, *provided the executable is somewhere in the
path*. Otherwise they will be a harmless error: failure to start the
visualization program. Start then a program of your choice manually to
visualize the VTK files.

### Executing the tutorials in notebook form with `mybinder`

The tutorials may be executed on `mybinder.org`. 

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/PetrKryslUCSD/MeshTutor.jl/master)

Enter the `tutorials` folder and open one of the tutorial notebooks (for instance `tutorial1.ipynb`). Then execute the notebook, either cell by cell or in its entirety.

The advantage is that no local installation of Julia and of the repository is needed. The disadvantage is that the graphics postprocessing will not be as easy as for local execution, since the binder cannot run the visualization program.  The visualization is still possible by using the "File" menu in the notebook interface, checking the box next to the generated file, and downloading it to your computer.


### Using a local copy of the repository

Clone the package to your working directory:
```
git clone https://github.com/PetrKryslUCSD/MeshTutor.jl.git
```

Change your working directory to `MeshTutor.jl`. Start Julia and run
the following:
```
using Pkg; Pkg.activate("."); Pkg.instantiate()
Pkg.build()
```

In general the tutorials require the folder `MeshTutor.jl/notebooks` to be the working directory since the scripts assume that the input files will be found in the current directory. So to run a tutorial, do
```
using IJulia    
IJulia.notebook(dir = pwd(), detached = true)
```
head over to the `notebooks` folder, open the tutorial notebook, and evaluate in Jupyter.


## News

- 09/08/2020: Updated for MeshCore 0.10 and MeshSteward 0.7.


