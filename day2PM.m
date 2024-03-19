% day 2 log log plot of time (t) versus distance diffused (L)

clear variables
close all

D = 10; %diffusion coefficient in um^2 / sec (typical protein)

L = logspace(-2,6,1000); %micron (um) 1000 poinits from 10^-2 - 10^6

%solve for time to diffuse
%time = L^2/ D
t=L.^2/D;

figure;
loglog(L,t);
xlabel('distance diffused, : (\mum)')
ylabel('time sec')

%% diffusion by coin flips

% simulate a random walk (diffusion) by coin flips
% look at many tradjectories and statistically averages


nSteps = 100; %number of steps
time=1:nSteps;
pos = zeros(nSteps,1); %vector of positions

pos(1) = 0; % starting position
trials = 1000;
posMat = zeros(trials, nSteps);

for j = 1:trials %particles to random walk
    
    for i=2:nSteps %steps per particle
        
        coin=rand; %p
        
        if coin >0.5
            posMat(j,i) = posMat(j,i-1) + 1; % step particle at timestep
        else
            posMat(j,i) = posMat(j,i-1) - 1;
            
        end
        
    end

end
figure;
plot(time,posMat')
xlabel('nSteps')
ylabel('position')
ylim([-nSteps/2, nSteps/2])


posSquare =posMat.^2; % square each element
MSD = mean(posSquare,1);
figure;
plot(time, MSD, '.', 'MarkerSize',10)
xlabel('steps')
ylabel('MSD')