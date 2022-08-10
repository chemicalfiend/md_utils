% Code by Sarbani Ghosh
% Feb. 19, 2014

% This program calculates radial density profile of hydrogen
% molecules around a nanotube.

clear all;
clc;

disp(' ');
disp('Calculating rho(r) of PEDOT');
disp('------------------------------');
disp(' ');

% open the trj file to read box size and # particles
f0 = fopen('tos/50/last_poly.lammpstrj','r');
l1 = fscanf(f0, '%s', 2);
tstep = fscanf(f0, '%d', 1);
l2 = fscanf(f0, '%s', 4);
npart = fscanf(f0, '%d', 1);
l3 = fscanf(f0, '%s', 6);
x = fscanf(f0, '%f %f',2);
y = fscanf(f0, '%f %f',2);
z = fscanf(f0, '%f %f',2);
l4 = fscanf(f0, '%s', 8);

bx = 2*x(2);
by = 2*y(2);
bz = 2*z(2);
boxvol = bx*by*bz;
rhobulk = npart/boxvol;

fclose(f0);

% initialize and zero accumulators
cnt = 0.0;
bin = 0.05;
rmax = x(2);
nbin = round(rmax/bin);
len = 200; % length of the cylinder

for i = 1:nbin
   nct(i) = 0.0;
end

lo = 0.0;
hi = lo + bin;

for i = 1:nbin
    blo(i) = lo;
    bhi(i) = hi;
    lo = hi;
    hi = lo + bin;
    binvol(i) = len*pi*(bhi(i)^2 - blo(i)^2);
end

% open trj file again to read coordinates
f1 = fopen('tos/50/last_poly.lammpstrj','r');

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
    
    % read coorinates
    for i = 1:npart
       r = fscanf(f1,'%d %d %d %f %f %f', 6);
       id = r(1);
       resid(i) = r(2);     
       rx(i) = r(4);
       ry(i) = r(5);
       rz(i) = r(6);
       
       rx(i) = rx(i) - round(rx(i)/bx) * bx; % PBC in x
       ry(i) = ry(i) - round(ry(i)/by) * by; % PBC in y
       riz = sqrt(rx(i)^2 + ry(i)^2);
       
       for j = 1:nbin
           if(riz >= blo(j) && riz < bhi(j))
               nct(j) = nct(j) + 1.0;
           end
       end
    end
end
fclose(f1);

% create and open file to write data
f2 = fopen('pedottosrho-50.dat','w');

disp(' ');
disp('1. writing hydrogen density profile ...');
disp(' ');

for i = 1:nbin
    nct(i) = nct(i)/cnt;
    fprintf(f2,'%f %f\n', (i*bin),(nct(i)/binvol(i)));
end


fclose(f2);

disp(' ');
disp('Calculation complete!');
disp(' ');



