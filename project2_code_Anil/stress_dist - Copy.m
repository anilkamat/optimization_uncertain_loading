function [sigma,ceq] = stress_dist(L,E,Nelem,h,U,force)                     % compute stress distribution
    Iyy = AreaMomentIyy(h);
    %Iyy;
    [u] = CalcBeamDisplacement(L, E, Iyy, force, Nelem);
    z = reshape(h,2,[])';
    zmax = z(:,1);                                                          % not sure about this
    [sigma_i] = CalcBeamStress(L, E, zmax, u, Nelem);
    sigma = sigma_i/U -1;                                                   % sigmai(r)/sigma(max)-1   
    ceq = [];    
    
end