function [sigma2,ceq,Jieq,J] = stress_dist_nominal(L,E,Nelem,h,force)                     % compute stress distribution
    
    sigma2  = subObj(h);                           % values of stress distribution, NOTE h
    ceq     = [];
    J       = [];                                  % Jacobian equality constraints
    
    Jieq    = zeros(size(h,1)/2,size(h,1));        % Jacobian for inequality constraints
    dh      = 1e-64;
    for i=1:numel(h)
        hc          = h;
        hc(i)       = hc(i)+ complex(0, dh);
        Jieq(:,i)   = -imag(subObj(hc))/dh;        % gradient of objective, NOTE hc
    end
    Jieq            = Jieq';                        %transpose as the Matlab wants transpose

    function [sigma_i] = subObj(h_)
    Iyy         = AreaMomentIyy(h_);
    %Iyy;
    [u]         = CalcBeamDisplacement(L, E, Iyy, force, Nelem);
    z           = reshape(h_,2,[])';
    zmax        = z(:,1);                                           % not sure about this
    [sigma_i]   = CalcBeamStress(L, E, zmax, u, Nelem);
    %sigma       = sigma_i/U -1;                                     % sigmai(r)/sigma(max)-1   
    end
end