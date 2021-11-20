#=

modifies a LAMMPS data file to add a substrate for conducting polymer simulations.

=#

f1 = open("system.data", "r")
f2 = open("Au.xyz", "r")
fo = open("comb.data", "r")

aulines = readlines(f2)



