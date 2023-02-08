using Plots


function xrdmax()

    f1 = open("all-50.xrd", "r")
    f2 = open("all-100.xrd", "r")
    f3 = open("all-150.xrd", "r")
    f4 = open("all-200.xrd", "r")

    lines1 = readlines(f1)
    lines2 = readlines(f2)
    lines3 = readlines(f3)
    lines4 = readlines(f4)

    max50 = 0
    intensity50 = 0
    max100 = 0
    intensity100 = 0
    max150 = 0
    intensity150 = 0
    max200 = 0
    intensity200 = 0

    
    for line in lines1
        tokens = split(line)
        val = 4*π*sin(parse(Float64, tokens[2]) * π/360)/1.541838
        intensity = parse(Float64, tokens[4])

        if (intensity > intensity50)
            max50 = val
            intensity50 = intensity
        end
    end

    
    for line in lines2
        tokens = split(line)
        val = 4*π*sin(parse(Float64, tokens[2]) * π/360)/1.541838
        intensity = parse(Float64, tokens[4])

        if (intensity > intensity100)
            max100 = val
            intensity100 = intensity
        end
    end

    
    for line in lines3
        tokens = split(line) 
        val = 4*π*sin(parse(Float64, tokens[2]) * π/360)/1.541838
        intensity = parse(Float64, tokens[4])

        if (intensity > intensity150)
            max150 = val
            intensity150 = intensity
        end
    end

    
    for line in lines4
        tokens = split(line) 
        val = 4*π*sin(parse(Float64, tokens[2]) * π/360)/1.541838
        intensity = parse(Float64, tokens[4])

        if (intensity > intensity200)
            max200 = val
            intensity200 = intensity
        end
    end
    
    X = [50, 100, 150, 200]
    Y = [max50, max100, max150, max200] 
    print(Y)
    scatter(X, Y, grid=false, framestyle=:box)
    savefig("peakvdia.png")
end

xrdmax()


