function U=U_update(X,P,E,U,V, m)
%% Appendix- SUBSUME-V
% Author- Piyush Khopkar
% This function updates the fuzzy membership matrix (CXN).
% Input:
%   - X: Pixel points (NXd matrix).
%   - P:  Cell of C abundance matrices. One (NXM) matrix per cluster.
%   - E:  Cell of C endmembers matrices. One (MXd) matrix per cluster.
%   - U: the fuzzy membership matrix (CXN).
%   - m: Fuzzifier.
%   - EPS: small positive constant.
% Output:
%   - U: the fuzzy membership matrix (CXN).
%% --------------------------------------------------------------------------
N=size(X,1);
C=size(U,1);

EPS=1e-40;
Dist = zeros(C,N);
for i=1:C
    Y = repmat((V(i,:).^2), [N,1]).*(X - P{i}*E{i}).^2;
    Dist(i,:) = sum(Y,2);
end
Dist_1=1./(((Dist+EPS).^(1/(m-1)))+EPS);

S = sum(Dist_1,1);
U = (Dist_1)./repmat(S, [C,1]);
% end
