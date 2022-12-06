function [Spar_weight,grad_objective] = obj(h,x)
% Returns the sparweigth and gradients
%Input
%   h: design variables
%   x: nodal points
% Outputs
%     Spar_weight: computed spar weight
%     grad_objective: Gradient of objective w.r.t desing variable using complex step

rho             = 1600;
Spar_weight     = CalcSparWeight(rho,x,h);
dh              = 1e-60;
grad_objective  = zeros(numel(h),1);

for i=1:numel(h)
    hc                  = h;
    hc(i)               = hc(i)+ complex(0, dh);
    grad_objective(i)   = -imag(CalcSparWeight(rho,x,hc))/dh;                  % gradient of objective
end
end