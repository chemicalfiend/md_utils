#=

Code to convert the last frame of a LAMMPS trajectory file toxyz file

=#


function trjtoxyz()
    
    fi = open("last_poly.lammpstrj", "r")
    fo = open("last.xyz", "w")

    lines = readlines(f1)
    numAtoms = parse(Int64, lines[4])
    lineCount = 10
    
    id = []
    for i in 1:n
        
        push!(id,)

    end

end






