#====

MolReader.jl

c-check.jl => utility to neutralise the charges on the cylinder


====#


f1 = open("cylinder.xyz")
f2 = open("cyl-modified.xyz", "w")

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


radius = 25
thickness = 5 
height = 200


for j in 1:numAddAtoms
    
    xlay = 0
    ylay = 0
    zlay = 0
        
    if (j <= numAddAtoms/4)
        xlay = radius + thickness
        ylay = radius + thickness + 1.5
        zlay = (height * j/((numAddAtoms/4))) - 100
    
    elseif (j > numAddAtoms/4 && j <= numAddAtoms/2)
        xlay = -(radius + thickness)
        ylay = radius + thickness + 1.5
        zlay = (height * ((j - (numAddAtoms/4))/(numAddAtoms/4))) - 100

    elseif (j > numAddAtoms/2 && j <= numAddAtoms*(3/4))
        xlay = -(radius + thickness)
        ylay = -(radius + thickness + 1.5)
        zlay = (height * (j - (numAddAtoms/2))/(numAddAtoms/4)) - 100
    else
        xlay = radius + thickness
        ylay = -(radius + thickness + 1.5)
        zlay = (height * ((j - (numAddAtoms*(3/4)))/(numAddAtoms/4))) - 100
    end
    
    write(f2, "$atomType $xlay $ylay $zlay \n")
    

end

for j in 1:numCounter
    
    xlay = 0
    ylay = 0
    zlay = 0

    if (j < numCounter / 2)
        xlay = radius + thickness + 1.5
        #ylay = radius + thickness
        zlay = height * j/(numCounter) - 100

    else
        xlay = -(radius + thickness + 1.5)
        #ylay = -(radius + thickness)
        zlay = height * (j - (numCounter/2))/(numCounter) - 100
    end
    
    write(f2, "$counterType $xlay $ylay $zlay \n")


end

close(f1)
close(f2)

end
