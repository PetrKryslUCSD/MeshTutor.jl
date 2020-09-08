using Literate

sources_dir = joinpath(@__DIR__, "..", "src")
notebooks_dir = joinpath(@__DIR__, "..", "notebooks")

for tut1 in readdir(sources_dir)
    if occursin(r"tutorial.*.jl", tut1)
        # Literate.markdown(tut1, "."; documenter=false);
        Literate.notebook(joinpath(sources_dir, tut1), notebooks_dir; documenter=false, execute=false)
        cp(tut1,  joinpath(sources_dir, tut1), force=true)
    end
end

for insf in ["trunc_cyl_shell_0.nas", "block-w-hole.inp", "samplet4.jl", "t3_i1.png", "t4_i1.png", "t6_i1.png"]
    cp(insf,  joinpath(notebooks_dir, insf), force=true)
end