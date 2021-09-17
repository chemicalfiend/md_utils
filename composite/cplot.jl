#============================================================================================

Program for compositing 2 XRD plots in substrate and bulk directions (obtained
from LAMMPS dump) to generate a single colour density plot.

By Pranay Venkatesh

===========================================================================================#


using Plots

f1 = open("xy.xrd")
f2 = open("z.xrd")

xylines = readlines(f1)
zlines = readlines(f2)

qxy = []
qz = []

Ixy = []
Iz = []

I = []

for i in 5:334
	
	push!(qxy, sin((pi/360)*parse(Float64, split(xylines[i])[2])))
	I1 =parse(Float64, split(xylines[i])[4])
	push!(Ixy, I1)
	push!(qz, sin((pi/360)*parse(Float64, split(zlines[i])[2])))

	I2 = parse(Float64, split(zlines[i])[4])
	push!(Iz, I2)
	
	push!(I, I1*I2) 

end



p1 = plot(qxy, Ixy, smooth=true)
p2 = plot(qz, Iz, smooth=true)

h = heatmap(qxy, qz, I, c = :jet1)

savefig(p1, "qxy.png")
savefig(p2, "qz.png")
savefig(h, "plot.png")
