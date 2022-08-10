using Plots
using LaTeXStrings
include("movingaverage.jl")
include("polynomialregression.jl")

function plot_rdf_tos()
    ftos50 = open("pedottosrho-50.dat", "r")
    ftos100 = open("pedottosrho-100.dat", "r")
    ftos150 = open("pedottosrho-150.dat", "r")
    ftos200 = open("pedottosrho-200.dat", "r") 

    linestos50 = readlines(ftos50)
    linestos100 = readlines(ftos100)
    linestos150 = readlines(ftos150)
    linestos200 = readlines(ftos200) 
    
    mov_av = 1
    poly_order = 12

    xtos50 = []
    ytos50 = []
    
    for line in linestos50
        tokens = split(line)
        push!(xtos50,parse(Float64,tokens[1]))
        push!(ytos50,parse(Float64,tokens[2]))
    end

    Xtos50 = movingaverage(xtos50, mov_av)
    Ytos50 = movingaverage(ytos50, mov_av)
    
    ftos50 = poly(Xtos50, Ytos50, poly_order)
    
    plot(Xtos50, ftos50, label="5nm", xlab="r(Å)", ylab="ρ(r)", grid=false, framestyle=:box)

    xtos100 = []
    ytos100 = []
    
    for line in linestos100
        tokens = split(line)
        push!(xtos100,parse(Float64,tokens[1]))
        push!(ytos100,parse(Float64,tokens[2]))
    end

    Xtos100 = movingaverage(xtos100, mov_av)
    Ytos100 = movingaverage(ytos100, mov_av)
    
    ftos100 = poly(Xtos100, Ytos100, poly_order)

    plot!(Xtos100, ftos100, label="10nm", xlab="r(Å)", ylab="ρ(r)", grid=false)
    

    xtos150 = []
    ytos150 = []
    
    for line in linestos150
        tokens = split(line)
        push!(xtos150,parse(Float64,tokens[1]))
        push!(ytos150,parse(Float64,tokens[2]))
    end

    Xtos150 = movingaverage(xtos150, mov_av)
    Ytos150 = movingaverage(ytos150, mov_av)
    
    ftos150 = poly(Xtos150, Ytos150, poly_order)

    plot!(Xtos150, ftos150, label="15nm", xlab="r(Å)", ylab="ρ(r)", grid=false)


    xtos200 = []
    ytos200 = []
    
    for line in linestos200
        tokens = split(line)
        push!(xtos200,parse(Float64,tokens[1]))
        push!(ytos200,parse(Float64,tokens[2]))
    end

    Xtos200 = movingaverage(xtos200, mov_av)
    Ytos200 = movingaverage(ytos200, mov_av)
    
    ftos200 = poly(Xtos200, Ytos200, poly_order)

    plot!(Xtos200, ftos200, label="20nm", xlab="r(Å)", ylab="ρ(r)", grid=false)

    savefig("rdf_tos.png")

end

function plot_rdf_pss() 
    
    ftos50 = open("pedotpssrho-50.dat", "r")
    ftos100 = open("pedotpssrho-100.dat", "r")
    ftos150 = open("pedotpssrho-150.dat", "r")
    ftos200 = open("pedotpssrho-200.dat", "r") 

    linestos50 = readlines(ftos50)
    linestos100 = readlines(ftos100)
    linestos150 = readlines(ftos150)
    linestos200 = readlines(ftos200) 
    
    mov_av = 1
    poly_order = 12

    xtos50 = []
    ytos50 = []
    
    for line in linestos50
        tokens = split(line)
        push!(xtos50,parse(Float64,tokens[1]))
        push!(ytos50,parse(Float64,tokens[2]))
    end

    Xtos50 = movingaverage(xtos50, mov_av)
    Ytos50 = movingaverage(ytos50, mov_av)
    
    ftos50 = poly(Xtos50, Ytos50, poly_order)
    
    plot(Xtos50, ftos50, label="5nm", xlab="r(Å)", ylab="ρ(r)", grid=false, framestyle=:box)

    xtos100 = []
    ytos100 = []
    
    for line in linestos100
        tokens = split(line)
        push!(xtos100,parse(Float64,tokens[1]))
        push!(ytos100,parse(Float64,tokens[2]))
    end

    Xtos100 = movingaverage(xtos100, mov_av)
    Ytos100 = movingaverage(ytos100, mov_av)
    
    ftos100 = poly(Xtos100, Ytos100, poly_order)

    plot!(Xtos100, ftos100, label="10nm", xlab="r(Å)", ylab="ρ(r)", grid=false)
    

    xtos150 = []
    ytos150 = []
    
    for line in linestos150
        tokens = split(line)
        push!(xtos150,parse(Float64,tokens[1]))
        push!(ytos150,parse(Float64,tokens[2]))
    end

    Xtos150 = movingaverage(xtos150, mov_av)
    Ytos150 = movingaverage(ytos150, mov_av)
    
    ftos150 = poly(Xtos150, Ytos150, poly_order)

    plot!(Xtos150, ftos150, label="15nm", xlab="r(Å)", ylab="ρ(r)", grid=false)


    xtos200 = []
    ytos200 = []
    
    for line in linestos200
        tokens = split(line)
        push!(xtos200,parse(Float64,tokens[1]))
        push!(ytos200,parse(Float64,tokens[2]))
    end

    Xtos200 = movingaverage(xtos200, mov_av)
    Ytos200 = movingaverage(ytos200, mov_av)
    
    ftos200 = poly(Xtos200, Ytos200, poly_order)

    plot!(Xtos200, ftos200, label="20nm", xlab="r(Å)", ylab="ρ(r)", grid=false)

    savefig("rdf_pss.png")
end


plot_rdf_tos()
plot_rdf_pss()
