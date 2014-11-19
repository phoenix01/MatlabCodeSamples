% This function will update the value of delta_cd 
% Appendix: Modified obejcetive function- Adding BST term from BSPICE
%%
% Author- Piyush Khopkar
% Input  : X, E, U P and parameters
%        : tunableParam < 1
% Output : Delta_cd
%%
function [Delta_cd] = detlaUpdate(X, E, U, P, parameters)
C = parameters.C;
[N, D] = size(X);
no_Endmembers = size(P{1},2);
tunableParam = parameters.tunableParam;
    for c = 1:C
        res = X - P{c}*E{c};
        res = res.*res;

        t = 2*(sum(repmat((U(c,:).^parameters.m)', [1, D]).*res));              % equation 12 - denominator

        % Update delta_{cd}
        tmp = repmat(U(c,:)',[1,no_Endmembers]).*P{c};                          % equation 3 - membership * proportions
        for e= 1:no_Endmembers                                                   
            tmpE1 = repmat(E{c}(e,:), [N,1]);
            t1  = (((X - tmpE1).^2));                                           % Equation 3- difference of X and e_cmd
            tmpMul = sum(repmat(tmp(:,e),[1,D]).*t1);                           % Equation 3 - sum_{n=1}^N u_{cn}p_{cn}(x_{nd}-e_{cmd})^2
            t2(e,:) = tmpMul;
        end 
        sumU = sum(U(c,:));
        delta_cd_num = tunableParam*(sum((t2./sumU),1) + 1);                    % equation 3 - numerator

        u_ocd = (sum(repmat((U(c,:))', [1, D]).*X))./ sumU;                     % equation 4  - u_0cd 
        delta_cd_deno = sum((E{c}- repmat(u_ocd,[no_Endmembers,1])).^2)+1;      % equation 3 - denominator

        Delta_cd(c,:) = delta_cd_num./delta_cd_deno;                            % Delta-cd
    end
end
% end
