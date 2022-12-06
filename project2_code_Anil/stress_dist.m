function sigma = stress_dist(L,E,Nelem,h,force)                     % compute stress distribution
   
Iyy         = AreaMomentIyy(h);
%Iyy;
[u]         = CalcBeamDisplacement(L, E, Iyy, force, Nelem);
z           = reshape(h,2,[])';
zmax        = z(:,1);                                           % not sure about this
sigma       = CalcBeamStress(L, E, zmax, u, Nelem);
end