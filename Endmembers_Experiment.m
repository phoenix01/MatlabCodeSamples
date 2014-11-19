%% Experiments -Spectral Angle Distance and Euclidean Distance
% Author- Piyush Khopkar
%  INPUT   - X (Data)
%          - Etrue (True Endmembers) 
%          - Eest (Estimated Endmembers)
%  OUTPUT  - SAD , Eucledian Distance
%% SAD and Euclidean distance : Endmembers
function [SAD ,Endmembers_EucDistance] = Endmembers_Experiment(Etrue,Eest)

    % SAD Calculation and Euclidean Distance
    SAD = zeros(size(Etrue,2),1);
    Endmembers_EucDistance = zeros(size(Etrue,2),1);
    for j= 1:size(Etrue,2)
        SAD(j) = acos(dot(Etrue(:,j),Eest(:,j))./(norm(Etrue(:,j))*norm(Eest(:,j))));
        Endmembers_EucDistance(j) = (norm(Etrue(:,j) - Eest(:,j))).^2;
    end
end
%end