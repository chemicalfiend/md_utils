#====

MolReader.jl

c-check.jl => utility to neutralise the charges on AAO slab


====#


f1 = open("aao-slab.xyz")
f2 = open("aao-slab-modified.xyz", "w")

xyz = readlines(f1)

numAtoms = parse(Int64, xyz[1])


let

q = 0

for i in 3:(numAtoms+2)
	tokens = split(xyz[i])
	if (tokens[1] == "Al")
		q += 3
	
	else
	    q -=2
	end 
end


numAddAtoms = 0
atomType = "Al"
counterType = "O"
numCounter = 0


if (q > 0)
    
    for k in 1:3
        if ((q + 3*k) % 2) == 0
            numCounter = k
            q = q + 3*k
            break
        end
    end

    
    atomType = "O"
    counterType = "Al"
    numAddAtoms = q / 2

else

    for k in 1:3
        if((q - 2*k)%3) == 0
            numCounter = k
            q = q - 2*k
            break
        end
    end

    atomType = "Al"
    counterType = "O"
    numAddAtoms = -1* q / 3
  
end
 
println("Excess Charge : $q")
println("Adding $numAddAtoms of type $atomType")



numTotalAtoms = trunc(Int, numAddAtoms + numCounter + numAtoms)

write(f2, "$numTotalAtoms \n\n")

for i in 3:(numAtoms+2)
    write(f2, xyz[i])
    write(f2, " \n")
end

thickness = 10
width = 100


for j in 1:numAddAtoms
    
    xlay = 0
    ylay = 0
    zlay = 0
    
    fac = numAddAtoms/2
    if (j <= numAddAtoms/2)
        xlay = (width*(j/fac))
        ylay = 0.0
        zlay = -(thickness/2) - 1.5 - 10
    else    
        xlay = (width*2) -((width)*(j/fac))
        ylay = width
        zlay = -(thickness/2) - 1.5 - 10
    end
    
    write(f2, "$atomType $xlay $ylay $zlay \n")
    

end

for j in 1:numCounter
    xlay = 0.0
    ylay = -width*(j/(numCounter))
    zlay = -(thickness/2) - 1.5 - 10
    
    write(f2, "$counterType $xlay $ylay $zlay \n")

end

close(f1)
close(f2)

end
