Nx = 3;
L =7.5;
x = [0:L/Nx:L].';
%h = height(x,a,L);

Aineq = zeros((Nx+1),(Nx+1));
bineq = zeros(Nx,1);
lb = zeros(2*(Nx+1),1);
ub = zeros(2*(Nx+1),1);
k = 1;
for i = 1:(Nx+1)
  % first, the upper bound
  Aineq(i,k) = -1; % this coefficient corresponds to variable h_out
  lb(k) = 0.0125; % r_out lb
  ub(k) = 0.05;   % r_out up
  k = k+1;
  lb(k) = 0.01;   %r_in lb
  ub(k) = 0.0475;  % r_in up
  
  Aineq(i,k) = 1; % this coefficient corresponds to variable a_in
  k = k+1; 
  bineq(i) = -0.0025;  % negative to accomodate fmincon 
end