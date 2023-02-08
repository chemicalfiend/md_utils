#=

Script to identify voids in a cylindrical channel

=#


function regions()
    f = open("last.lammpstrj", "r")

    lines = readlines(f)
    
    numAtoms = parse(Int64, lines[4])
    
    length = 200
    numBins = 20

    binCounts = []
    
    for i in 1:numBins
        push!(binCounts, 0)
    end


    for count in 10:(numAtoms+9)
        tokens = split(lines[count])

        x = parse(Float64, tokens[4])
        y = parse(Float64, tokens[5])
        z = parse(Float64, tokens[6])

            

    end
    

end

regions()
