using Plots
include("movingaverage.jl")
include("polynomialregression.jl")

function plot_rdf()
    
    f = open("pedottosrho-50.dat", "r")

    lines = readlines(f)

    x = []
    y = []

    for line in lines
        tokens = split(line)
        push!(x, parse(Float64, tokens[1]))
        push!(y, parse(Float64, tokens[2]))
    end

    X = movingaverage(x, 5)
    Y = movingaverage(y, 5)

    f = poly(X, Y, 10)

    plot(X, f)
    savefig("test.png")

end


plot_rdf()
