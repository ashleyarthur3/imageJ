% day 1 exponential growth
% sim bacterial exponential growth, compare sim to real, chi squared min to
% find growth rate that best describe data

%% part I simulate exponential growth

% if cells double every 1/r minutes, we can describe growth of population
% of cells (N) as a function of time (t) using

%dN/dt = r * N

%where r has units of 1/minutes

clear variables
close all


% Define our biological parameters

r = 1/20;% growth rate in 1/ minutes
N0 = 1; %initial condition number of cells at time point zero

%define our simulation parameters

dt = 5; % time step
totalSteps = 50; % total time in steps


% simulation

%N1 = N0 + r*N0*dt;

N=zeros(totalSteps,1);
T=zeros(totalSteps,1);

N(1)= N0 + r*N0*dt;
T(1) = 0;
timecounter = 0;
for i = 2:totalSteps
    
    N(i) = N(i-1) +r*N(i-1)*dt;
    timecounter=timecounter + dt;
    T(i) = timecounter;
    
end 
figure;
plot(T,N);
xlabel('time (mins)');
ylabel('number of cells');
title('expontential population growth over time');
%% part II
load('ColonyGrowthMeasurements.mat');
plot(times, area, 'o');
xlabel('time (mins)')
ylabel('colony area pix^2')
title('measured colony growth')

%% part III chi square min - best fit bacterial division time

dataForFit = area(10:end);

rRange = 1/60 : 0.00001: 1/10; %units of 1/min

%evaluate the fit for sample R

rTest = 1/20 %units of 1/min

timesForFit = dt*(0:length(dataForFit)-1);

%chi squared example

%No e^rt
N10 = dataForFit(1);
theoryTest =  N10 * exp(rTest * timesForFit);

chiSq = sum((theoryTest-dataForFit).^2);
plot(timesForFit, dataForFit, 'k.')
hold on
timeFit = timesForFit +10*dt;
plot(timeFit, N10 * exp(rTest*timesForFit), 'r')
hold off
xlabel('time starting from time point 10 (min)')
ylabel('colony area')
legend('data', 'guess')


chiSq = zeros(length(rRange),1);

for j = 1:length(rRange)
    %N = n0 * e ^ rt
    theory = N10 * exp(rRange(j) * timesForFit);
    % sum theory - data for that rate
    chiSq(j) = sum((theory-dataForFit).^2);
    
end
[M, I] = min(chiSq);

rFit = rRange(I);

doublingTime = log(2)/rFit
%log(2)/r ~ 1/r
figure;

semilogy(rRange,chiSq)
xlabel('rate')
ylabel('chisquare')
hold on
hold off
figure;
bestFit = N10 * exp(rFit*timesForFit);
semilogy(times, area, '.k')
hold on
plot(timeFit, bestFit, 'r')
hold off
xlabel('time (min)')
ylabel('colony area')
legend('data', 'fit')


