# Dirac

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jagot.github.io/Dirac.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jagot.github.io/Dirac.jl/dev)
[![Build Status](https://github.com/jagot/Dirac.jl/workflows/CI/badge.svg)](https://github.com/jagot/Dirac.jl/actions)
[![Coverage](https://codecov.io/gh/jagot/Dirac.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jagot/Dirac.jl)

Simple library to parse selected pieces of output from
[DIRAC](http://diracprogram.org/).

Run
```julia
using Dirac
Dirac.load(filename)
```
where `filename` is a file containing the textual output from a Dirac
run.
