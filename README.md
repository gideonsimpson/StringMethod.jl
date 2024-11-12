# StringMethod.jl

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://gideonsimpson.github.io/StringMethod.jl/stable)[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://gideonsimpson.github.io/StringMethod.jl/dev)


Julia implementation of the String Method for computing transition paths and
saddle points on energy landscapes.  This also implements the Climbing Image
Method for refining estimates of the saddle points.

This currently only implements the simplified string method as developed in E,
Ren, and Vanden-Eijnden (2007).  These are but two method amongst many for
finding minimum energy pathways (MEP), and saddle point search strategies.  See,
also, the Nudged Elastic Band method (NEB).

# Acknowledgements
This work was supported in part by the US National Science Foundation Grant DMS-1818716, DMS-2111278.

# References
1. [String method for the study of rare events by E, Ren, and Vanden-Eijnden](https://doi.org/10.1103/PhysRevB.66.052301)
2. [Simplified and improved string method for computing the minimum energy paths in barrier-crossing events by E, Ren, and Vanden-Eijnden](https://aip.scitation.org/doi/10.1063/1.2720838)
3. [A climbing image nudged elastic band method for finding saddle points and minimum energy paths by Henkelman and Uberuaga](https://doi.org/10.1063/1.1329672)
