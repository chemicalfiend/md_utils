using Plots
using LaTeXStrings

include("movingaverage.jl")
include("polynomialregression.jl")


function xrd_plot(filename)
    
    f1 = open(filename, "r")

    lines = readlines(f1)
    
    for i in 1:4
        popfirst!(lines)
    end
    
#    println(lines)

    X = []
    Y = []
    
    λ = 1.541838
    
    for line in lines
        tokens = split(line)
        k = parse(Float64, tokens[2])
        m = 4*π*sin(k * π/360)/λ
        push!(X, m)
        push!(Y, parse(Float64, tokens[4]))
    end
    x = movingaverage(X, 5)
    y = movingaverage(Y, 5)
    
    f = poly(x, y, 7)
    
    plot(x, f, xlab=L"Q (Å^{-1})")

    savefig("xrdplot-150.png")
end

xrd_plot("all-150.xrd")
