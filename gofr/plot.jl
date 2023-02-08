using Plots

function plt()
    f = open("gofr-50-tos.dat", "r")
    lines = readlines(f)
    
    x = []
    y = []

    for line in lines
        tokens = split(line)
        push!(x, parse(Float64, tokens[1]))
        push!(y, parse(Float64, tokens[2]))
    end

    plot(x, y)
    savefig("gofr-tos-50.png")

end


plt()
