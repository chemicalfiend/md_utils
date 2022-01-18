#================


Combining the substrate, cylinder and polymers into a single file



==============#



fi = open("system.data", "r")
f1 = open("Au.xyz", "r")
f2 = open("cylinder.xyz", "r")

fo = open("comb.data", "o")



dataLines = readlines(fi)
auLines = readlines(f1)
cylLines = readlines(f2)


lineCount = 0


# LAMMPS Header

numPolyAtoms = parse(Int64, split(dataLines[3])[1])
numBonds = parse(Int64, split(dataLines[4])[1])
numAngles = parse(Int64, split(dataLines[5])[1])
numDihedrals = parse(Int64, split(dataLines[6])[1])
numImpropers = parse(Int64, split(dataLines[7])[1])


write(fo, "LAMMPS Description \n\n")

lineCount = lineCount + 1 


numAuAtoms = parse(Int64, auLines[1])
numCylAtoms = parse(Int64, cylLines[1])


numAtoms = numPolyAtoms + numAuAtoms + numCylAtoms

write(fo, "\t $numAtoms atoms \n")

for i in 4:8
	
	write(fo, dataLines[i])
	write(fo, " \n")

end


numPolyAtomTypes = parse(Int64, split(dataLines[9])[1])

numAtomTypes = numPolyAtomTypes + 3

write(fo, "\t $numAtomTypes atom types \n")


lineCount = 10

for i in 10:(21 + numPolyAtomTypes)
	
	write(fo, dataLines[i])
	write(fo, " \n")


end

lineCount = 21 + numPolyAtoms

na1 = numPolyAtomTypes + 1
na2 = numPolyAtomTypes + 2
na3 = numPolyAtomTypes + 3


write(fo, "$na1 196.97 # Au\n")
write(fo, "$na2 26.98  # Al\n")
write(fo, "$na3 16.00  # oal\n")


write(fo, "\n")

write(fo, "Atoms # full \n\n")

lineCount = lineCount + 4

atomCount = 0

for i in 1:numPolyAtoms
	atomCount = atomCount + 1
	lineCount = lineCount + 1
	write(fo, dataLines[lineCount])
	write(fo, " \n")
end

molCount = parse(Int64, split(dataLines[lineCount])[2]) + 1

for i in 2:(numAuAtoms+1)
	atomCount + 1

	tokens = split(auLines[i])

	x = tokens[2]
	y = tokens[3]
	z = tokens[4]

	write("$atomCount $molCount $na1 0.000000 $x $y $z \n")

end

molCount = molCount + 1

for i in 2:(numCylAtoms+1)
	atomCount = atomCount+1

	tokens = split(cylLines[i])
	
	t = tokens[1]
	x = tokens[2]
	y = tokens[3]
	z = tokens[4]
	
	typ = na3
	c = -2.000000
	if t == "Al"
		typ = na2
		c = 3.000000
	end

	write("$atomCount $molCount $typ $c $x $y $z")

end


for i in (lineCount+1):(lineCount + numBonds + numAngles + numDihedrals
		+ numImpropers + 10)
	
	write(fo, dataLines[i])
	write(fo, " \n")	

end 





