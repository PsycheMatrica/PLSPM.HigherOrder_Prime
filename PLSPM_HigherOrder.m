function Results = PLSPM_HigherOrder(z0, W01,W02,B02,mode_type1,mode_type2,correct_type1,correct_type2,scheme,ind_sign1,ind_sign2,N_Boot,Max_iter,Min_limit,Flag_Parallel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLSPM_HigherOrder() - MATLAB function to perform Partial Least Sqaures   %
%                      Path Modeling (PLSPM) with higher-order constructs %
% Author: Gyeongcheol Cho & Heungsun Hwang                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input arguments:                                                        %
%   Data = an N by J matrix of scores for N individuals on J indicators   %
%   W01 = a J by P1 matrix of weight parameters for indicators            %
%   W02 = a P1 by P2 matrix of weight parameters for 1st-order constructs %
%   B02 = a P2 by P2 matrix of path coefficients between 2nd-order        %
%          constructs                                                     %
%   mode_type1 = a vector of length P1 indicating the mode of each        %
%                1st-order construct (1 = mode A, 2 = mode B)             %
%   mode_type2 = a vector of length P1 indicating the mode of each        %
%                2nd-order construct (1 = mode A, 2 = mode B)             %
%   correct_type1 = a vector of length P1 indicating the type of each     %
%                   1st-order construct (0 = component, 1 = factor)       %
%   correct_type2 = a vector of length P2 indicating the type of each     %
%                   2nd-order construct (0 = component, 1 = factor)       %
%   scheme = an integer indicating the scheme for updating inner weights  % 
%              (1 = centroid, 2 = factorial, 3 = path weighting)          %
%   ind_sign1 = a vector of length P1 representing the sign-fixing        %
%               indicator of each 1st-order construct                     %
%   ind_sign2 = a vector of length P2 representing the sign-fixing        % 
%               indicator of each 2nd-order construct                     %
%   N_Boot = Integer representing the number of bootstrap samples for     %
%            calculating standard errors (SE) and 95% confidence          %
%            intervals (CI)                                               %
%   Max_iter = Maximum number of iterations for the Alternating Least     % 
%              Squares (ALS) algorithm                                    %
%   Min_limit = Tolerance level for ALS algorithm                         %
%   Flag_Parallel = Logical value to determine whether to use parallel    %
%                   computing for bootstrapping                           %
% Output arguments:                                                       %
%   Results: Structure array containing (1) results from the original     %
%       sample (INI); (2) summary tables with standard errors and         %
%       confidence intervals (TABLE); and (3) bootstrap estimates for     %
%       various parameter sets (ETC).                                     %    
%   .INI: Structure array containing goodness-of-fit values, R-squared    % 
%        values, and matrices parameter estimates                         %
%     .iter = Number of iterations for the ALS algorithm                  %
%     .W1: a J by P1 matrix of weight estimates for indicators            %
%     .W2: a P1 by P2 matrix of weight estimates for 1st-order constructs %
%     .C: a P1 by J matrix of loading estimates for indicators            %
%     .B: a P by P matrix of path coefficient estimates                   %
%     .CVscore1: a N by P1 score matrix for 1st-order constructs          %
%     .CVscore2: a N by P2 score matrix for 2nd-order constructs          %
%  .TABLE: Structure array containing tables of parameter estimates, their%
%         SEs, 95% CIs,and other statistics                               %
%     .W1: Table for weight estimates for indicators                      %
%     .W2: Table for weight estimates for 1st-order constructs            %
%     .C: Table for loading estimates for indicators                      %
%     .B: Table for path coefficients estimates                           %
%  .ETC: Structure array including bootstrapped parameter estmates        %
%     .W1_Boot: Matrix of bootstrapped weight estimates                   %
%     .W2_Boot: Matrix of bootstrapped weight estimates                   %
%     .C_Boot: Matrix of bootstrapped loading estimates                   %
%     .B_Boot: Matrix of bootstrapped path coefficient estimates          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note:                                                                   %
% 1. This function utilizes BasicPLSPM package v1.4.1 (Cho & Hwang, 2024) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[J,P1] = size(W01);
P2 = size(W02,2);  
N = size(z0,1);
%% Initialization 
W01=W01~=0; Nw1=sum(sum(W01,1),2);
W02=W02~=0; Nw2=sum(sum(W02,1),2);
C0=W01';   Nc=sum(sum(C0,1),2);
C02=W02';   Nc2=sum(sum(C02,1),2);
B02=B02~=0; Nb2=sum(sum(B02,1),2);
B0=[false(P1,P1+P2);[C02,B02]]; Nb=Nc2+Nb2; 
%B01=(W02*B02*W02')~=0;
B01=triu(ones(P1,P1),1)~=0;
ind_Bdep=sum(B02,1)>0; Py = sum(ind_Bdep,2);
if size(ind_sign1,1)==0; [~,ind_sign1]=max(W01); end
if size(ind_sign2,1)==0; [~,ind_sign2]=max(W02); end
    
correct_type_tp=zeros(1,P2);
correct_type2_new=correct_type2;
for p2=1:P2
    p1=ind_sign2(p2);
    if correct_type1(1,p1)==1
        if correct_type2(1,p2)==0; correct_type2_new(p2)=2; 
        elseif correct_type2(p2)==1; correct_type2_new(p2)=3;
        end
    end
end
[est_W1,est_W2,est_C,est_B,it1,it2,Converge,Gamma1,Gamma2,Cov_CV1,Cov_CV2] = ...
   ALS_PLSPM_HigherOrder(z0,W01,W02,B01,B02,...
                        mode_type1,mode_type2,correct_type1,correct_type_tp,correct_type2_new,scheme, ...
                        ind_sign1,ind_sign2,...
                        Max_iter,Min_limit,N,J,P1,P2);
INI.iter1 = it1;
INI.iter2 = it2;
INI.Converge=Converge;
INI.W1 = est_W1;
INI.W2 = est_W2;
INI.C = est_C;
INI.B = est_B;
INI.Cov_CV1 = Cov_CV1;
INI.Cov_CV2 = Cov_CV2;
INI.CVscore1 = Gamma1*sqrt(N);
INI.CVscore2 = Gamma2*sqrt(N);

if N_Boot<100
   TABLE.W1=[est_W1(W01),NaN(Nw1,5)];
   TABLE.W2=[est_W2(W02),NaN(Nw2,5)];
   TABLE.C=[est_C(C0),NaN(Nc,5)];
   TABLE.B=[est_B(B0),NaN(Nb,5)];
   ETC.W1_Boot=[];
   ETC.W2_Boot=[];
   ETC.C_Boot=[];
   ETC.B_Boot=[];  
else
   W1_Boot=zeros(Nw1,N_Boot);
   W2_Boot=zeros(Nw2,N_Boot);
   C_Boot=zeros(Nc,N_Boot);
   B_Boot=zeros(Nb,N_Boot);
   if Flag_Parallel
       parfor b=1:N_Boot
           [Z_ib,~]=GC_Boot(z0);
            [W1_b,W2_b,C_b,B_b,~,~,~,~,~,~,~] = ...
               ALS_PLSPM_HigherOrder(Z_ib,W01,W02,B01,B02,...
                                    mode_type1,mode_type2,correct_type1,correct_type_tp,correct_type2_new,scheme, ...
                                    ind_sign1,ind_sign2,...
                                    Max_iter,Min_limit,N,J,P1,P2);    
           W1_Boot(:,b)=W1_b(W01);
           W2_Boot(:,b)=W2_b(W02);
           C_Boot(:,b)=C_b(C0);        
           B_Boot(:,b)=B_b(B0);
       end
   else
       for b=1:N_Boot
           [Z_ib,~]=GC_Boot(z0);
           if rem(b,100)==1; fprintf("Bootstrapping %d\n", b); end
            [W1_b,W2_b,C_b,B_b,~,~,~,~,~,~,~] = ...
               ALS_PLSPM_HigherOrder(Z_ib,W01,W02,B01,B02,...
                                    mode_type1,mode_type2,correct_type1,correct_type_tp,correct_type2_new,scheme, ...
                                    ind_sign1,ind_sign2,...
                                    Max_iter,Min_limit,N,J,P1,P2);
           W1_Boot(:,b)=W1_b(W01);
           W2_Boot(:,b)=W2_b(W02);  
           C_Boot(:,b)=C_b(C0);       
           B_Boot(:,b)=B_b(B0);
       end
   end
% (5) Calculation of statistics
   alpha=.05;
   CI=[alpha/2,alpha,1-alpha,1-(alpha/2)];
   loc_CI=round(CI*(N_Boot-1))+1; % .025 .05 .95 .975
% basic statistics for parameter
   TABLE.W1=para_stat(est_W1(W01),W1_Boot,loc_CI);
   TABLE.W2=para_stat(est_W2(W02),W2_Boot,loc_CI);
   TABLE.C=para_stat(est_C(C0),C_Boot,loc_CI); 
   if Py>0; TABLE.B=para_stat(est_B(B0),B_Boot,loc_CI); end
   ETC.W1_Boot=W1_Boot;
   ETC.W2_Boot=W2_Boot;
   ETC.C_Boot=C_Boot;
   if Py>0; ETC.B_Boot=B_Boot; end
end
Results.INI=INI;
Results.TABLE=TABLE;
Results.ETC=ETC;
end
function Table=para_stat(est_mt,boot_mt,CI_mp)
   boot_mt=sort(boot_mt,2);
   SE=std(boot_mt,0,2);
   Table=[est_mt,SE,boot_mt(:,CI_mp(1,1)),boot_mt(:,CI_mp(1,4))]; 
end
function [in_sample,out_sample,index,N_oob]=GC_Boot(Data)
   N=size(Data,1); 
   index=ceil(N*rand(N,1));
   in_sample=Data(index,:); 
   index_oob=(1:N)'; index_oob(index)=[];
   out_sample=Data(index_oob,:);
   N_oob=length(index_oob);
end
