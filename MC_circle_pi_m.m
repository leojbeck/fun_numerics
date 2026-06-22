% Leo Beck
% Classic Monte Carlo Circle
% 2026-06-22

% The classic calculate pi with monte carlo
clear
clc
clf

rng(0,"twister")    % choose rng method
n = 100000;           % # points
a = -1;             % lower limit
b = 1;              % upper limit
r = (b - a)/2;      % radius
cx = (a+b)/2;       % center
cy = cx;

points = (b-a)*rand(n, 2) + a;  % Random points
points(n,3) = 0;                % Add column of 0s

% Calculate inside / outside circle
for i = 1:1:n
    if (points(i,1)-cx)^2 + (points(i,2)-cy)^2 < r^2
        points(i,3) = 1;
    end
end

% Estimate pi
in_circle = sum(points(:,3));
pi_est = 4*(in_circle/n);
fprintf("Number of points in circle: %0d of %0d", in_circle, n)
fprintf("Square area: %0.3f", (2*r)^2)
fprintf("pi estimate: %0.6f", pi_est)
fprintf("Estimated circle area: %0.3f", pi_est*(r^2))

% Different groups for coloring purposed
x = points(:,1);
y = points(:,2);
in_c = points(:,3);

% Plotting
% Plot circle
th = 0:pi/50:2*pi;
xunit = r * cos(th) + cx;
yunit = r * sin(th) + cy;

figure(1)
h = plot(xunit,yunit, "Color", "black");
hold on

% Plot scatter
scatter(x(in_c==0), y(in_c==0), 4, "filled", "o", "blue")
scatter(x(in_c==1), y(in_c==1), 4, "filled", "o", "red")
axis equal