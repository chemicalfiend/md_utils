#======


Script to compute the cylindrical radial density function of a system in xyz format

======#

using Plots


function rdf_set()
    
    nct_set = []
    binvol = []
    bin = 0.05
    numTimeStep = 101
    for k in 1:numTimeStep
        
        f1 = open("ring_$k.xyz", "r")
    
        xyz = readlines(f1)
    
        cnt = 0.0

        xmax = 0.0
        xmin = 0.0
        ymax = 0.0
        ymin = 0.0
        zmax = 0.0
        zmin = 0.0

        numAtoms = parse(Int64, xyz[1])
        for n in 1:numAtoms

            tokens = split(xyz[n+2])

            x = parse(Float64, tokens[2])
            y = parse(Float64, tokens[3])
            z = parse(Float64, tokens[4])
        
            if x > xmax
                xmax = x
            end
            if x < xmin
                xmin = x
            end
        
            if y > ymax
                ymax = y
            end
            if y < ymin
                ymin = y
            end

            if z > zmax
                zmax = z
            end

            if z < zmin
                zmin = z
            end
        end

        bx = xmax - xmin
        by = ymax - ymin
        bz = zmax - zmin
    
        nbin = round(Int, bx/bin)
        boxvol = bx*by*bz
    
        numAtoms = parse(Int64, xyz[1])
        rhobulk = numAtoms/boxvol
    
        len = 200
    
        nct = []

        for i in 1:nbin
            push!(nct, 0.0)
        end
    
        lo = 0.0
        hi = lo + bin
    
        blo = []
        bhi = []
        binvol = []

        for i in 1:nbin
            push!(blo, lo)
            push!(bhi, hi)
            lo = hi
            hi = lo + bin
            push!(binvol, len*π*(hi^2 - lo^2))
        end

        rx = []
        ry = []
        rz = []

        for n in 1:numAtoms

            tokens = split(xyz[n+2])

            x = parse(Float64, tokens[2])
            y = parse(Float64, tokens[3])
            z = parse(Float64, tokens[4])

        #r1 = x - round(x/bx)*bx
        #r2 = y - round(y/by)*by

            r1 = x
            r2 = y

            push!(rx, r1)
            push!(ry, r2)
            push!(rz, z)

            riz = sqrt(r1^2 + r2^2)

            for j in 1:nbin
                if(riz >= blo[j] && riz < bhi[j])
                    nct[j] = nct[j] + 1.0
                end
            end
        
        end

        push!(nct_set, nct)
    end
    
    # Averaging
    
    len = minimum(length.(nct_set))
    nct_av = zeros(len)

    for i in 1:len
        sum = 0
        for curve in nct_set
            sum += curve[i]
        end
        av = sum/numTimeStep
        nct_av[i] = av
    end

    # Plotting

    X = []
    Y = []
    for i in 1:len
        a1 = i*bin
        a2 = nct_av[i]/binvol[i]
        push!(X, a1)
        push!(Y, a2)
       
    end

    plot!(X, Y, xlab="r(Å)", ylab="ρ(r)", grid=false, framestyle=:box)
    savefig("rdf-com-set.png")
end

rdf_set()
