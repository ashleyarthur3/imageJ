bmi=rand(1,100)*25;
figure;
%hist(bmi)
edges=[0 5 10 15 20 25];
counts = 5;
hist(bmi, edges)
cat = [];
for i = 1:length(bmi)
    if bmi(i) <10
        cat(i) = 0
    else
        cat(i) = 1
    end
end
figure;
C = categorical(cat,[0 1 NaN],{'low','high','null'})
hist(cat)

new_val = 15;
hold on
plot (new_val, 20, 'y*')
