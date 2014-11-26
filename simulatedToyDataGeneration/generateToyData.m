function generateToyData(option)
% Function to generate toy data
% Input parameters- 'Option'        
%             1- Toy data in traingular form
%             2- Toy data with no proportions
%             3- Toy data with proportions from Dirchlet Distribution
% Defualt option- 
% Output - Data saved in Data.m file
% Author- Piyush Khopkar
%%

% Default option = 3
if (nargin<1)
    option = 3;
end

%% Generate Toy Data (Traingular form)
if (option == 1)
    
    % Mean and variance
    mu = [0.5 0.5];
    sigma = [0.01 0 ; 0 0.01];
    
    X = mvnrnd(mu,sigma,100);
    
    % Specify vertices for traingle
    vertices = [0.005 0.005; 0.505 0.995; 0.995 0.005];
    
    % Plot data
        
    figure(1);
    scatter(vertices(:,1), vertices(:,2),'b','filled'); 
    hold on;
    plot([vertices(:,1); vertices(1,1)],[vertices(:,2); vertices(1,2)]);
    plot(X(:,1), X(:,2),'+');
    hold off;
    
    % Set Xlimits and Ylimits
    xlim([-0.5 1.5]); ylim([-0.5 1.5]);
    
    % X label and Y label
    xlabel('Band 1'); ylabel('Band 2'); 
    
    % Title
    title('Simulated traingular toy data');
    
    % Save data
    save('DataSet_1.mat', 'X');
   
elseif (option == 2)
%% Generate Toy data with two clusters and 3 features

    % Generate cluster 1
    x1 = rand(100,2)+1;         
    x2 = rand(100,2)+5;         
    x11 = cat(1,x1,x2);        
    
    % Generate irrelevant feature x3
    x3 = randn(200,1);  
    
    % Make cluster 1 data
    X1 = cat(2,x11,x3);       

    % Generate cluster 2
    x1 = rand(100,2)+9;
    x2 = rand(100,2)+12;
    x11 = cat(1,x1,x2);

    % Add irrelevant feature X3 and make cluster 2
    X2 = cat(2,x11,x3);        

    % Concatenate cluster 1 and cluster 2 
    X = cat(1,X1,X2); 
    
    % Plot data
    figure(1);
    scatter3(X1(:,1),X1(:,2),X1(:,3),30,'filled','blue');
    hold on;
    scatter3(X2(:,1),X2(:,2),X2(:,3),30,'filled','red');
    hold off;
    
    title('Non-convex toy data');
    legend('Cluster 1','Cluster 2');
    
    % Save data
    save('DataSet_2.mat','X');
else
%%  Generate Toy data with Dirchlet Distributed proportions 

    % Generate cluster 1
    x1 = rand(100,2)+1;         
    x2 = rand(100,2)+5;         
    x11 = cat(1,x1,x2);        

    % Generate irrelevant feature
    x3 = randn(200,1);                                                      
    X1 = cat(2,x11,x3);   
    
    % Generate proportions from Dirchlet Distribution
    proportion1 = generateDirechletDistribution([1 1 1],200);               
    X1 = proportion1.*X1;

    % Generate cluster 2
    x1 = rand(100,2)+9;
    x2 = rand(100,2)+12;
    x11 = cat(1,x1,x2);

    % Add irrelevant feature X3 with relevant one
    X2 = cat(2,x11,x3);   
    
    % Generate proportions from Dirchlet Distribution
    proportion2 = generateDirechletDistribution([1 1 1],200);               
    X2 = proportion2.*X2;

    % Concatenate cluster 1 and cluster 2 
    X = cat(1,X1,X2);      
    
    % Plot data
    hold off;
    figure(1);
    scatter3(X1(:,1),X1(:,2),X1(:,3),30,'filled','blue');
    hold on
    scatter3(X2(:,1),X2(:,2),X2(:,3),30,'filled','red');
    hold off
    title('Non-convex toy data');
    legend('Cluster 1','Cluster 2');

    figure(2)
    subplot(1,2,1);
    scatter(X1(:,1),X1(:,3),'red');
    title('Feature 1 and Feature 3 in cluster 1');

    subplot(1,2,2)
    scatter(X2(:,1),X2(:,3),'blue');
    title('Feature 1 and Feature 3 in cluster 2');

    save('DataSet_3.mat','X');
end 
% end of function