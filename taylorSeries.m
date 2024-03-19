%%taylor series
close all;

x=linspace(0,2*pi,100)
y = cos(x)


y2 = 1-(x.^2 / factorial(2))

y3 = 1-(x.^2 / factorial(2)) + (x.^4 / factorial(4))

y4 = 1-(x.^2 / factorial(2)) + (x.^4 / factorial(4)) - (x.^6 / factorial(6))

y5 = 1-(x.^2 / factorial(2)) + (x.^4 / factorial(4)) - (x.^6 / factorial(6))...
    + (x.^8 / factorial(8))

y6 = 1-(x.^2 / factorial(2)) + (x.^4 / factorial(4)) - (x.^6 / factorial(6))...
    + (x.^8 / factorial(8)) - (x.^10 / factorial(10))

p = plot(x,y,'-k','LineWidth',4)

ylim([-2 2])

hold on

plot(x,y2, '-c')
plot(x,y3, '-g')
plot(x,y4, '-b')
plot(x,y5, '-m')
plot(x,y6, '-r')
xlabel('radians')
ylabel('y(x)')
legend('cosx', 'a2', 'a4', 'a6', 'a8', 'a10')
title('approximating cos(x) by Taylor Series')


