module Dirac

import Automa
import Automa.RegExp: @re_str
const re = Automa.RegExp

using DataFrames
using LinearAlgebra

using Formatting

# https://physics.nist.gov/cgi-bin/cuu/Value?auedm
const ea₀ = 8.4783536255e-30 # e*Bohr
# https://en.wikipedia.org/wiki/Debye
const Debye = 1e-21/299792458 # C*m
const Debye_au = Debye/ea₀

function read_until(fun::Function, io::IO, pred::Function)
    l = ""
    while !eof(io)
        l = readline(io)
        pred(l) && break
        fun(l)
    end
    l
end

read_until(fun::Function, io::IO, s::String) =
    read_until(fun, io, l -> occursin(s, l))

read_until(io::IO, pred) =
    read_until(l -> nothing, io, pred)

# * Automa

dec      = re"[-+]?[0-9]+"
prefloat = re"[-+]?([0-9]+\.[0-9]*|[0-9]*\.[0-9]+)"
float    = prefloat | re.cat(prefloat | re"[-+]?[0-9]+", re"[eE][-+]?[0-9]+")

dec.actions[:enter] = [:mark]
dec.actions[:exit] = [:dec]
float.actions[:enter] = [:mark]
float.actions[:exit] = [:float]

# * Energies

orbital_energies_machine = let
    energy = re.cat(re" *", float, re" +",
                    "(", re" *", dec, ")")
    energies = re.rep(energy)

    Automa.compile(energies)
end

orbital_energies_actions = Dict(
    :mark => :(mark = p),
    :float => :(push!(energies, parse(Float64, data[mark:p-1]))),
    :dec => :(push!(gs, parse(Int, data[mark:p-1])))
)

context = Automa.CodeGenContext()
@eval function read_orbital_energies(data::String)
    energies = Vector{Float64}()
    gs = Vector{Int}()
    mark = 0

    $(Automa.generate_init_code(context, orbital_energies_machine))

    # p_end and p_eof were set to 0 and -1 in the init code,
    # we need to set them to the end of input, i.e. the length of `data`.
    p_end = p_eof = lastindex(data)

    $(Automa.generate_exec_code(context, orbital_energies_machine, orbital_energies_actions))

    # We need to make sure that we reached the accept state, else the
    # input did not parse correctly
    iszero(cs) || error("failed to parse on byte ", p)

    (energies=energies, gs=gs)
end

function read_orbital_block(io::IO, header)
    symmetry = last(split(first(split(header, ":")), " "))
    parity = last(symmetry) == 'g' ? 1 : -1
    Ω = Rational(parse.(Int, split(last(split(header, " ")), "/"))...)
    
    energies = Vector{Float64}()
    gs = Vector{Int}()
    occupation = Vector{Float64}()
    f = 1.0
    read_until(io, l -> isempty(strip(l))) do l
        if occursin("*", l)
            f = parse(Float64, last(split(l, "=")))
        else
            e,g = read_orbital_energies(l)
            append!(energies, e)
            append!(gs, g)
            append!(occupation, fill(f, length(e)))
        end
    end
    df = DataFrame(E=energies, g=gs, occupation=occupation)
    (symmetry=symmetry, parity=parity, Ω=Ω,
     orbitals=df)
end

function read_energies(io::IO)
    energies = (;)
    read_until(io, "TOTAL ENERGY")
    read_until(io, "Eigenvalues") do l
        if occursin(":", l)
            k,v = strip.(split(l, ":"))
            energies = merge(energies, (Symbol(replace(k, " " => "_")) => parse(Float64, v),))
        end
    end
    for i = 1:3 readline(io) end
    h = readline(io)
    blocks = []
    while occursin("* Block", h)
        push!(blocks, read_orbital_block(io, h))
        h = readline(io)
    end
    dfs = map(blocks) do b
        m = size(b.orbitals,1)
        hcat(b.orbitals, DataFrame(Symmetry=fill(b.symmetry, m),
                                   Parity=fill(b.parity, m),
                                   Ω=fill(b.Ω, m)))
    end
    

    energies = merge(energies, (:orbitals => blocks,
                                :orbitals_combined => reduce(vcat, dfs)))

    energies
end


# * Interface

function load(io::IO)
    (energies=read_energies(io),)
end

load(filename::String) = open(load, filename)

end
