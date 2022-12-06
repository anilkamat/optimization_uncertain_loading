function [ub_stress , F_mean]= mean_std_stress(x,L,E,Nelem,h,F0)
%Runs the optimization algorithm using complex step method and returns the
%optimized design variable and objective function value.
% Inputs:
%     x: points along the horizontal 
%     h: intial a design variable coefficients % should be in form:
%     [r_out_1, r_in_1,r_out_2, r_in_2] to match the Aineq coefficient form
%     L: length of spar
%     E:Elastic modulus
%     Nelem: number of elelemnts
%     h: heights of spar at each nodal point
%     F: Force
% Outputs: 
%     h_coef_minimizer: optimzed nodal height( i.e. design variable)
%     fval: final value of the objective function
%     ub_stress = mean plus 6 standard deviation of the stress

% define function and gaussian variables
mu1 = 0.0; sigma1 = F0/(10*1); mu2 = 0.0; sigma2 = F0/(10*2); mu3 = 0.0; sigma3 = F0/(10*3); mu4 = 0.0; sigma4 = F0/(10*4);
% using 3 point Gauss-Hermite quadrature
xi = [-1.22474487139; 0.0; 1.22474487139];
wts = [0.295408975151; 1.1816359006; 0.295408975151]./sqrt(pi); % adjusted weights
mean_stress = 0.0;
mean_stress_square = 0.0;
n = 1; 
for i1 = 1: size(xi,1)
    pt1 = sqrt(2)*sigma1*xi(i1)+mu1;
    for i2 = 1:size(xi,1)
        pt2 = sqrt(2)*sigma2*xi(i2)+mu2;
        for i3 = 1:size(xi,1)
            pt3 = sqrt(2)*sigma3*xi(i3)+mu3;
            for i4 = 1:size(xi,1)
                pt4 = sqrt(2)*sigma4*xi(i4)+mu4;
                force = forceDist(x,pt1,pt2,pt3,pt4);
                
                stress_ = stress_dist(L,E,Nelem,h,force); 
                mean_stress = mean_stress + wts(i1)*wts(i2)*wts(i3)*wts(i4)*stress_;
                
                mean_stress_square = mean_stress_square+ wts(i1)*wts(i2)*wts(i3)*wts(i4)*stress_.^2;
                
                forces_eachPerturbation(:,n) = force;
                n = n+1;
            end
        end
    end
end

%STD of stress
s_mean2 = mean_stress.^2;
std_stress = sqrt(mean_stress_square-s_mean2);
ub_stress = (mean_stress + 6*std_stress)';

%Plot stress distribution
% figure()
% grid on ;
% x = 1:numel(mean_stress);
% curve1 = (mean_stress + 6*std_stress)';
% curve2 = (mean_stress - 6*std_stress)';
% x2 = [x, fliplr(x)];
% inBetween = [curve1, fliplr(curve2)];
% fill(x2, inBetween, [.7 .7 .7],'edgecolor', 'b', 'edgealpha', 0.1,'FaceAlpha',0.5);
% hold on;
% plot(curve1,'black','Marker', 'square','linewidth',1.5); hold on;
% plot(curve2,'black','Marker', 'diamond','linewidth',1.5); hold on;
% plot(x, mean_stress, 'black','Marker','o', 'LineWidth',1.5);
% title('Stress distribution: optimal design')
% legend('filled area','mean+6*std', 'mean-6*std','mean stress')
% grid on ;
% xlabel('Nodes')
% ylabel('Stress (N/m^2)')
% 
% % %Plot force distribution
F_mean = mean(forces_eachPerturbation');
% figure()
% plot(x,F_mean,'black', 'linewidth',2,'Marker','square')
% title('Mean force distribution:optimal design')
% xlabel('Nodes')
% ylabel('Force (N)')
% grid on;
end
        

