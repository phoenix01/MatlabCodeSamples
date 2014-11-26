%% This function will generate dirchlet distribution from random samples
% Input- Alpha, and Number of data points 
% Output- Proportion matrix 
% Author- Piyush Khopkar
%% 
function dircheltDistribution = generateDirechletDistribution(alpha,Number)
    D = length(alpha);
    
    % Samples from gamma with shape parameter = repmat(alpha,N,1) and scale paramter = 1
    p = gamrnd(repmat(alpha,Number,1),1,Number,D);     
    
    % Normalization
    dircheltDistribution = p ./ repmat(sum(p,2),1,D);                          
end
% end of function




