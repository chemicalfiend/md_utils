#=

Program to convert a large rectangular block into a cylinder

=#

radius = 25
thickness = 5
height = 200


struct Atom
	type::String
	x::Float64
	y::Float64
	z::Float64
end


fi = open("supercell_shifted.xyz", "r")

box = readlines(fi)

close(fi)

natoms = parse(Int64, box[1])

deleteat!(box, 1)
deleteat!(box, 1)

atoms = []

for line in box
	
	tokens = split(line)
	
	type = tokens[1]
	x = parse(Float64, tokens[2])
	y = parse(Float64, tokens[3])
	z = parse(Float64, tokens[4])
	
	# Cylinder condition (z) : -h/2 < z < h/2
	# Cylinder condition (x, y) : (R-t)^2 < x^2 + y^2 < R^2
	
	q = x^2 + y^2
	r2 = radius^2
	rt2 = (radius - thickness)^2

	if (z >= -height/2 && z <= height/2)
		if (q >= rt2 && q <= r2)
			push!(atoms, Atom(type, x, y, z))
		end
	end

end


fo = open("cylinder.xyz", "w")

ncyl = length(atoms)

write(fo, "$ncyl \n \n")

for atom in atoms
	
	t = atom.type
	x = atom.x
	y = atom.y
	z = atom.z


	write(fo, "$t \t $x \t $y \t $z \n")

end

close(fo)
