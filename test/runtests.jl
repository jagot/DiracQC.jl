using DiracQC
using Test

reffile(name) = joinpath(dirname(@__FILE__), "refdata", "$(name).out")

@testset "DiracQC.jl" begin
    xenon_data = DiracQC.load(reffile("hf_Xe"))
    xenon_energies = xenon_data.energies
    @test xenon_energies.Electronic_energy ≈ -328.3499373239049
    @test xenon_energies.Nuclear_repulsion_energy ≈ 0 atol=1e-14
    @test xenon_energies.Total_energy ≈ -328.3499373239049
    
    @test length(xenon_energies.orbitals) == 7
    @test [o.symmetry for o in xenon_energies.orbitals] == vcat(repeat(["E1g"], 3), repeat(["E1u"], 4))

    @test size(xenon_energies.orbitals_combined) == (135, 6)
end
