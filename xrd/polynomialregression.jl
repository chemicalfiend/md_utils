using LinearAlgebra

function fit(X, Y, n)
    A = zeros(length(X), n)


    for (i,x) in enumerate(X)
        for j in 0:(n-1)
            A[i, j+1] = x^j
        end
    end
    
#    print(A)

    β = inv(transpose(A) * A) * transpose(A) * Y

    return β
    
end


function poly(X, Y, n)
    f = []
    β = fit(X, Y, n)

    for x in X
        sum = 0
        for j in 0:(n-1)
            sum += β[j+1]*(x^j)
        end
        push!(f, sum)
    end
    return f
end 
