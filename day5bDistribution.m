%% part 1 motors diffuse out of an descrete function 
%diffusion equasion - aster forms and motors are collectin in the aster no
%we turn the light off

clear variables;
close all;

%define the model parameters

D = 10; %diffusion coefficient in um^2/s
t = [1,10,100]; %i 
x = [-20:1:20]; %j 

c = zeros(length(t), length(x));

for i = 1:length(t)
    
   for j = 1:length(x)
       
      c(j,i) = (1 / ( (4*pi*D*t(i) ) ^ 0.5)) * exp( - (x(j).^2 ) / ( 4 *D*t(i) ) );
       
    
   end
end


semilogy(x, c)

%% exercise on Ficks law

%1 plot c(x) = 1 + cos(x)

c=[];
x = -20:.01:20;
c = 1 + cos(x);
figure;
plot(x,c)

% plot dc/ dx
figure;

DCDX = -sin(x);
plot(x,DCDX)

% plot J = -D * dcdx
figure;
J = -D * DCDX
plot(x, J, '-k')



%% mRNA production

clear variables;
close all;
t = 10; % time in minutes
r = 1/1;% growth rate in 1/ minutes
dt = 1/60;% seconds
gamma = 1/3; 
M = [];
M(1) = 2*r/gamma;%0;

totalSteps = t/dt;
timecounter = 0;
T = [];

for i = 2:totalSteps
    
    M(i) = M(i-1) + (r*dt) - gamma*dt*M(i-1);
    
    timecounter=timecounter + dt;
    
    T(i) = timecounter;
    
end 

plot (T,M)
title('mRNA production')
xlabel('time')
ylabel('mRNA')

