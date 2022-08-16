#=========================================================================================

MolReader.jl

By Pranay Venkatesh


lt.jl => Prepares a moltemplate .lt file from an xyz file, ANTECHAMBER AC file,
and a file containing charges 


Here, lt.jl uses two sets of input files => one controls the charged polymers
(in my use case, PEDOT) the other is for the counter ion (TOS).


=========================================================================================#

function write_lt()

	fo = open("final.lt", "w")
 	
	
	f1 = open("cyl-packed.xyz", "r")


	f2 = open("pedot-ac.AC", "r")
	f3 = open("pedot-charges.txt", "r")
	
	f4 = open("tos-ac.AC", "r")
	f5 = open("tos-charges.txt", "r")

	xyzLines = readlines(f1)


	pedotacLines = readlines(f2)
	pedotchargeLines = readlines(f3)
	
	tosacLines = readlines(f4)
	toschargeLines = readlines(f5)

	numPedotAtoms = 158
	numPedotMolecules = 50 
	numPedotBonds = 181 
	numTosAtoms = 18
	numTosMolecules = 200
	numTosBonds = 18

	pedotid = [] 
	pedotcharges = []

	tosid = []
	toscharges = []


	# Reading PEDOT AC and charge files.

	for i in 3:numPedotAtoms+2
		line = split(pedotacLines[i])
		push!(pedotid, last(line))
	end

	for i in 1:numPedotAtoms
		tokens = split(pedotchargeLines[i])
		push!(pedotcharges, tokens[2])
	end

	# Reading TOS AC and charge files.

	for i in 3:numTosAtoms+2
		line = split(tosacLines[i])
		push!(tosid, last(line))
	end

	for i in 1:numTosAtoms
		tokens = split(toschargeLines[i])
		push!(toscharges, tokens[2])
	end


	 

	write(fo, "import \"gaff.lt\" \n\n")
	write(fo, "Pndi inherits GAFF { \n")
	write(fo, "# atomID \t molID \t atomType \t charge \t X \t Y \t Z \n")
	write(fo, "write('Data Atoms') { \n")
	

	# Writing all PEDOT atoms.

	pedotCount = 0
	
	for i in 1:numPedotMolecules
		for j in 1:numPedotAtoms
			pedotCount = pedotCount+1

			tokens = split(xyzLines[pedotCount+2])
			x = tokens[2]
			y = tokens[3]
			z = tokens[4]
			k = pedotid[j]
			q = pedotcharges[j]

			write(fo, "\$atom:$pedotCount \$mol:$i @atom:$k $q $x $y $z \n")
			
		end
	end


	# Writing all TOS atoms.
	
	tosCount = pedotCount

	for i in 1:numTosMolecules
		for j in 1: numTosAtoms

			tosCount = tosCount + 1

			tokens = split(xyzLines[tosCount+2])

			x = tokens[2]
			y = tokens[3]
			z = tokens[4]
			k = tosid[j]
			q = toscharges[j]
			
			l = i + numPedotMolecules

			write(fo, "\$atom:$tosCount \$mol:$l @atom:$k $q $x $y $z \n")

		end
	end



	write(fo, "} \n")

	
	

	# PEDOT bonds
	
	pedotiatom = []
	pedotjatom = []
	pedotkount = 0

	for k in numPedotAtoms+3:numPedotAtoms+numPedotBonds+2
		tokens = split(pedotacLines[k])
		print(tokens[3])
		print(" ")
		print(tokens[4])
		print("\n")
		push!(pedotiatom, parse(Int64, tokens[3]))
		push!(pedotjatom, parse(Int64, tokens[4]))

	end
	
	write(fo, "write('Data Bond List') { \n")

	for j in 1:numPedotMolecules
		for i in 1:numPedotBonds
			pedotkount = pedotkount + 1
			m = pedotiatom[i]
			n = pedotjatom[i]
			write(fo, "\$bond:$pedotkount \$atom:$m \$atom:$n \n")

			pedotiatom[i] = pedotiatom[i] + numPedotAtoms
			pedotjatom[i] = pedotjatom[i] + numPedotAtoms

		end
	end


	# TOS bonds
	

	tosiatom = []
	tosjatom = []
	toskount = pedotkount
	
	
	for k in numTosAtoms+3:numTosAtoms+numTosBonds+2
		tokens = split(tosacLines[k])
		print(tokens[3])
		print(" ")
		print(tokens[4])
		print("\n")
		w = parse(Int64, tokens[3]) + (numPedotAtoms*numPedotMolecules)
		v = parse(Int64, tokens[4]) + (numPedotAtoms*numPedotMolecules)
		push!(tosiatom, w)
		push!(tosjatom, v)

	end



	for j in 1:numTosMolecules
		for i in 1:numTosBonds
			toskount = toskount + 1
			m = tosiatom[i]
			n = tosjatom[i]

			write(fo, "\$bond:$toskount \$atom:$m \$atom:$n \n")

			tosiatom[i] = tosiatom[i] + numTosAtoms
			tosjatom[i] = tosjatom[i] + numTosAtoms
		end
	end

	write(fo, "} \n")
	write(fo, "} \n")
	
	close(f1)
	close(f2)
	close(f3)
	close(f4)
	close(f5)
	close(fo)

end



write_lt()
