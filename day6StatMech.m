%% stat mech of a ion channel

%p open = w open / w open + wclosed


%parameters

Eclosed = -10; %kbT
Eopen = -20:20;

Popen = [];

% for i = 1:length(Eopen)
%     
% Popen(i) = exp(-Eopen(i)) / (exp(-Eopen(i)) +  exp(-Eclosed) );
% 
% end
Popen = exp(-Eopen) ./ (exp(-Eopen) +  exp(-Eclosed) );


plot (Eopen,Popen, '-');
ylabel('P open')
xlabel('E open')

% or just compute by vector and plot 
figure;
plot(Eopen, exp(-Eopen) ./ ( exp(-Eopen) +  exp(-Eclosed) ))