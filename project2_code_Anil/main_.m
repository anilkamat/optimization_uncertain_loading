% Main function to do the experiments.
clear all; clc; close all; format long;
% constants
rho     = 1600;                       % kg/m^3
E       = 70*10^9;                    % pascal
U       = 600*10^6;                   % pascal
Weight_plane = 500;                   % Kg
W0      = 1633.33;                    % weight/length 
L       = 7.5;                        % spar length (m)
Nelem   = 15;                         % number of elements
Nx      = Nelem+1;                    % number of nodes or x
x       = linspace(0,7.5,Nx)';        % Nodal points along x-axis
p       = 1;
h0      = zeros(2*(Nelem+1),1);
for i=1:(Nelem+1)                     % initilization
    h0(p)   = 0.05;                   % height of outer heights
    h0(p+1) = 0.0415;                 % height of inner heights
    p       = p+2;
end
% computes nominal stress and internally plots them
F0 = W0/L*(L-x(1));                   % Force at the root
[mean_stress]= mean_std_stress_nominal(x,L,E,Nelem,h0,F0);
[Nominal_Spar_weight, grad_nominal]=  obj(h0,x);
fprintf('\n nominal spar weight: %f',Nominal_Spar_weight);
%% Mesh refinement; effect of number of  elements in the FEM mesh
algo = 'active-set';
OptimalMass = mesh_refine(L, E,U,W0,algo);
%% performs optimiation 
[h_coef_minimizer,fval] = optimize(x, h0, L, E, Nx, Nelem, U, F0,algo);
[~, F_mean] = mean_std_stress_nominal(x,L,E,Nelem,h_coef_minimizer,F0);  % to generate optimized figure
Iyy = AreaMomentIyy(h_coef_minimizer);
[u] = CalcBeamDisplacement(L, E, Iyy, F_mean, Nelem);
u = reshape(u,2,[])';
%% Plot the displacement of the outer and inner surfaces.
figure()
plot(u(:,1),'black','linewidth',2 ) ; hold on
plot(u(:,2),'--black', 'linewidth',2) ; hold on
title('Displacement')
legend('top surface','inner surface')
xlabel('Nodes')
ylabel('Displacement')
xlim([0 (Nelem+2)])
%%  calculates the % decrease in the optimal mass
[ub_stress , F_mean]= mean_std_stress(x,L,E,Nelem,h_coef_minimizer,F0);
final_stress_dist = stress_dist(L,E,Nelem,h_coef_minimizer,F_mean); % mean stress distribution
optimal_mass    = CalcSparWeight(rho,x,h_coef_minimizer);
percent         = (Nominal_Spar_weight- optimal_mass)/Nominal_Spar_weight*100;
fprintf('\n The optimal mass is %f ', optimal_mass);
fprintf('\n The optimal mass is %f %% of Nominal', percent);
%% Plots the inner and outer surface of the optimal spar
h = reshape(h_coef_minimizer,2,[])';
optimal_thickness = h(:,1)-h(:,2);
for i = 1:numel(optimal_thickness)
    if optimal_thickness(i) < 0.0025
        fprintf('Thickness is above the minimum thickness');
    end
end
figure()
plot(h(:,1),'black','linewidth',2 ) ; hold on
plot(h(:,2),'--black', 'linewidth',2) ; hold on
plot(-h(:,1),'black','linewidth',2) ; hold on
plot(-h(:,2),'--black','linewidth',2)
legend('top surface','inner surface')
xlabel('Nodes')
ylabel('Heights from center')
ttl = sprintf('Spar optimal shape with %d elements',Nelem);
title(ttl)
grid on;
%% Plots the nominal shape of the spar
h0 = reshape(h0,2,[])';
figure()
plot(h0(:,1),'black','linewidth',2 ) ; hold on
plot(h0(:,2),'--black', 'linewidth',2) ; hold on
plot(-h0(:,1),'black','linewidth',2) ; hold on
plot(-h0(:,2),'--black','linewidth',2)
legend('top surface','inner surface')
xlabel('Nodes')
ylabel('Heights from center')
ylim([-.06 .06])
xlim([0 (Nelem+2)])
ttl = sprintf('Nominal shape with %d elements',Nelem);
title(ttl)
grid on;