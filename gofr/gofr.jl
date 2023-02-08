#=

Script to compute g(r) for a lammps trajectory file

=#


function gofr()
    nc = 80
    atoms = 158

    natoms = nc*atoms 

    f0 = open("last-100.lammpstrj", "r")
    lines = readlines(f0)
    npart  = parse(Int64, lines[4])
    x = []
    y = []
    z = []
    push!(x, parse(Float64, split(lines[6])[1]))
    push!(x, parse(Float64, split(lines[6])[2]))
    push!(y, parse(Float64, split(lines[7])[1]))
    push!(y, parse(Float64, split(lines[7])[2]))
    push!(z, parse(Float64, split(lines[8])[1]))
    push!(z, parse(Float64, split(lines[8])[2]))

    for i in 1:9
        popfirst!(lines)
    end
    bx = 2*x[2]
    by = 2*y[2]
    bz = 2*z[2]
    boxvol = bx*by*bz
    rhobulk = npart/boxvol
    close(f0)

    cnt = 0.0
    bin = 0.5
    rmax = x[2]
    nbin = trunc(Int, round(rmax/bin))
    nct = []
    ncts = []
    nctp = []
    for i in 1:nbin
        push!(nct, 0.0)
        push!(ncts, 0.0)
        push!(nctp, 0.0)
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

        push!(binvol, (4.0/3.0)*π*(bhi[i]^3 - blo[i]^3))
    end
    
    resid = []
    rx = []
    ry = []
    rz = []
    for line in lines
        tokens = split(line)
        push!(resid, parse(Int64, tokens[2]))
        push!(rx, parse(Float64, tokens[4]))
        push!(ry, parse(Float64, tokens[5]))
        push!(rz, parse(Float64, tokens[6]))
    end

    # G(r) calc

    for i in 1:natoms
        for j in i+1:natoms
            if resid[i] != resid[j]
                rijx = rx[i] - rx[j]
                rijy = ry[i] - ry[j]
                rijz = rz[i] - rz[j]

                rijx = rijx - round(rijx/bx)*bx
                rijy = rijy - round(rijy/by)*by
                rijz = rijz - round(rijz/bz)*bz

                rij = sqrt(rijx^2 + rijy^2 + rijz^2)

                for jj in 1:nbin
                    if(rij >= blo[jj] && rij < bhi[jj])
                        nct[jj] = nct[jj] + 1.0
                    end
                end

            end
        end
    end
    
    f2 = open("gofr-100-tos.dat", "w")
    for i in 1:nbin
        nct[i] = nct[i]/(natoms)
        a1 = i*bin
        a2 = nct[i]
        write(f2, "$a1 $a2 \n")
    end
    
end


gofr()
