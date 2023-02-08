import mdtraj as md
import mbuild as mb
import gsd


tr = md.load_lammpstrj('last.lammpstrj', top='top.pdb')
system = mb.load(tr)

system.box = mb.Box([200.0, 200.0, 200.0])

system.translate([77.0, 77.0, 29.0])

system.save("trajectory.gsd")



