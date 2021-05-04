# DiracQC

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jagot.github.io/DiracQC.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jagot.github.io/DiracQC.jl/dev)
[![Build Status](https://github.com/jagot/DiracQC.jl/workflows/CI/badge.svg)](https://github.com/jagot/DiracQC.jl/actions)
[![Coverage](https://codecov.io/gh/jagot/DiracQC.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jagot/DiracQC.jl)

Simple library to parse selected pieces of output from
[DIRAC](http://diracprogram.org/).

Run
```julia
using DiracQC
DiracQC.load(filename)
```
where `filename` is a file containing the textual output from a DIRAC
run.
