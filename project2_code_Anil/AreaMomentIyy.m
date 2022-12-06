function Iyy = AreaMomentIyy(h)
% returns the Iyy of the pipe
% Inputs
%     h: height of the outer and inner surface of the spar
% Outputs: 
%     Iyy : Area moment of Inertia of the spar

n   = size(h,1)/2;
p   = 1;
Iyy = zeros(n,1);
lowerbound = 0.00000000000001;              % set this value to the negative Iyy(i)
for i=1:n
    Iyy(i) = pi/4*(h(p)^4 - h(p+1)^4);
    p      = p+2;
    if Iyy(i) < 0                           % to remove the negative area moments.
        Iyy(i) = lowerbound; 
    end
end

end