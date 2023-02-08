using Plots
using LaTeXStrings

include("movingaverage.jl")
include("polynomialregression.jl")


function xrd_plot(filename)
    
    f1 = open(filename, "r")
    
    f2 = open("tos-extra-density.xrd", "r")
    lines = readlines(f1)
    lines2 = readlines(f2)
    
    for i in 1:4
        popfirst!(lines)
        popfirst!(lines2)
    end
    
#    println(lines)

    X = []
    Y = []
    
    X2 = []
    Y2 = []

    λ = 1.541838
    
    for line in lines
        tokens = split(line)
        k = parse(Float64, tokens[2])
        m = 4*π*sin(k * π/360)/λ
        push!(X, m)
        push!(Y, parse(Float64, tokens[4]))
    end
    
    for line in lines2
        tokens = split(line)
        k = parse(Float64, tokens[2])
        m = 4*π*sin(k * π/360)/λ
        push!(X2, m)
        push!(Y2, parse(Float64, tokens[4]))
    end
    

    x2 = movingaverage(X2, 5)
    y2 = movingaverage(Y2, 5)
    

    x = movingaverage(X, 5)
    y = movingaverage(Y, 5)
    
    f = poly(x, y, 7)
    f2 = poly(x2, y2, 7)
    
    out1 = open("low-density.dat", "w")
    out2 = open("high-density.dat", "w")
    
    for (idx, v) in enumerate(x)
        v1 = v
        v2 = f[idx]
        write(out1, "$v1 $v2 \n")
    end

    
    for (idx, v) in enumerate(x2)
        v1 = v
        v2 = f2[idx]
        write(out2, "$v1 $v2 \n")
    end
   
    close(out1)
    close(out2)

    plot(x, f, xlab=L"Q (Å^{-1})", label=L"\rho_{b}", grid=false, framestyle=:box, legend=:topleft, linecolor=:blue,linewidth=5, xtickfontsize=15, ytickfontsize=15, xguidefontsize=15, yguidefontsize=15, legendfontsize=15)

    plot!(x2, f2, xlab=L"Q (Å^{-1})", label=L"2 \rho_{b}", grid=false, framestyle=:box, legend=:topleft, linecolor=:red, linewidth=5, xtickfontsize=15, ytickfontsize=15, xguidefontsize=15, yguidefontsize=15, legendfontsize=15)
    #plot!(x2, f2, xlab=L"Q (Å^{-1})", label=L"2 \rho_{b}", grid=false, framestyle=:box, legend=:topleft, linewidth=5)

    savefig("density-compare.png")
end

xrd_plot("all-50.xrd")
