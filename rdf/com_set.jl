
#= 

Script to replace a bunch of rings by their center of masses

=#


function com_set()
    
    f1 = open("ATOMTYPE.INF", "r")
    f2 = open("poly_eq.lammpstrj", "r")
    
    rng = readlines(f1)
    lines = readlines(f2)
    
    numRings = 12 
    ringAtoms = 5
    
    ring = []
    for i in 1:numRings
        push!(ring, [])
        for j in 1:ringAtoms
            push!(ring[i], 0)
        end
    end

    count = 0
    for i in 1:numRings
        count += 1
        for j in 1:ringAtoms
            tokens = split(rng[count])
            ring[i][j] = parse(Int64, tokens[3])
            count += 1
        end
    end
    
    print(ring)

    numAtoms = parse(Int64, lines[4])

    xstart = parse(Float64, split(lines[6])[1])
    xfinal = parse(Float64, split(lines[6])[2])
    ystart = parse(Float64, split(lines[7])[1])
    yfinal = parse(Float64, split(lines[7])[2])
    zstart = parse(Float64, split(lines[8])[1])
    zfinal = parse(Float64, split(lines[8])[2])

    numPedot = 50
    numPedotAtoms = 158
    numxyz = numPedot*numRings

    lnCount = 0
    
    numTimeSteps = 101

    for k in 1:numTimeSteps
        lnCount += 9
        xyz = open("ring_$k.xyz", "w")
        write(xyz, "$numxyz \n\n")
        
        th = 0
        ncc = 0
        for j in 1:numPedot    
            c = zeros(numRings)
            cx = zeros(numRings)
            cy = zeros(numRings)
            cz = zeros(numRings)

            for i in 1:numPedotAtoms 
                lnCount += 1
                tokens = split(lines[lnCount])
                println(lnCount) 
                id = parse(Int64, tokens[1])
                id = id - ncc
                rx = parse(Float64, tokens[4])
                ry = parse(Float64, tokens[5])
                rz = parse(Float64, tokens[6])
                print("$id \n") 
                for k in 1:numRings
                    th = th+1

                    for k2 in 1:ringAtoms
                        if id == ring[k][k2]
                            c[k] += 1
                            cx[k] += rx
                            cy[k] += ry
                            cz[k] += rz
                        end
                    end
                end

            end

            ncc = ncc + numPedotAtoms

            for k in 1:numRings
                cx[k] = cx[k]/c[k]
                cy[k] = cy[k]/c[k]
                cz[k] = cz[k]/c[k]
            
                x = cx[k]
                y = cy[k]
                z = cz[k]
                write(xyz, "1 $x \t $y \t $z \n")
            end

        end
        close(xyz)
    
    end
    close(f1)
    close(f2)

end


com_set()

