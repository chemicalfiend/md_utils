fo=fopen('ring.xyz','w');
 fii=fopen('../../../ATOMTYPE.INF','r');
 s1=fscanf(fii,'%s',4)
 for i=1:20
    s1=fscanf(fii,'%s',1);
 rii=fscanf(fii,'%d',1)
 for j=1:5 % 5-membered ring
   l=fscanf(fii,'%d',3);
ring(i,j)=l(3);
   s1=fscanf(fii,'%s',1);
 end
 end
