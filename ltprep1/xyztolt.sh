rm -r fin.lt
gfortran -o xyztolt xyztolt.f90 -ffree-line-length-none
./xyztolt but.xyz ANTECHAMBER_AC.AC charges.blk fin.lt 12 1 12

