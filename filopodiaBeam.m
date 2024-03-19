%% how much force does it take to move two filaments into a bundle
close all;
clear variables;

%define parameters
kbt = 4.1; %pn nm
Lp = 10e3;%persistance actin in nm
Lo = 500:200:2000; % length of filaments to bundel in nm
%theta = pi/3 %45:5:90; %range of angles of arp2/3
theta = linspace(pi/3, -pi/3, 100);
%energy beam bending : E = Lp * kBT * Lo / 2 * R^2

%r = Lo / theta;

%Epn_nm = Lp * kbt * Lo / (2 * (r^2))
%Ekbt = Epn_nm / kbt
figure;
E_master = zeros(length(Lo), length(theta));

for j = 1:length(Lo);
    
    r=[];
    Epn_nm=[];
    Ekbt = [];
    thetadeg = [];
    thetaMem = [];
    
    for i=1:length(theta)
        
        r(i) = Lo(j) ./ theta(i);
        Epn_nm(i) = Lp * kbt * Lo(j) ./ (2 * (r(i)^2));
        Ekbt(i) = Epn_nm(i) / kbt;
        
    end
    
    E_master(j,:) = Ekbt;
    leg(j) = strcat('Lo:  ', ' ', string(num2cell( Lo(j) )), ' microns');

end


thetadeg = theta .* (180/pi);
thetaMem = 90-thetadeg;

plot(thetaMem, E_master);

xlabel('theta of brached network at membrane')
ylabel('energy to bend (kbT)')
%title(strcat('filament length (um): ', num2str(Lo(j))))
legend(leg)