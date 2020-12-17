using Literate

@show sources_dir = joinpath(@__DIR__, "..", "deps")
notebooks_dir = joinpath(@__DIR__, "..", "notebooks")

if !isdir(notebooks_dir)
    mkdir(notebooks_dir)    
end

for t in readdir(sources_dir)
        @show t
    if occursin(r"tutorial.*.jl", t)
        # Literate.markdown(t, "."; documenter=false);
        Literate.notebook(joinpath(sources_dir, t), notebooks_dir; documenter=false, execute=false)
        cp(t,  joinpath(notebooks_dir, t), force=true)
    end
end

for insf in ["trunc_cyl_shell_0.nas", "block-w-hole.inp", "samplet4.jl", "t3_i1.png", "t4_i1.png", "t6_i1.png"]
    cp(insf,  joinpath(notebooks_dir, insf), force=true)
end