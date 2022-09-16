#=

Code to prepare a slab of AAO from a supercell for simulations

MolReader
by Pranay Venkatesh

=#


struct Atom
    type::String
    x::Float64
    y::Float64
    z::Float64

end


function slab()

    thickness = 10
    width = 100
    
    f1 = open("supercell_shifted.xyz", "r")
    f2 = open("aao-slab.xyz", "w")

    lines = readlines(f1)

    natoms = parse(Int64, lines[1])
    deleteat!(lines, 1)
    deleteat!(lines, 1)

    atoms = []

    for line in lines
        
        tokens = split(line)
        type = tokens[1]
        x = parse(Float64, tokens[2])
        y = parse(Float64, tokens[3])
        z = parse(Float64, tokens[4])

        # Slab condition (z) : -t/2 < z < t/2
        
        # Slab condition (x, y) : -|w|/2 < x < |w|/2

        if (z >= -thickness/2 && z <= thickness/2)
            if (x >= -width/2 && x <= width/2)
                if (y >= -width/2 && y <= width/2)
                    push!(atoms, Atom(type, (x+width/2), (y+width/2), (z-10)))
                end
            end
        end
    
        
    end

    close(f1)

    nslab = length(atoms)
    
    write(f2, "$nslab \n \n")
    for atom in atoms
        
        t = atom.type
        x = atom.x
        y = atom.y
        z = atom.z
        

        write(f2, "$t \t $x \t $y \t $z \n")


    end

    close(f2)

    

end

slab()


