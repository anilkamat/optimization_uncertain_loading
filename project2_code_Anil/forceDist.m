function F_x_Xi = forceDist(x,pt1,pt2,pt3,pt4)
% returns for distribution of the spar
% Inputs 
%     x: nodal points
% Outputs
%     F: force distribution

W0 = 1633.33;           % weight/length 
L = 7.5;                % m (length of spar)
n = size(x,1);
F_x_Xi = zeros(n,1);         % force

for i=1:n
    F_x_Xi(i) = W0/L*(L-x(i))+ pt1*cos(pi*x(i)/(2*L)) +pt2*cos(3*pi*x(i)/(2*L)) +pt3*cos(5*pi*x(i)/(2*L))  +pt4*cos(7*pi*x(i)/(2*L));
end

end
