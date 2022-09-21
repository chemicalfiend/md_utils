using Plots
using LaTeXStrings

include("movingaverage.jl")
include("polynomialregression.jl")


function xrd_plot(filename)
    
    f1 = open(filename, "r")
    
    f2 = open("all-50.xrd", "r")
    lines = readlines(f1)
    lines2 = readlines(f2)
    
    for i in 1:4
        popfirst!(lines)
        popfirst!(lines2)
    end
    
#    println(lines)

    X = []
    Y = []
    
    x2 = []
    y2 = []

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
        push!(x2, m)
        push!(y2, parse(Float64, tokens[4]))
    end

    X2 = movingaverage(x2, 5)
    Y2 = movingaverage(y2, 5)
    

    x = movingaverage(X, 5)
    y = movingaverage(Y, 5)
    
    f = poly(x, y, 7)
    f2 = poly(x2, y2, 7)
    
    plot(x, f, xlab=L"Q (Å^{-1})", label="high-density")
    
    plot!(x2, f2, label="low-density")

    savefig("xrdplot.png")
end

xrd_plot("all1.xrd")
