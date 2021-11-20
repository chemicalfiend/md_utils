file = open(joinpath(@__DIR__, "z.xyz"), "r")
f2 = open("final.xyz", "w")

lines = readlines(file)

close(file)

write(f2, string(lines[1], "\n"))
write(f2, string(lines[2], "\n"))


for i in 3:185502
    line = lines[i]

    words = split(line)
    k = parse(Int64, words[1])

    #println(k)

    if k >= 1 && k <= 18
        words[1] = " C"

    elseif k >= 19 && k <= 31
        words[1] = " H"

    elseif k >= 49 && k <= 52
        words[1] = " O"

    elseif k >= 64 && k <= 71
        words[1] = " S"

    end
    write(f2, string(words[1], "\t", words[2], "\t", words[3], "\t", words[4], "\n"))
end

close(f2)
