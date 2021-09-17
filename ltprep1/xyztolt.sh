rm -r fin.lt
gfortran -o xyztolt xyztolt.f90 -ffree-line-length-none
./xyztolt poly.xyz ANTECHAMBER_AC.AC charges.blk fin.lt 23 250 25

