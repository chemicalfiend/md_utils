using Plots

function plot_rdf()
    
    x = zeros(1901)
    y = zeros(1901)

    for i in 1:9
        
        f = "ring" * "$i.xyz.dat"
        f1 = open(f, "r")
        lines = readlines(f1)
        for j in 1:1901
            tokens = split(lines[j])
            x[j] += parse(Float64, tokens[1])
            y[j] += parse(Float64, tokens[2])
        end

    end

    x = x./10
    y = y./10

    plot!(x, y, xlab="r(Å)", ylab="ρ(r)", grid=false, framestyle=:box)
    savefig("rdf.png")
    
end


plot_rdf()
