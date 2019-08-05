function fuzzy_sys(Domain, DomainRes, MFNum, MF1Type, MF2Type, FF, IFEng)
%% Initialize Inputs and Membership Functions and Rules
%Domain = domain of the two inputs x1 and x2
%DomainRes = sampling interval for the two inputs x1 and x2
%MFNum = number of membership function for the two inputs x1 and x2
%MF1Type = types of membership function for the first input Triangular=1, Trapezoidal=2, Gaussian=3
%MF2Type = types of membership function for the second input Triangular=1, Trapezoidal=2, Gaussian=3

%number of membership function for each input is MFNum

NOS=2*Domain/DomainRes+1; % Number of Samples
x1= -Domain:DomainRes:Domain; % First Input Domain
x2= -Domain:DomainRes:Domain; % Secound Input Domain
R=(MFNum-1)/2; 


f=zeros(NOS);
y=zeros(NOS);

%generate membership functions
[mf1, center1] = MembershipFunction(R, MFNum, MF1Type, Domain, x1 ,NOS);
[mf2, center2] = MembershipFunction(R, MFNum, MF2Type, Domain, x2 ,NOS);


%Computing the value of centers z(center1,center2) as "then" part of rules
g=zeros(MFNum,MFNum);
for j=1:MFNum
    for jj=1:MFNum
       % y=X1.^2+X2.^2;
       g(jj,j)=center1(j).^2+center2(jj).^2;
    end
end

%% Plot Membership Functions
figure;
subplot(2,1,1)
    plot(x1,mf1,'r');
    xlabel('first input x1');
    ylabel('membership function of  x1');
    title('x1 membership functions');
    hold on
    subplot(2,1,2)
    plot(x2,mf2,'r');
    xlabel(' second input x2');
    ylabel('membership function  of x2');
    title('x2 membership functions');
    hold on

%% Fuzzy Inference Engine and Defuzzifier(combined) and Fuzzifier

%Designing Fuzzifier
%we have 3 choices to Fuzzifier : Triangular=1, singletone=2,Gaussian=3 => ff
ff1=zeros(NOS,NOS);
ff2=zeros(NOS,NOS);
for i=1:NOS
    f1=zeros(1,NOS);
    f2=zeros(1,NOS);
    switch FF
      case 1
        f1=tripuls(x1(i),1);
        f2=tripuls(x2(i),1);
        
      case 2
        f1(i)=1;
        f2(i)=1;
        
      case 3
        f1=gaussmf(x1,[.5,x1(i)]);
        f2=gaussmf(x2,[.5,x2(i)]);
        
    end
        ff1(i,:)=f1;
        ff2(i,:)=f2;
        
      
end

%Designing the Inference Engine
%In this step we are going to design the Inference Engine as follows:

%IFEng = Types of Inference Engine, Mamdani Product Engine(P.I.E)=1, Mamdani minimum Engine (M.I.E)=2

for i=1:NOS% n number of sampling point
   for ii=1:NOS
       c=0;
       D=0;
      for j=1:MFNum
         for jj=1:MFNum
             
        
         % In this sction both inference engine % diffuzifier are combined
              switch IFEng   
                    case 1
                        if FF~=2 %if command is not used for singletone fuzzifier
                         B=max(ff1(i,:).*ff2(ii,:)*(mf1(j,i)*mf2(jj,ii)));
                         Bprime= B*g(jj,j);
                       %max for composition B in each rule
                         c=c+B;%B is num in each rule
                         D=D+Bprime;%Bprime is den in each rule
                        else
                         B=mf1(j,i)*mf2(jj,ii);
                         Bprime= B*g(jj,j);
                       
                         c=c+B;
                         D=D+Bprime;
                        end % end of if
                        
                        
                   case 2
                       if FF~=2  %if command is not used for singletone fuzzifier
                         for s=1:NOS
                             Domain(s)=min([ff1(i,:).*ff2(ii,:),mf1(j,i),mf2(jj,ii)]);
                         end
                         
                         B=max(Domain);
                         Bprime=B*g(jj,j);
                       
                         c=c+B;
                         D=D+Bprime; 
                       else
                           Domain=min(mf1(j,i),mf2(jj,ii));
                           B=Domain;
                           Bprime=B*g(jj,j);
                           c=c+B;
                           D=D+Bprime; 
                       end %of if
                         
              end %of switch
              
              
         end
         
      end
     
      %Calculating f as estimated fun.
        f(ii,i)=D/c;
    end
     
end

%% Plot Orginal surface And Fuzzy estimated Surface
figure;
subplot(1,2,1)
[X1, X2]=meshgrid(x1,x2);
y=X1.^2+X2.^2;
surf(X1,X2,y,'EdgeColor','none','facecolor','g');light
title('Original surface');
E=f-y;
MSE=mse(E)
%we choose the following surface as our goal to estimate
subplot(1,2,2)
surf(X1,X2,f,'edgecolor','none','facecolor','b');light
title(' Fuzzy estimated surface ')
xlabel('X1')
ylabel('X2')



