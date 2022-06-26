using Plots

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
    for line in lines
        tokens = split(line)
        push!(X, parse(Float64, tokens[2]))
        push!(Y, parse(Float64, tokens[4]))
    end
    x = movingaverage(X, 5)
    y = movingaverage(Y, 5)
    
    f = poly(x, y, 7)
    
    plot(x, f)

    savefig("xrdplot.png")
end

xrd_plot("all-100.xrd")
