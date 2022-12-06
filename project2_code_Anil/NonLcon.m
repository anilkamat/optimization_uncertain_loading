function [c,ceq,Jieq,Jeq] = NonLcon(x,L,E,Nelem,h,U,F0)                     % compute stress distribution
   
    c  = subObj(h);                                 % inequality constraints 
    ceq     = [];
    Jeq     = [];                                  % Jacobian equality constraints
    
    Jieq    = zeros(size(h,1)/2,size(h,1));        % Jacobian for inequality constraints
    dh      = 1e-64;
    for i=1:numel(h)
        hc          = h;
        hc(i)       = hc(i)+ complex(0, dh);
        Jieq(:,i)   = -imag(subObj(hc))/dh;        % gradient of objective, NOTE hc
    end
    Jieq            = Jieq';                       %transpose as the Matlab wants transpose
    
    function [sigma] = subObj(h)
    [ub_stress,~]        = mean_std_stress(x,L,E,Nelem,h,F0);
    sigma            = ub_stress/U -1;                                     % sigmai(r)/sigma(max)-1   
    end
end