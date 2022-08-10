#=

Program to generate a colourmap GIXS pattern

Input => xyz data of the final frame of the trajectory.

Output => GIXS scattering plots.


=#


using LinearAlgebra
using Plots, FFTW

using Images

# struct Atom
#     x::Float64
#     y::Float64
#     z::Float64
# end


function pbc_2d(x, N)
    for i in x
        i -= round.(i) .- 0.5
        i *= N
        i = [i[1]%N, i[2]%N]
        #i = i .% N
    end

    m = []
    for i in x
        push!(m, abs.(round.(i)))
    end
    return m
end

function bin(yz, n)
    u = unique(yz)
    counts = [(count(x->x==i, yz)) for i in u]
    im = zeros(n, n)

    for (v, c) in zip(u, counts)
        im[Int64(v[1])+1, Int64(v[2])+1] = c
    end

    return im

end

function diffract(xyz, grid_size)
    n = grid_size
    rot = I
    yz = []
    for x in xyz
        push!(yz, [x[2],x[3]])
    end

    yz = pbc_2d(yz, n)

    im = bin(yz, n)
    F = fftshift(fft(Float64.(Gray.(im))))
    #print(F)

    heatmap(log.(abs.(F.*F)).+1, c = :jet)

end

atoms = []

f1 = open("final.xyz", "r")
lines = readlines(f1)
close(f1)

natoms = parse(Int64, lines[1])

# loading atoms from the xyz file.

for i in 3:natoms
    tokens = split(lines[i])
    x = parse(Float64, tokens[2])
    y = parse(Float64, tokens[3])
    z = parse(Float64, tokens[4])

    # at = Atom(x, y, z)
    #
    # push!(atoms, at)
    push!(atoms, [x,y,z])
end

lx = 0
ly = 0
lz = 0 ## Todo : find a way to set box lengths.

# Co-ordinates of the box end points.

box = [[lx, 0.0, 0.0], [0.0, ly, 0.0], [0.0, 0.0, lz]]

diffract(atoms, 512)
