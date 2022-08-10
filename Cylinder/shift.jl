#=

Program to shift the atoms to an appropriate origin.


=#

struct Atom
	type::String
	x::Float64
	y::Float64
	z::Float64
end

fi = open("supercell.xyz", "r")
lines = readlines(fi)
close(fi)


atoms = []

natoms = parse(Int64, lines[1])

deleteat!(lines, 1)
deleteat!(lines, 1)

for line in lines
	
	tokens = split(line)

	t = tokens[1]
	x = parse(Float64, tokens[2])
	y = parse(Float64, tokens[3])
	z = parse(Float64, tokens[4])

	push!(atoms, Atom(t, x, y, z))

end

xmin = atoms[1].x
xmax = atoms[1].x

ymin = atoms[1].y
ymax = atoms[1].y

zmin = atoms[1].z
zmax = atoms[1].z


for atom in atoms
	
	if (atom.x < xmin)
		global xmin = atom.x
	end

	if (atom.y < ymin)
		global ymin = atom.y
	end

	if (atom.z < zmin)
		global zmin = atom.z
	end

	if (atom.x > xmax)
		global xmax = atom.x
	end

	if (atom.y > ymax)
		global ymax = atom.y
	end

	if (atom.z > zmax)
		global zmax = atom.z
	end
	
end

originx = (xmin+xmax)/2
originy = (ymin+ymax)/2
originz = (zmin+zmax)/2


shifted_atoms = []

for atom in atoms
	
	push!(shifted_atoms, Atom(atom.type, atom.x - originx, atom.y - originy, atom.z - originz))

end


fo = open("supercell_shifted.xyz", "w")

write(fo, "$natoms \n\n")

for atom in shifted_atoms

	t = atom.type
	x = atom.x
	y = atom.y
	z = atom.z

	write(fo, "$t \t $x \t $y \t $z \n")

end

close(fo)
