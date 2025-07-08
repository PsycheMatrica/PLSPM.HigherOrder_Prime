function [est_W1,est_W2,est_C,est_B,it1,it2,Flag_Converge,Gamma1,Gamma2,Cov_G1,Cov_G2] = ...
                 ALS_PLSPM_HigherOrder(z0,W01,W02,B01,B02,...
                                      modetype1,modetype2,correct_type1,correct_type_tp,correct_type2_new,scheme,...
                                      ind_sign1,ind_sign2, ...
                                      itmax,ceps,...
                                      N,J,P1,P2)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ALS_HigherOrderPLSPM() - MATLAB function to implement the ALS algorithm %
    %               for Partial Least Squares Path Modeling (PLSPM) with      %
    %               Higher-order Constructs.                                  %
    % Author: Gyeongcheol Cho                                                 % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [est_W1,est_C,~,Cov_G1 ,it1,Flag_Converge1,Gamma1,Rho_A] = ALS_PLSPM_Basic(z0,W01,B01,modetype1,scheme,correct_type1,ind_sign1,itmax,ceps,N,J,P1);
    [est_W2,est_C2,est_B2,Cov_G2,it2,Flag_Converge2,Gamma2,~] = ALS_PLSPM_Basic(Gamma1,W02,B02,modetype2,scheme,correct_type_tp,ind_sign2,itmax,ceps,N,P1,P2);
    if (sum(correct_type1,2)+sum(correct_type2_new,2))>0
        [est_W2,est_C2, est_B2, Cov_G2, ~] = Dijktra_correction(Gamma1, W02, B02, est_W2, est_C2, Gamma2, correct_type2_new,Cov_G1,Rho_A);
    end
    est_B=[zeros(P1,(P1+P2));[est_C2,est_B2]];
    Flag_Converge=Flag_Converge1 && Flag_Converge2;
end