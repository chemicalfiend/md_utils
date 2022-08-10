function movingaverage(arr, n)
    mov = []
    for i in 1:(length(enumerate(arr))-n)
        sum = 0
        for j in 1:n
            sum += arr[i+j-1]
        end
        push!(mov, sum/n)
    end
    return mov
end
