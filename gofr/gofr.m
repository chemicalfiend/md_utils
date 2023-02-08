clear all;
clc;
close all
%%%%%%%%%%%%%% Provide Here

nc=50; %no. of chain
atoms=158; % no of atoms in one chain

%%%%%%%%%%%%%%
%%% Total no of atoms of PEDOT

natoms=nc*atoms

%%%%%%%%%%%%%%%%%%%%%%%%%%
f0 = fopen('last_poly.lammpstrj','r');
l1 = fscanf(f0, '%s', 2);
tstep = fscanf(f0, '%d', 1);
l2 = fscanf(f0, '%s', 4);
npart = fscanf(f0, '%d', 1);
l3 = fscanf(f0, '%s', 6);
x = fscanf(f0, '%f %f',2);
y = fscanf(f0, '%f %f',2);
z = fscanf(f0, '%f %f',2);
l4 = fscanf(f0, '%s', 8);
fclose(f0);

%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%
bx = 2*x(2);
by = 2*y(2);
bz = 2*z(2);
boxvol = bx*by*bz;
rhobulk = npart/boxvol;
% initialize and zero accumulators
cnt = 0.0;
bin = 0.5;
rmax = x(2);
pi = 3.1416;
nbin = round(rmax/bin);
for i = 1:nbin
   nct(i) = 0.0;
ncts(i) = 0.0;
  nctp(i) = 0.0;
end
lo = 0.0;
hi = lo + bin;
%len=0.5;
for i = 1:nbin
    blo(i) = lo;
    bhi(i) = hi;
    lo = hi;
    hi = lo + bin;

   binvol(i) = (4.0/3.0)*pi*(bhi(i)^3 - blo(i)^3);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1 = fopen('last_poly.lammpstrj','r');
disp(' ');
disp('reading trajectory file ...');
disp('sample #      ');

% loop over all time
while ~feof(f1)
    l1 = fscanf(f1, '%s', 2);
    if isempty(l1)
       break;
    end
    tstep = fscanf(f1, '%d', 1);
    l2 = fscanf(f1, '%s', 4);
    npart = fscanf(f1, '%d', 1);
    l3 = fscanf(f1, '%s', 6);
    x = fscanf(f1, '%f %f',2);
    y = fscanf(f1, '%f %f',2);
    z = fscanf(f1, '%f %f',2);
    l4 = fscanf(f1, '%s', 8);
    
    cnt = cnt + 1;
    
    % display time and progress
     if (mod(cnt,10) == 0)
         fprintf('\b\b\b\b\b\b\b');
         fprintf('%7d',cnt);
     end
    
    for i = 1:natoms %reading coordinates

       r = fscanf(f1,'%d %d %d %f %f %f', 6);
       
       id = r(1);
       resid(i) = r(2);
       type=r(3);
       rx(i) = r(4);
       ry(i) = r(5);
       rz(i) = r(6);
      
    end

    %%%%% G(r) calculation .......
    for i = 1:natoms 
        for j = i+1:natoms
            if resid(i)~=resid(j)
                rijx = rx(i) - rx(j);
                rijy = ry(i) - ry(j);
                rijz = rz(i) - rz(j);

                rijx = rijx - round(rijx/bx) * bx;
                rijy = rijy - round(rijy/by) * by;
                rijz = rijz - round(rijz/bz) * bz;
                rij = sqrt(rijx^2 + rijy^2 + rijz^2);
                for jj = 1:nbin
          	        if(rij >= blo(jj) && rij < bhi(jj))
                        nct(jj) = nct(jj) + 1.0;
                    end
                end
            end
           
        end
   
    end
    for i=1:npart-natoms
       	r = fscanf(f1,'%d %d %d %f %f %f', 6);
	end   
end

fclose(f1);

% create and open file to write data

f2 = fopen('gofr-50-tos.dat','w');

disp(' ');
disp('1. writing hydrogen density profile ...');
disp(' ');

for i = 1:nbin
    nct(i) = nct(i)/(cnt*natoms);
    fprintf(f2,'%f %f\n', (i*bin),(nct(i)/binvol(i)));
end


fclose(f2);

disp(' ');
disp('Calculation complete!');
disp(' ');
