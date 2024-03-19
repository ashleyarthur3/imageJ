%% part 1 motors diffuse out of an descrete function 
%diffusion equasion - aster forms and motors are collectin in the aster no
%we turn the light off

clear variables;
close all;

%define the model parameters

D = 10;%diffusion coefficient in um^2/s
L = 200; %size of system um
nTotal = 100; %total number of molecules

%simulation parameters
dx = 1; %box size positon step in microns
numBoxes = L/dx; %number of boxes in the cell
k = D/dx^2; %jump rate 1/sec
dt = (1/k)/10; %time step in sec 1 tenth of rate 

nTimeSteps = 20000; 
%totalTime = nTimeSteps*dt

N = zeros(nTimeSteps, numBoxes); %initialize 

%define initial condition to seed simulation

%N(1,numBoxes/2) = nTotal; %all molecueles in cell midpoint
%N(1,:) = 1; %AU FLOURESCEN =1 
positionVector = (0:dx:L-dx); % in units of minutes
%N(1,:)=exppdf(positionVector,10);
A = 1;
C = 0.1;
lambda = 10; 
% equ for exp decay N = A*e^(1/lambda) + c ; A is height and c is offset
% (ie c is the minimum amount of motor)
N(1,:) = A * exp(-1 * positionVector/lambda)+C; % motors start of exp distributed


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

%bar3(N(1:50:end, : ) ) %plot subset of times but all positions
plot(positionVector, N(1,:), 'o') %at time 100
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

%% part 1 motors diffuse out of an continous function 
%diffusion equasion - aster forms and motors are collectin in the aster no
%we turn the light off

clear variables;
close all;

%define the model parameters

D = 10;%diffusion coefficient in um^2/s
L = 200; %size of system um
nTotal = 100; %total number of molecules

%simulation parameters
dx = 1; %box size positon step in microns
numBoxes = L/dx; %number of boxes in the cell
k = D/dx^2; %jump rate 1/sec
dt = (1/k)/10; %time step in sec 1 tenth of rate 

nTimeSteps = 20000; 
%totalTime = nTimeSteps*dt

N = zeros(nTimeSteps, numBoxes); %initialize 

%define initial condition to seed simulation

%N(1,numBoxes/2) = nTotal; %all molecueles in cell midpoint
%N(1,:) = 1; %AU FLOURESCEN =1 
positionVector = (0:dx:L-dx); % in units of minutes
%N(1,:)=exppdf(positionVector,10);
A = 1;
C = 0.1;
lambda = 10; 
% equ for exp decay N = A*e^(1/lambda) + c ; A is height and c is offset
% (ie c is the minimum amount of motor)
N(1,:) = A * exp(-1 * positionVector/lambda)+C; % motors start of exp distributed


for i=2:nTimeSteps
  
    
    
    %diffusion equasion dC/dt = D * d^2c / dx^2

          
   end

%bar3(N(1:50:end, : ) ) %plot subset of times but all positions
plot(positionVector, N(1,:), 'o') %at time 100
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



