#using Plots
#using LaTeXStrings

#include("movingaverage.jl")
#include("polynomialregression.jl")


function xrd_plot(filename)
    
    f1 = open(filename, "r")
    
    #f2 = open("tos-extra-density.xrd", "r")
    lines = readlines(f1)
    #lines2 = readlines(f2)
    
    for i in 1:4
        popfirst!(lines)
        #popfirst!(lines2)
    end
    
#    println(lines)

    X = []
    Y = []
    
    #X2 = []
    #Y2 = []

    λ = 1.541838
    
    for line in lines
        tokens = split(line)
        k = parse(Float64, tokens[2])
        m = 4*π*sin(k * π/360)/λ
        push!(X, m)
        push!(Y, parse(Float64, tokens[4]))
    end
    #=
    for line in lines2
        tokens = split(line)
        k = parse(Float64, tokens[2])
        m = 4*π*sin(k * π/360)/λ
        push!(X2, m)
        push!(Y2, parse(Float64, tokens[4]))
    end
    =#
    

    #x2 = movingaverage(X2, 5)
    #y2 = movingaverage(Y2, 5)
    
    #x = movingaverage(X, 5)
    #y = movingaverage(Y, 5)
    
    #f = poly(x, y, 7)
    
    # Write Plotting Data

    out = open("super-high-density.dat", "w")
    
    for (idx, v) in enumerate(X)
        v1 = v
        v2 = Y[idx]
        write(out, "$v1 $v2 \n")
    end


    #f2 = poly(x2, y2, 7)
    
    #plot(x, f, xlab=L"Q (Å^{-1})", grid=false, legend=false, framestyle=:box, linecolor=:blue, linewidth=5, xtickfontsize=15, ytickfontsize=15, xguidefontsize=15, yguidefontsize = 15, legendfontsize=15)


    # plot(x, f, xlab=L"Q (Å^{-1})", label=L"\rho_{b}", grid=fa    lse, framestyle=:box, legend=:topleft, linewidth=5, xtickfont    size=18, ytickfontsize=18, xguidefontsize=18, yguidefontsize=    18, legendfontsize=18)

    #plot!(x2, f2, xlab=L"Q (Å^{-1})", label=L"2 \rho_{b}", grid=false, framestyle=:box, legend=:topleft, linewidth=5)

    #savefig("slab.png")
end

xrd_plot("all_three_rho.xrd")
