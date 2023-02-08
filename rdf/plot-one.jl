using Plots
include("movingaverage.jl")
include("polynomialregression.jl")

function plot_rdf()
    
    f = open("pedot.dat", "r")

    lines = readlines(f)

    x = []
    y = []

    for line in lines
        tokens = split(line)
        push!(x, parse(Float64, tokens[1]))
        push!(y, parse(Float64, tokens[2]))
    end

    X = movingaverage(x, 10)
    Y = movingaverage(y, 10)

    f = poly(X, Y, 6)

    plot(X, f, xlab="r(Å)", ylab="ρ(r)", grid=false, framestyle=:box)
    savefig("test.png")

end


plot_rdf()
