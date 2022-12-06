% Plots the shape of the spar
% Inputs:
%     x: points along the horizontal 
%     a: design variables or the coefficients of the height function
%     L: Horizontal length of the heat exchanger.
% Outputs: 
%     h: Height function of the air-side.
 
function [h_]=height_fun(x,h)
n_xpoints = numel(x);
h_ = zeros(n_xpoints,1);
x
for i=1:n_xpoints       %loop over each of the x-points/nodes
    h_(i) = (x(i)-x(i+1))/(x(i-1)-x(i+1))*h(i-1)+(x(i)-x(i-1))/(x(i)-x(i-1))*h(i+1);
    h_(i) = a(1)*x(i);    %Value of heights at each x-points.
end
end
