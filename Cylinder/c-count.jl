f1 = open("cyl-modified.xyz")

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

println("Total Charge : $q")

end
