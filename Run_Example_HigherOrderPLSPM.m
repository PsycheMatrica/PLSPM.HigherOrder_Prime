%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Illustration for PLSPM.HigherOrder_Prime package                        %
%   Author: Gyeongcheol Cho & Heungsun Hwang                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:                                                            %
%   - This code aims to illustrate how to use PLSPM.HigherOrder Prime     %
%        package.                                                         %
%   - The illustration uses two datasets:                                 %
%      (1) Bergami and Bagozzit's (2000) data                             %
%      (2) Zahid_et_al's (2024) data                                      %
%   - This package is dependent on PLSPM.Basic_Package (Cho & Hwang, 2024)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% References                                                              %
%     * Bergami, M., & Bagozzi, R. P. (2000). Self-categorization,        %
%        affective commitment and group selfesteem as distinct aspects of %
%        social identity in the organization. British Journal of Social   %
%        Psychology, 39, 555–577. https://doi.org/10.1348/014466600164633 %
%     * Zahid, Z., Zhang, J., Shahzad, M. A., Junaid, M.,                 %
%        & Shrivastava, A. (2024). Green synergy: interplay of corporate  %
%        social responsibility, green intellectual capital, and green     %
%        ambidextrous innovation for sustainable performance in the       %
%        industry 4.0 era. PLOS ONE, 19(8), e0306349.                     %
%        https://doi.org/10.1371/journal.pone.0306349                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

help HigherOrderPLSPM()
% Check_Dependencies

%% Example 1) 2nd-order component with 1st-order Components

z0 = readtable('rick2.csv');
z0 = z0{:,2:end};

% model specification
W01 = blkdiag(ones(8,1),ones(6,1),ones(4,1),ones(3,1));
W02 = blkdiag(ones(2,1),ones(2,1));
B0 = [0 1 
      0 0];       % path coefficients, including loadings relating 2nd-order constructs (nlv2 by nlv2)

modetype1=[1 1 1 1]; % 1 = mode A, 2 = mode B 
modetype2=[2 2];
correcttype1=[0 0 0 0]; % 0 = Dijktra's correction X; 1 = Dijktra's correction O
correcttype2=[0 0];

scheme = 3;

ind_sign1=[1,9,15,19];
ind_sign2=[1,3];

N_Boot = 100;
Max_iter = 500;              % maximum number of iterations
Min_limit = 0.00001;            % convergence tolerance
Flag_Parallel = false; %  1 = centroid, 2 = factorial, 3 = path weighting

Results = HigherOrderPLSPM(z0, W01,W02,B0,modetype1,modetype2,correcttype1,correcttype2,scheme,ind_sign1,ind_sign2,N_Boot,Max_iter,Min_limit,Flag_Parallel);
INI=Results.INI;
TABLE=Results.TABLE;
ETC=Results.ETC;
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

%% Example 2)  2nd-order Factor with 1st-order Components

z0 = readtable('Data_Zahid_et_al(2024).xlsx');
z0 = z0{:,:};
% model specification
W01 = blkdiag(ones(5,1),ones(4,1),ones(4,1),...
              ones(4,1),ones(4,1),ones(4,1),...
              ones(5,1));
W02 = blkdiag(ones(3,1),ones(3,1),ones(1,1));
B0 = [0 1 1;
      0 0 1;
      0 0 0];      
correcttype1=ones(1,7)-1; % component
correcttype2=ones(1,3); % factor

modetype1=ones(1,7)*2; % 1 = mode A, 2 = mode B 
modetype2=[1 1 1];

scheme = 3;

ind_sign1=[];
ind_sign2=[];

N_Boot = 0;
Max_iter = 500;              % maximum number of iterations
Min_limit = 0.00001;            % convergence tolerance
Flag_Parallel = false; %  1 = centroid, 2 = factorial, 3 = path weighting

Results = HigherOrderPLSPM(z0, W01,W02,B0,modetype1,modetype2,correcttype1,correcttype2,scheme,ind_sign1,ind_sign2,N_Boot,Max_iter,Min_limit,Flag_Parallel);
INI=Results.INI;
INI.Converge
INI.iter1
INI.iter2
INI.W1
INI.W2
INI.C((W01==1)')
INI.B

%% Example 3) 2nd-order Component with 1st-order Factors

z0 = readtable('Data_Zahid_et_al(2024).xlsx');
z0 = z0{:,:};
% model specification
W01 = blkdiag(ones(5,1),ones(4,1),ones(4,1),...
              ones(4,1),ones(4,1),ones(4,1),...
              ones(5,1));
W02 = blkdiag(ones(3,1),ones(3,1),ones(1,1));
B0 = [0 1 1;
      0 0 1;
      0 0 0];      
correcttype1=ones(1,7); % factor
correcttype2=zeros(1,3); % component

modetype1=ones(1,7); % 1 = mode A, 2 = mode B 
modetype2=[1 1 1]*2;

scheme = 3;

ind_sign1=[];
ind_sign2=[];

N_Boot = 0;
Max_iter = 500;              % maximum number of iterations
Min_limit = 0.00001;            % convergence tolerance
Flag_Parallel = false; %  1 = centroid, 2 = factorial, 3 = path weighting

Results= HigherOrderPLSPM(z0, W01,W02,B0,modetype1,modetype2,correcttype1,correcttype2,scheme,ind_sign1,ind_sign2,N_Boot,Max_iter,Min_limit,Flag_Parallel);
INI=Results.INI;
INI.Converge
INI.iter1
INI.iter2
INI.W1
INI.W2
INI.C((W01==1)')
INI.B


%% Example 4) 2nd order Factors with 1st order Factors

z0 = readtable('Data_Zahid_et_al(2024).xlsx');
z0 = z0{:,:};
% model specification
W01 = blkdiag(ones(5,1),ones(4,1),ones(4,1),...
              ones(4,1),ones(4,1),ones(4,1),...
              ones(5,1));
W02 = blkdiag(ones(3,1),ones(3,1),ones(1,1));
B0 = [0 1 1;
      0 0 1;
      0 0 0];      
correcttype1=ones(1,7); % factor
correcttype2=ones(1,3); % factor 

modetype1=ones(1,7); % 1 = mode A, 2 = mode B 
modetype2=[1 1 1];

scheme = 3;

ind_sign1=[];
ind_sign2=[];

N_Boot = 0;
Max_iter = 500;              % maximum number of iterations
Min_limit = 0.00001;            % convergence tolerance
Flag_Parallel = false; %  1 = centroid, 2 = factorial, 3 = path weighting

Results= HigherOrderPLSPM(z0, W01,W02,B0,modetype1,modetype2,correcttype1,correcttype2,scheme,ind_sign1,ind_sign2,N_Boot,Max_iter,Min_limit,Flag_Parallel);
INI=Results.INI;
INI
INI.Converge
INI.iter1
INI.iter2
INI.W1
INI.W2
INI.C((W01==1)')
INI.B
