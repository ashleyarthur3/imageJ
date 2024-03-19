%%deterministic simulation of logical growth 
%bacteria don't actually grow unbounded

%dN/dt = r*N - r*N.^2/Nstar . (growth, decay)

% day 1 exponential growth
% sim bacterial exponential growth, compare sim to real, chi squared min to
% find growth rate that best describe data

%copy data from yesterday
%% part I simulate exponential growth

% if cells double every 1/r minutes, we can describe growth of population
% of cells (N) as a function of time (t) using

%dN/dt = r * N

%where r has units of 1/minutes

clear variables
close all
 

% Define our biological parameters

r = 1/37;% growth rate in 1/ minutes
N0 = 1; %initial condition number of cells at time point zero
Nstar = 1e5; %carrying capacity or saturation steady-state population size

%define our simulation parameters

dt = 0.3; % time step
totalSteps = 3000; % total time in steps


% simulation

%N1 = N0 + r*N0*dt;

N=zeros(totalSteps,1);
T=zeros(totalSteps,1);

N(1) = N0;

T(1) = 0;
timecounter = 0;

for i = 2:totalSteps
    
    N(i) = N(i-1) +r*N(i-1)*dt - r*dt*N(i-1)^2/Nstar;
    % number   = initial + growth at the step - decay at that step
    
    
    timecounter=timecounter + dt;
    T(i) = timecounter;
    
end

figure;
plot(T,N);
xlabel('time (mins)');
ylabel('number of cells');
title('logical growth over time');


%% part II simulate logistical growth Stochastic "Gillespie"

%keep parameters from above

stochN = zeros(totalSteps, 1); %initialize 

stochN(1) = N0; %initial condition


for i=2:totalSteps
   
    pGrow = r*stochN(i-1) /  (r*stochN(i-1) + r*stochN(i-1)^2/Nstar);
    
    %pShrink = r*stochN(i-1)^2/Nstar /  r*stochN(i-1) + r*stochN(i-1)^2/Nstar;
    
    coin = rand();
    if coin < pGrow
        stochN(i) = stochN(i-1) +r*dt*stochN(i-1);
    
    else
        stochN(i) = stochN(i-1) - r*dt*stochN(i-1)^2/Nstar;
    end
    
    
end


hold on;
plot(T,stochN);
xlabel('time (mins)');
ylabel('number of cells');
title('logical growth over time');
