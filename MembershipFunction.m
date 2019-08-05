function [mf, center] = MembershipFunction(R, MFNum, MFType, Domain, x, NOS)
% generate membership function with centers
center = zeros(1,MFNum);
mf = zeros(MFNum, NOS);
if(MFType == 3)
    sigma=Domain/(MFNum);
end
for i=-R:R

    switch MFType
       case 2
           m= trapmf(x-(Domain/R)*i,[(-Domain/R) (-0.3*Domain/R) (0.3*Domain/R) (Domain/R)]);
       case 1
           m= trimf(x-(Domain/R)*i,[-Domain/R 0 Domain/R]);
       case 3
           m=gaussmf(x,[sigma -(Domain/R)*i]);
    end
     mf(i+R+1,:)=m;
     %center of each membership function as "then" part of rules
     center(i+R+1)=Domain/R*i;
      
end 