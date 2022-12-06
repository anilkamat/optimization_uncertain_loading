function [OptimalMass] = mesh_refine(L, E, U, W0, algo)
% Runs the mesh_refine algorithm by increaseing the number of elements
% inputs are as described aboce
% Outputs are the masses for different number of elements

num_mesh    = 20;       % number of mesh; +2
OptimalMass = zeros(num_mesh-1,1);

for i =2:num_mesh       % Loop for mesh refinment
    close all;
    %clc;
    fprintf('Running refinment for %d elements',i);
    Nelem   = i;
    h0      = zeros(2*(Nelem+1),1);
    Nx      = Nelem+1;
    x       = linspace(0,7.5,Nx)';
    p       = 1;
    F0      = W0/L*(L-x(1));                   % Force at the root
    for j=1:(Nelem+1)               % initilization
        h0(p)   = 0.05;             % height of outer heights
        h0(p+1) = 0.0415;          % height of inner heights
        p       = p+2;
    end
    [~,optiMass] = optimize(x, h0,L,E, Nx,Nelem,U,F0(1),algo);
    OptimalMass(i-1)       = optiMass;
end

figure()
plot(OptimalMass,'black','marker','square','linewidth',1.5)
title('Mesh refinement')
xlabel('number of element')
ylabel('Optimal Mass')
grid on;
end