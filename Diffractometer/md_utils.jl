#=

Utility functions for molecular dynamics simulations

=#

using LinearAlgebra

function rot_mat(a, b)

# Finds a rotation matrix from A to B

    a1 = a/norm(a)
    b1 = b/norm(b)

    theta = acos(dot(a1,b1))

    if theta < 1e-6
        return I
    end

    x = cross(a1, b1)
    x = x/norm(x)

    A = [ [0,-x[2],x[1]], [x[2],0,-x[0]], [-x[1],x[0],0] ]

    R = I + sin(theta)*A + (1.0 - cos(theta))*dot(A,A)

    return R

end

function shift_pbc(positions, box)

    p = copy(positions)
    p = p + box/2.0
    image = copy(p)
    image[:] /= box

    image = Int64.(image)

    p[:] -= image[:]*box

    p[p[:, 0] < 0.0, 0] += box[0]
    p[p[:, 1] < 0.0, 1] += box[1]
    p[p[:, 2] < 0.0, 2] += box[2]
    p -= box/2.0
    return p, image

end

function pbc_2d(x, N)
    x -= round.(x) - 0.5
    x *= N
    x %= N
    return Int64.(x)
end
