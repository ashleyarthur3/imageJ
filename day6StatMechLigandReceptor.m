%% plot L / kD   (1 + L/kd)

c=1:1000; %concentration in nM
kd = 10;
plot(c, (c/kd) ./ (1 + (c/kd)));

hold on;
kd = 1000;
plot(c, (c/kd) ./ (1 + (c/kd)));

legend('10', '10000')
xlabel('concentration')
ylabel('pbound');


%% ion channel with 4 states

deltaE = 3; %kbt
deltaEBc = -5; % kbt
deltaEBo = -15; %kbt

omega = 1e9;
L= 0:10^6; 

z = exp(-deltaE) * (1 + (L./omega * exp(-deltaEBo)))...
    + (1 + (L./omega * exp(-deltaEBo)));

p1 = 1./z; % closed unbound 
p2 = L./omega * exp(-deltaEBc) ./ z; % closed and bound
p3 = exp(-deltaE) ./ z;
p4 = exp(-deltaE) * L./omega * exp(-deltaEBo) ./ z;% open and bound

semilogx(L,p1, '-k')
hold on
semilogx(L,p2, '-r')
semilogx(L,p3, '-g')
semilogx(L,p4, '-b')
xlabel('[L]')
legend('p1','p2','p3','p4')



