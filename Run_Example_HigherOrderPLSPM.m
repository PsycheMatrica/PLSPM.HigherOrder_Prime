%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Illustration for PLSPM.HigherOrder_Prime package                        %
%   Author: Gyeongcheol Cho & Heungsun Hwang                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:                                                            %
%   - This code aims to illustrate how to use PLSPM.HigherOrder Prime     %
%        package.                                                         %
%   - The illustration uses Bergami and Bagozzi’s (2000) organizational   % 
%        identification data                                              %
%   - This package is dependent on PLSPM.Basic_Package (Hwang & Cho, 2024) %
%     If you haven't installed this package, run the following command    %
%           Check_Dependencies                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% References                                                              %
%     * Bergami, M., & Bagozzi, R. P. (2000). Self-categorization,        %
%        affective commitment and group selfesteem as distinct aspects of %
%        social identity in the organization. British Journal of Social   %
%        Psychology, 39, 555–577. https://doi.org/10.1348/014466600164633 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

help HigherOrderPLSPM()
% Check_Dependencies

z0 = readtable('rick2.csv');
z0 = z0{:,2:end};

% model specification
W01 = [99 0 0 0                % weights for 1st-order constructs  (nvar by nlv1)
       99 0 0 0
       99 0 0 0
       99 0 0 0
       99 0 0 0
       99 0 0 0
       99 0 0 0
       99 0 0 0
       0 99 0 0
       0 99 0 0
       0 99 0 0
       0 99 0 0 
       0 99 0 0
       0 99 0 0
       0 0 99 0
       0 0 99 0
       0 0 99 0
       0 0 99 0
       0 0 0 99
       0 0 0 99
       0 0 0 99];
W02 = [99 0                 % weights for 2nd-order constructs (nlv1 by nlv2)
       99 0
       0 99
       0 99];
B0 = [0 99 
      0 0];       % path coefficients, including loadings relating 2nd-order constructs (nlv2 by nlv2)

modetype1=[1 1 1 1]; % 1 = mode A, 2 = mode B 
modetype2=[2 2];
scheme = 3;

ind_sign1=[1,9,15,19];
ind_sign2=[1,3];

N_Boot = 100;
Max_iter = 500;              % maximum number of iterations
Min_limit = 0.0001;            % convergence tolerance
Flag_Parallel = false; %  1 = centroid, 2 = factorial, 3 = path weighting

[INI,TABLE,ETC] = HigherOrderPLSPM(z0, W01,W02,B0,modetype1,modetype2,scheme,ind_sign1,ind_sign2,N_Boot,Max_iter,Min_limit,Flag_Parallel);
INI
INI.Converge
INI.iter1
INI.iter2
INI.W1
INI.W2
INI.C
INI.B
INI.CVscore1
INI.CVscore2
TABLE
TABLE.W1
TABLE.W2
TABLE.C
TABLE.B
ETC