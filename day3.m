%day 3 chemical master equation chassis!
%code chassis for stochastic simulation for on / off rates and many more

%% part 1 diffusion in 1D
%diffusion of molecules in the middle of an ecoli cell

clear variables;
close all;

%define the model parameters

D = 10;%diffusion coefficient in um^2/s
L = 2; %size of system i.e. Ecoli cell in um
nTotal = 100; %total number of molecules

%simulation parameters
dx = 0.01; %box size positon step in microns
numBoxes = L/dx; %number of boxes in the cell
k = D/dx^2; %jump rate 1/sec
dt = (1/k)/10; %time step in sec 1 tenth of rate 

nTimeSteps = 20000; 
%totalTime = nTimeSteps*dt

N = zeros(nTimeSteps, numBoxes); %initialize 

%define initial condition to seed simulation

%N(1,numBoxes/2) = nTotal; %all molecueles in cell midpoint
N(1,:) = 1; %AU FLOURESCEN =1 
N(1,numBoxes/2 - 10 : numBoxes/2 + 10) = 0; %FRAP THE CENTER

for i=2:nTimeSteps
   
    %inside boundries conditions
    for j=2:(numBoxes-1)
    %number now = number before + in fromleft + in from right - out from
    %left - out from right
    
    N(i,j) = N(i-1,j) + N(i-1,j-1)*k*dt + N(i-1,j+1)*k*dt...
       -  N(i-1,j)*k*dt - N(i-1,j)*k*dt;
    end   
    %cell boundries - now for the edges
    
    N(i,1) = N(i-1,1) + N(i-1,2)*k*dt - N(i-1,1)*k*dt;%what hops in from right minus what hops out

    N(i,numBoxes) = N(i-1,numBoxes) + N(i-1,numBoxes-1)*k*dt - N(i-1,numBoxes)*k*dt;

    %what hops in from left minus what hopped out
end

bar3(N(1:50:end, : ) ) %plot subset of times but all positions

xlabel('position')
ylabel('time')
zlabel('n molecules')
%xlim([numBoxes/2- 10 , numBoxes/2+ 10 ]) %zoom into center
%ylim([0, 20]) %zoom into center

positionVector = (0:dx:L-dx);
figure;
plot(positionVector, N(100,:), '-k') %at time 100
hold on
plot(positionVector, N(1000,:), '-r') %at time 1000
plot(positionVector, N(10000,:), '-b') %at time 1000
hold off
xlabel('position um')
ylabel('number of molecules')
legend('0.0001 sec', '0.001 sec', '0.001 sec')

totalCheck = sum(N(400,:))

%% entropry maximization and equilibrium

%plot total entropy as a function of L where L is number or particles on
%the right have of a two sectioned lattice with omega sites

omega = 1e9; % number of sites (i.e 1nm ^3 sites on ecoli)
LTot = 1e4; % total # of particles i.e. 10um

%define L space (x-axis)
L = 1:100:LTot; %can have 1 or all particles on right side

SL = (LTot-L).*log(omega) - (LTot-L).*log(LTot-L)+(LTot-L); %left side entroy for a range of Ls

SR = L.*log(omega) - L.*log(L) + L; 

STot = SL + SR; %total entropy

plot(L, STot, 'g')
hold on
plot(L, SL, 'b')
plot(L, SR, 'k')
hold off
xlabel('L - particles on right')
ylabel('entropy');
legend('STot', 'SL','SR')

%% plot of deltaG plory huggins free energy of mixing

%define our parameters

phi = 0:0.01:1; %fraction of particles that are type A phi = pA = Na/Natoms
chi = (-2:1:7); %flory parameters, energtic cost of being next to a particles
N = 10; %degree of polymerization (valency)

deltaG = zeros(1,length(phi)); %create an array for deltaG

%free energy of mixing

for k = 1:length(chi);
    for j = 1:length(phi)
        
        deltaG(j,k) = 1/N * phi(j)*log(phi(j)) + (1-phi(j))*log(1-phi(j))...
          +  chi(k).*phi(j)*(1-phi(j));
    end
    plot(phi,deltaG)
    leg(k) = strcat('chi = ', string(num2cell( chi(k) )));
end % chi

xlabel('phi fraction type A')
ylabel('delta G free energy of mixing')
legend(leg)
