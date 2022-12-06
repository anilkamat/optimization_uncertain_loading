function [mass] = CalcSparWeight(rho,x,h)
% Computes weight of the spar member
% Inputs:
%   x - nodes along the x-axis to compute the lenght of the each elements
%   h - height at each of the nodal element
%   Nelem - number of finite elements to use
% Outputs:
%   mass - total mass of one spar
%
% Assumes the beam is symmetric about the y axis
%--------------------------------------------------------------------------


Nelem = size(h,1)/2-1;                  % number of elements

H = reshape(h,[2,Nelem+1])';            % 1st col is outer heights, 2nd col is inner heights.
nodal_area = pi*(H(:,1).^2-H(:,2).^2);

mass = rho*trapz(x,nodal_area);

end