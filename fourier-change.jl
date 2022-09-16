

function f_change(fname)

    f = open(fname, "r")
    fo = open("comb-modified.in.settings", "w")
    lines = readlines(f)
    
    for i in 1:6243
        write(fo, lines[i])
        write(fo, " \n")
    end

    for i in 6244:6896
        
        tokens = split(lines[i])
        a = tokens[1]*" "*tokens[2]*" "*tokens[3]
        b = trunc(Int, parse(Float64, tokens[4]))
        c = a*" $b "

        for j in 5:length(tokens)
            c = c*" "*tokens[j]
        end

        write(fo, c)
        write(fo, " \n")

    end 
    
    for i in 6897:6934
        write(fo, lines[i])
        write(fo, " \n")
    end
    
    


end


f_change("comb.in.settings")



