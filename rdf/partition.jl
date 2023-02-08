


function partition()
    
    f = open("last10.lammpstrj", "r")

    lines = readlines(f)

    for i in 0:9
        name = "trj_$i.lammpstrj"
        fi = open(name, "w")
        j_start = 12649*i + 1
        j_end = j_start + 12649

        for j in 1:12649
            write(fi, lines[12649*i + j])
            write(fi, "\n")
        end

        close(fi)
    end
    close(f)

end

partition()
