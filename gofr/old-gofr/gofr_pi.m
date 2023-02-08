clear all;
clc;
close all
%%%%%%%% (Provide)
ni=10;

%%%%%%%%%%%%%%
% ring(1,:)=[1 2 3 4 5 6];
fo=fopen('ring.xyz','w');

fprintf('---------------------------\n');
fprintf('   Program: static_pp.m\n');
fprintf('---------------------------\n\n');
for k1=1
   ri(k1)=6; 
end

for k1=2:3
   ri(k1)=5; 
end
for k1=4:7
   ri(k1)=6; 
end
for k1=8
    ri(k1)=5;
end
for k1=9
   ri(k1)=6; 
end
for k1=10
   ri(k1)=5; 
end
for k1=11:15
   ri(k1)=6; 
end
for k1=16:17
   ri(k1)=5; 
end
for k1=18:25
   ri(k1)=6; 
end
for k1=26
   ri(k1)=5; 
end
for k1=27
   ri(k1)=6; 
end
for k1=28
   ri(k1)=5; 
end
for k1=29:32
   ri(k1)=6; 
end
for k1=33
   ri(k1)=5; 
end
for k1=34
   ri(k1)=6; 
end
 for k1=35
   ri(k1)=5; 
end
for k1=36:39
   ri(k1)=6; 
end
for k1=40
   ri(k1)=5; 
end
for k1=41
   ri(k1)=6; 
end
for k1=42
   ri(k1)=5; 
end
for k1=43:46
   ri(k1)=6; 
end
for k1=47
   ri(k1)=5; 
end
for k1=48
   ri(k1)=6; 
end
for k1=49
   ri(k1)=5; 
end
for k1=50:53
   ri(k1)=6; 
end
for k1=54
   ri(k1)=5; 
end
for k1=55
   ri(k1)=6; 
end
for k1=56
   ri(k1)=5; 
end
for k1=57:60
   ri(k1)=6; 
end
for k1=61
   ri(k1)=5; 
end
for k1=62
   ri(k1)=6; 
end
for k1=63
   ri(k1)=5; 
end
for k1=64:67
   ri(k1)=6; 
end
for  k1 = 68
    ri(k1)=5;
end
for k1 = 69
   ri(k1)=6; 
end
fii=fopen('ATOMTYPE.INF','r');
 s1 = fscanf(fii,'%s',4);
 for i=1:69
   s1=fscanf(fii,'%s',1);
 rii= fscanf(fii,'%d',1);
for j=1:ri(i)
l=fscanf(fii,'%d',3);
ring(i,j)=l(3);
   s1=fscanf(fii,'%s',1);

end
 end
f0 = fopen('prod_303k.lammpstrj','r');
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
nc=200; %no. of chain
n_i=nc*ni; % no. of IONS
bx = 2*x(2);
by = 2*y(2);
bz = 2*z(2);
boxvol = bx*by*bz;
rhobulk = npart/boxvol;
% initialize and zero accumulators
cnt = 0.0;
bin = 0.5;
rmax = z(2);
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
   % binvol(i) = bx*by*2*(bhi(i)-blo(i));
   binvol(i) = (4.0/3.0)*pi*(bhi(i)^3 - blo(i)^3);
      % binvol(i) = len*pi*(bhi(i)^2 - blo(i)^2);
end
fi=fopen('final_10.xyz','r');
n_poly=fscanf(fi,'%d',1) % excluding ions
fclose(fi);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
natoms=(n_poly/nc)
f1 = fopen('prod_303k.lammpstrj','r');

disp(' ');
disp('reading trajectory file ...');
disp('sample #      ');
particles=0; %

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
    count=0;
    count1=0;
    % read coorinates
    th=0;
    th=0;
al=0;
ncc=0;      % mol id for different chain
rid=0;  % 4 rings joined together have same id resid()
particles=0; %no. of particles in one timestep (initialization)
 fprintf(fo,'%d\n\n',69*nc);
    for j=1:nc
        % display time and progress
    %if (mod(j,1) == 0)
    %    fprintf('\b\b\b\b\b\b\b');
    %    fprintf('%7d',j);
   % end
        for k=1:69
        c(k)=0;
        cx(k)=0;
        cy(k)=0;
        cz(k)=0;       
        end
    
    for i = 1:natoms
%             if (mod(i,500) == 0)
%         fprintf('\b\b\b\b\b\b\b');
%         fprintf('%7d',i);
%     end
       r = fscanf(f1,'%d %d %d %f %f %f', 6);
       
       id = r(1);
       id=id-ncc;
       resid = r(2);
       type=r(3);
       rx = r(4);
       ry = r(5);
       rz = r(6);
       %%%% backbone thiophene rings
       for k1=1:69
                th=th+1;
        for   k2=1:ri(k1)
           if id == ring(k1,k2)
                c(k1)=c(k1)+1;
                typet(k1)=1;

                    cx(k1)=cx(k1)+rx;
                    cy(k1)=cy(k1)+ry;
                    cz(k1)=cz(k1)+rz;
           end
       end
       end
      
    end

      
        for k=1:69
        cx(k)=cx(k)/ri(k);
        cy(k)=cy(k)/ri(k);
        cz(k)=cz(k)/ri(k);
        fprintf(fo,'%d\t%f\t%f\t%f\n',1,cx(k),cy(k),cz(k));
        end
           for k=1:69
        particles=particles+1;
    c1x(particles)=cx(k);
    c1y(particles)=cy(k);
    c1z(particles)=cz(k);
    resid1(particles)=resid;
    type1(particles)=typet(k);
           end
           
    ncc=ncc+natoms;
    rid=rid+5;
    end
    
    for i = 1:particles-1  %28-1
        for j = i+1:particles  %28
  if resid1(i)~=resid1(j)

            rijx = c1x(i) - c1x(j);
            rijy = c1y(i) - c1y(j);
            rijz = c1z(i) - c1z(j);
%             rijx = c1x(ii,i) - c1x(ii,j);
%             rijy = c1y(ii,i) - c1y(ii,j);
%             rijz = c1z(ii,i) - c1z(ii,j);
            rijx = rijx - round(rijx/bx) * bx;
            rijy = rijy - round(rijy/by) * by;
            rijz = rijz - round(rijz/bz) * bz;
            rij = sqrt(rijx^2 + rijy^2 + rijz^2);
             for jj = 1:nbin
           if(rij >= blo(jj) && rij < bhi(jj))
                %if (resid1(j)~=resid1(i))
               nct(jj) = nct(jj) + 1.0;
                end
           end
           
             end
   
        end
    end
   
  for i=1:npart-natoms
       r = fscanf(f1,'%d %d %d %f %f %f', 6);
end   
  %  end
end
fclose(f1);

% create and open file to write data
%f2 = fopen('rho_sidechain.dat','w');
f2 = fopen('rho_backbone_pi.dat','w');
%f222 = fopen('rho_ion.dat','w');
disp(' ');
disp('1. writing hydrogen density profile ...');
disp(' ');

for i = 1:nbin
    nct(i) = nct(i)/(cnt*particles);
    fprintf(f2,'%f %f\n', (i*bin),(nct(i)/binvol(i)));
end


fclose(f2);

disp(' ');
disp('Calculation complete!');
disp(' ');
