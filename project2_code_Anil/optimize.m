function [h_coef_minimizer,fval] = optimize(x, h0,L,E, Nx,Nelem,U,F0,algo)
%Runs the optimization algorithm using complex step method and returns the
%optimized design variable and objective function value.
% Inputs:
%     x: points along the horizontal 
%     h0: intial a design variable coefficients % should be in form:
%     [r_out_1, r_in_1,r_out_2, r_in_2] to match the Aineq coefficient form
%     
%     algo: type of algorithm to use for the optimization.
%     Nx: number of nodes(or x)
% Outputs: 
%     h_coef_minimizer: optimzed nodal height( i.e. design variable)
%     fval: final value of the objective function

Aineq       = zeros(Nx,2*Nx);
bineq       = zeros(Nx,1);
lb          = zeros(2*Nx,1);
ub          = zeros(2*Nx,1);
k           = 1;

for i = 1:Nx
  Aineq(i,k) = -1;      % this coefficient corresponds to variable h_out
  lb(k)      = 0.0125;       % r_out lb
  ub(k)      = 0.05;         % r_out up
  k          = k+1;
  lb(k)      = 0.01;         % r_in lb
  ub(k)      = 0.0475;       % r_in up
  
  Aineq(i,k) = 1;       % this coefficient corresponds to variable a_in
  k          = k+1;
  bineq(i)   = -0.0025;   % negative to accomodate fmincon 
end

%%
objective = @(h)obj(h,x);                                        % creates the objective function to minimize
nonlcon = @(h) NonLcon(x,L,E,Nelem,h,U,F0);
options = optimoptions('fmincon','SpecifyObjectiveGradient', true,'SpecifyConstraintGradient',true,'CheckGradients',true, 'Display','iter','Algorithm',algo );  %'Display','final-detailed', set the option for chaning the algorithm
[h_coef_minimizer,fval] = fmincon(objective,h0,Aineq,bineq,[],[],lb,ub,nonlcon,options); %nonlcon
end