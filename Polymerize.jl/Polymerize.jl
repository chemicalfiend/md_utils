#=====================================================================================

Polymerize.jl


Program that polymerises a given .xyz monomer file to produce a polymer .xyz file.


Trick used : Find the Rubidium atom and then shift across.

======================================================================================#


include("/home/pranay/MolReader.jl/molreader.jl")


function distance(at1, at2)
	
	return sqrt((at1.x - at2.x)^2 + (at1.y - at2.y)^2 + (at1.z - at2.z)^2)

end


function direction(at1, at2)

	return [(at2.x - at1.x), (at2.y - at1.y), (at2.z - at1.z)]./ distance(at1, at2)

end

function clone(atoms, clone_atom = "Rb", d=0.01)
	
	count = 0
	term1 = Atom(x = 0.0, y = 0.0, z = 0.0, type = clone_atom)
	term2 = Atom(x = 0.0, y = 0.0, z = 0.0, type = clone_atom)


	for atom in atoms

		if atom.type == clone_atom
			if count == 0
				term1.x = atom.x
				term1.y = atom.y
				term1.z = atom.z

			elseif count == 1
				term2.x = atom.x
				term2.y = atom.y
				term2.z = atom.z
			end

		end
	end

	pr = string(term1.x, " and", term2.x)
	pr2 = string(term1.y, " and", term2.y)	
	
	println(pr)
	println(pr2)

	dx = term2.x - term1.x
	dy = term2.y - term1.y
	dz = term2.z - term1.z
	

	newset = []

	for atom in atoms	

		cloned = Atom(x = atom.x+dx+d, y = atom.y+dy+d, z = atom.z+dz+d, type = atom.type) 
		
		push!(newset, cloned)

	end

	return newset

end

function polymerize(atoms, num::Int64, clone_atom = "Rb", d=0.01)

	polymer = []
	
	set = atoms

	for i in 1:num
		set = clone(set)
		for atom in set
			push!(polymer, atom)
		end
	end
	
	i = 1
	for atom in polymer
		if atom.type == clone_atom
			deleteat!(polymer, i)
		end
		i += 1
	end

	write_xyz(polymer, "polymer.xyz")

end


atoms = read_xyz("monomer.xyz")
polymerize(atoms, 10)

