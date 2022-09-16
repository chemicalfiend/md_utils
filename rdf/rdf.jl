#=


Script to generate the radial density function plot for cylindrical system after reducing rings to center of mass.


=#


function rdf()
    
    numRings = 12
    ringAtoms = 5
    numPedot = 160
    numTos = 640

    f1 = open("ATOMTYPE.INF", "r")    
    lines = readlines(f1)
    xyz = open("com.xyz", "w")    
    lineCount = 3
    
    ring = zeros(numRings, ringAtoms)

    for i in 1:numRings
        lineCount += 1
        for j in 1:ringAtoms
            tokens = split(lines[lineCount])
            ring[i, j] = parse(Int64, tokens[3])
            lineCount += 1
        end
    end
    
    trj = open("last.lammpstrj", "r")
    trjLines = readlines(trj)

    tstep = parse(Int64, trjLines[2])
    numAtoms = parse(Int64, trjLines[4])
    
    xstart = parse(Float64, split(trjLines[6])[1])
    xfinal = parse(Float64, split(trjLines[6])[2])
    ystart = parse(Float64, split(trjLines[7])[1])
    yfinal = parse(Float64, split(trjLines[7])[2])
    zstart = parse(Float64, split(trjLines[8])[1])
    zfinal = parse(Float64, split(trjLines[8])[2])
    
    bx = 2*xfinal
    by = 2*yfinal
    bz = 2*zfinal

    boxvol = bx*by*bz
    rhobulk = numAtoms / boxvol

    cnt = 0
    bin = 0.5

    rmax = zfinal
    numBins = round(Int, rmax/bin)
    
    nct = []
    ncts = []
    nctp = []

    for i in 1:numBins
        push!(nct, 0.0)
        push!(ncts, 0.0)
        push!(nctp, 0.0)
    end


    lo = 0.0
    hi = lo + bin
    
    blo = zeros(numBins)
    bhi = zeros(numBins)
    binvol = zeros(numBins)
    for i in 1:numBins
        blo[i] = lo
        bhi[i] = hi

        lo = hi
        hi = lo + hi
        
        binvol[i] = (4.0/3.0)*π*(bhi[i]^3 - blo[i]^3)
    end

    trjLine = 10
    ncc = 0
    th = 0
    rid = 0
    particles = 0
    c = zeros(20)
    cx = zeros(20)
    cy = zeros(20)
    cz = zeros(20)

    typet = zeros(20)
    
    trjLineCount = 9
    for i in 1:numPedot
        trjLineCount += 1
        tokens = split(trjLines[trjLineCount])
        id = parse(Int64, tokens[1])
        id = id - ncc
        resid = parse(Int64, tokens[2])
        type = parse(Int64, tokens[3])
        rx = parse(Float64, tokens[4])
        ry = parse(Float64, tokens[5])
        rz = parse(Float64, tokens[6])
        
        for k in 1:numRings
            th = th + 1
            
            for k2 in 1:ringAtoms
                if id == ring[k, k2]
                    c[k] += 1
                    typet[k] = 1
                    cx[k] += rx
                    cy[k] += ry
                    cz[k] += rz
                end
            end
        end
    
    for k in 1:20
        cx[k] = cx[k]/c[k]
        cy[k] = cy[k]/c[k]
        cz[k] = cz[k]/c[k]

        x = cx[k]
        y = cy[k]
        z = cz[k]
        write(xyz, "$x \t $y \t $z \n")
    end

    c1x = zeros(20)
    c1y = zeros(20)
    c1z = zeros(20)
    resid1 = zeros(20)
    type1 = zeros(20)
    #=
    for k in 1:20
        particles += 1
        c1x[particles] = cx[k]
        c1y[particles] = cy[k]
        c1z[particles] = cz[k]

        resid1[particles] = resid
        type1[particles] = typet[k]
    end
    =#

    particles = 20

    ncc = ncc + numAtoms
    rid = rid + ringAtoms
    nct = zeros(numBins) 
    
    for i in 1:(particles-1)
        for j in (i+1):particles
            rijx = c1x[i] - c1x[j]
            rijy = c1y[i] - c1y[j]
            rijz = c1z[i] - c1z[j]

            rijx = rijx - bx*round(rijx/(2*xfinal)) 
            rijy = rijy - by*round(rijy/(2*yfinal)) 
            rijz = rijz - bz*round(rijz/(2*zfinal))

            rij = sqrt(rijx^2 + rijy^2 + rijz^2)

            for jj in 1:numBins
                if(rij >= blo[jj] && rij < bhi[jj])
                    nct[jj] = nct[jj] + 1.0
                end
            end
            
        end
    end
    end

    datFile = open("rho_backbone_pi.dat", "w")

    for i in 1:numBins
        nct[i] = nct[i]/particles
        a = i * bin
        b = nct[i]/binvol[i]
        write(datFile, "$a $b \n")
    end

    close(datFile)
    close(trj)
    close(xyz)
    close(f1)
end

rdf()


