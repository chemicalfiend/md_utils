program xyztolt

    implicit none

    character(len=20) :: fname1
    character(len=20) :: fname2
	character(len=20) :: cfile
    character(len=20) :: ofile
    integer :: ntotatoms
    integer :: natoms
    integer :: cont
	integer :: kount
    character(len=10) :: mols
    character(len=10) :: atoms
	character(len=10) :: bonds
    integer :: nmol
	integer :: nbonds
    real, allocatable, dimension(:) :: x
    real, allocatable, dimension(:) :: y
    real, allocatable, dimension(:) :: z
	real, allocatable, dimension(:) :: chrg
	integer, allocatable, dimension(:) :: iatom
	integer, allocatable, dimension(:) :: jatom

    character(len=200) :: line
    character(len=2), allocatable, dimension(:) :: id

    character(len=200) :: foo, foo1, foo2

    integer :: i, j, k

    call getarg(1, fname1)
    call getarg(2, fname2)
    call getarg(3, cfile)
	call getarg(4, ofile)
    call getarg(5, atoms)
    call getarg(6, mols)
	call getarg(7, bonds)

    read(mols, *) nmol
    read(atoms,*) natoms
	read(bonds, *) nbonds

    open(10,file=fname1, status='old')
    open(12,file=fname2, status='old')
    open(20,file=ofile, status='new')
	open(15,file=cfile, status='old')

    read(10,*) ntotatoms
    read(12,*) foo1
    read(12,*) foo2

    print *, "Writing data for ", ntotatoms

    allocate(x(ntotatoms))
    allocate(y(ntotatoms))
    allocate(z(ntotatoms))
	allocate(chrg(ntotatoms))
	allocate(iatom(ntotatoms))
	allocate(jatom(ntotatoms))
    allocate(id(ntotatoms))

    cont = 0

    !fprintf(fo,'%s%d\t%s%d\t%s%s %f %f %f %f\n','$atom:',count,'$mol:',mol1,'@atom:',iddd, chrg(i), pl(1), pl(2), pl(3));

    do i = 1, nmol
        do j = 1, natoms
            cont = cont + 1
            read(10,*) foo, x(cont), y(cont), z(cont)
            read(12,'(A)') line
            id(cont) = line(73:75)
			read(15,*) foo, chrg(cont)
            write(20, '("$atom: ", i10, X, "$mol:", i5, X, "@atom: ", A2, X, f11.6, X,  f11.6, X, f11.6, X, f11.6)') cont, i, id(cont), chrg(cont), x(cont), y(cont), z(cont)
        end do
    end do

	
	do k = 1, nbonds
		read(12, *) foo, foo1, iatom(k), jatom(k)
	end do

    kount = 0
	
	do j = 1, nmol
		do i = 1, nbonds
			
			kount = kount + 1
			write(20, '("$bond: ", i10, " $atom: ", i10, " $atom: ", i10)') kount, iatom(i), jatom(i)
			iatom(i) = iatom(i) + natoms
			jatom(i) = jatom(i) + natoms
		end do
	end do
	

	close(10)
	close(12)
	close(15)
	close(20)

end program xyztolt
