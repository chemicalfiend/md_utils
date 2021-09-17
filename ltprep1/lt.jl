#=========================================================================================

MolReader.jl

By Pranay Venkatesh


lt.jl => Prepares a moltemplate .lt file from an xyz file, ANTECHAMBER AC file,
and a file containing charges 


=========================================================================================#

function write_lt(atoms, fname, cfile, acfile, natom, nmols, nb)

	fo = open(fname, "w")
 	
	
	f1 = open(atoms, "r")
	f2 = open(acfile, "r")
	f3 = open(cfile, "r")
	

	xyzLines = readlines(f1)
	acLines = readlines(f2)
	chargeLines = readlines(f3)
	

	id = [] 
	charges = []

	for i in 3:natom+2
		line = split(acLines[i])
		push!(id, last(line))
	end

	for i in 1:natom
		tokens = split(chargeLines[i])
		push!(charges, tokens[2])
	end

	


	write(fo, "import \"gaff.lt\" \n\n")
	write(fo, "Pndi inherits GAFF { \n")
	write(fo, "# atomID \t molID \t atomType \t charge \t X \t Y \t Z \n")
	write(fo, "write('Data Atoms') { \n")
	
	count = 0
	


	for i in 1:nmols
		for j in 1:natom
			count = count+1

			tokens = split(xyzLines[count+2])
			x = tokens[2]
			y = tokens[3]
			z = tokens[4]
			k = id[j]
			q = charges[j]

			write(fo, "\$atom:$count \$mol:$i @atom:$k $q $x $y $z \n")
			
		end
	end
	
	write(fo, "} \n")

	iatom = []
	jatom = []
	kount = 0

	for k in natom+3:natom+nb+2
		tokens = split(acLines[k])
		print(tokens[3])
		print(" ")
		print(tokens[4])
		print("\n")
		push!(iatom, parse(Int64, tokens[3]))
		push!(jatom, parse(Int64, tokens[4]))

	end
	
	write(fo, "write('Data Bond List') { \n")

	for j in 1:nmols
		for i in 1:nb
			kount = kount + 1
			m = iatom[i]
			n = jatom[i]
			write(fo, "\$bond:$kount \$atom:$m \$atom:$n \n")

			iatom[i] = iatom[i] + natom
			jatom[i] = jatom[i] + natom

		end
	end

	write(fo, "} \n")
	write(fo, "} \n")
	
	close(f1)
	close(f2)
	close(f3)
	close(fo)

end


