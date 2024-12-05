function [est_W1,est_W2,est_C,est_B,it1,it2,Flag_Converge,Gamma1,Gamma2] = ...
                 ALS_HigherOrderPLSPM(z0,W01,W02,B01,B02,...
                                      modetype1,modetype2,scheme,ind_sign1,ind_sign2, ...
                                      itmax,ceps,...
                                      N,J,P1,P2)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ALS_HigherOrderPLSPM() - MATLAB function to implement the ALS algorithm %
    %               for Partial Least Squares Path Modeling (PLSPM) with      %
    %               Higher-order Constructs.                                  %
    % Author: Gyeongcheol Cho                                                 % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    z = zscore(z0)/sqrt(N-1);  
    S=z'*z;
    W1 = double(W01);
    W2 = double(W02);
    B1 = double(B01);
    B2 = double(B02);
  
    W1 = W1./repmat(sqrt(diag(W1'*S*W1))',J,1);    % same starts as in GSCA
    
    Gamma1 = zeros(N,P1);                     
    for p1 = 1:P1
        z_j = z(:,W01(:,p1));
        Gamma1(:,p1) = z_j*W1(W01(:,p1),p1);
        Gamma1(:,p1) = Gamma1(:,p1)/norm(Gamma1(:,p1));
    end
    if scheme == 1              %centroid scheme
       corLV = corrcoef(Gamma1);
       for p1 = 1:P1
           bindex = find(B01(:,p1));   % DV 
          if ~isempty(bindex)
             B1(bindex,p1) = sign(corLV(bindex,p1));  
          end
       end 
       for p1 = 1:P1
          bindex = find(B01(p1,:));   % IV 
          if ~isempty(bindex)
             B1(bindex,p1) = sign(corLV(p1,bindex));
          end
       end
    elseif scheme == 2         % factorial scheme
       corLV = corrcoef(Gamma1);
       for p1 = 1:P1
           bindex = find(B01(:,p1));   % DV 
          if ~isempty(bindex)
             B1(bindex,p1) = corLV(bindex,p1);  
          end
       end 
       for p1 = 1:P1
          bindex = find(B01(p1,:));   % IV 
         if ~isempty(bindex)
             B1(bindex,p1) = corLV(p1,bindex);
          end
        end
    elseif scheme == 3       % path weighting scheme
       for p1 = 1:P1
           bindex = find(B01(:,p1));   % DV
           if ~isempty(bindex)
              gp = Gamma1(:,bindex);
              B1(bindex,p1) = (gp'*gp)\gp'*Gamma1(:,p1);  
           end
       end    
       corLV = corrcoef(Gamma1);
       for p1 = 1:P1
           bindex = find(B01(p1,:));   % IV
           if ~isempty(bindex)
               B1(bindex,p1) = corLV(p1,bindex);
           end
       end
    end
    
    Sig_CV=Gamma1'*Gamma1;
    W2 = W2./repmat(sqrt(diag(W2'*Sig_CV*W2))',P1,1);   
    
    Gamma2 = zeros(N,P2);
    for p2 = 1:P2
        Gamma1_p1 = Gamma1(:,W02(:,p2));
        Gamma2(:,p2) = Gamma1_p1*W2(W02(:,p2),p2);
        Gamma2(:,p2) = Gamma2(:,p2)/norm(Gamma2(:,p2));
    end
    
     
    if scheme == 1              %centroid scheme
           corLV = corrcoef(Gamma2);
           for p2 = 1:P2
               bindex = find(B02(:,p2));   % DV 
              if ~isempty(bindex)
                 B2(bindex,p2) = sign(corLV(bindex,p2));  
              end
           end 
           for p2 = 1:P2
              bindex = find(B02(p2,:));   % IV 
              if ~isempty(bindex)
                 B2(bindex,p2) = sign(corLV(p2,bindex));
              end
           end
     elseif scheme == 2         % factorial scheme
           corLV = corrcoef(Gamma2);
           for p2 = 1:P2
               bindex = find(B02(:,p2));   % DV 
              if ~isempty(bindex)
                 B2(bindex,p2) = corLV(bindex,p2);  
              end
           end 
           for p2 = 1:P2
              bindex = find(B02(p2,:));   % IV 
             if ~isempty(bindex)
                 B2(bindex,p2) = corLV(p2,bindex);
              end
            end
     elseif scheme == 3       % path weighting scheme
           for p2 = 1:P2
               bindex = find(B02(:,p2));   % DV
               if ~isempty(bindex)
                  gp = Gamma2(:,bindex);
                  B2(bindex,p2) = (gp'*gp)\gp'*Gamma2(:,p2);  
               end
           end    
           corLV = corrcoef(Gamma2);
           for p2 = 1:P2
               bindex = find(B02(p2,:));   % IV
               if ~isempty(bindex)
                   B2(bindex,p2) = corLV(p2,bindex);
               end
           end
    end
    [est_W1,est_C,~,it1,Flag_Converge1,Gamma1] = ALS_BasicPLSPM(z,Gamma1,W01,B01,W1,B1,modetype1,scheme,ind_sign1,itmax,ceps,N,J,P1);
    [est_W2,est_C2,est_B2,it2,Flag_Converge2,Gamma2] = ALS_BasicPLSPM(Gamma1,Gamma2,W02,B02,W2,B2,modetype2,scheme,ind_sign2,itmax,ceps,N,P1,P2);
    est_B=[zeros(P1,(P1+P2));[est_C2,est_B2]];
    Flag_Converge=Flag_Converge1 && Flag_Converge2;
end