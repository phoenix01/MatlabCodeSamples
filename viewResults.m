function [PlotsFileName] = viewResults(Image, P, E, U, V, parameters)
%% This function will plot the resuts and save the it in corresponding directories
% Author- Piyush Khopkar
% Input- Image data cube
%      - Proportions
%      - Endmembers 
%      - Memberships
%      - Parameters
% Output- Plots with their file names
%% Set flags for toy data and real data
    ToyData = 0;
    RealData = 1;
    %% Flags- Plot
    savePlots = 1;                      % Flag to save the plots in 'jpg'

    if (RealData)
        ScatterFlag = 0;                % View Scatter Plot
        subsampleValue = 10;            % Interval for plotting the data

        ProportionMaps = 1;             % View Prop Maps
        MembershipMaps = 1;             % View Membership
        ProductMaps = 1;                % View Product of Prop and Membership
        EndmembersPlot = 1;             % View partition specific endmembers
        Weights = 1;                    % View partition specific weights
        WeightedEndmembers = 1;         % View weighted endmembers
        WeightedEndmembersVsTrue = 0;   % View weighted vs. true endmembers
        EstimatedEndmembersVsTrue = 0;  % View unweighted vs. true endmembers 
    elseif (ToyData)
        ScatterFlag = 0;                % View Scatter Plot
        subsampleValue = 10;            % Interval for plotting the data

        ProportionMaps = 0;             % View Prop Maps
        MembershipMaps = 0;             % View Membership
        ProductMaps = 0;                % View Product of Prop and Membership
        EndmembersPlot = 1;             % View partition specific endmembers
        Weights = 1;                    % View partition specific weights
        WeightedEndmembers = 1;         % View weighted endmembers
        WeightedEndmembersVsTrue = 1;   % View weighted vs. true endmembers
        EstimatedEndmembersVsTrue = 1;  % View unweighted vs. true endmembers 
    end

    if(savePlots)
                                        % create cell array for saving figure names
        aaa = cell(1,parameters.C);     % Propotion
        bbb = cell(1);                  % Membership
        ccc = cell(1,parameters.C);     % Product
        ddd = cell(1,parameters.C);     % Endmembers
        eee = cell(1,parameters.C);     % Weights
        fff = cell(1,parameters.C);     % Weighted Endmembers
        ggg = cell(1,parameters.C);     % Weighted Endmembers vs True
        hhh = cell(1,parameters.C);     % Unweighted Endmembers vs True
    end

    if(ScatterFlag)
        % Scatter plot of Memberships
        if(size(Image,3) == 2)
            [IList] = reshapeImage(Image)';
            for i = 1:length(E)
                figure(100+i);  
                hold off;
                scatter(IList(1:subsampleValue:end,1), IList(1:subsampleValue:end,2), 30, U(i,1:subsampleValue:end), 'filled');
                hold on;
                scatter(E{i}(:,1), E{i}(:,2), 100, 'k', 'filled'); title(['Scatter Plot of Partition', (num2str(i))]);
            end
        elseif(size(Image,3) == 3)
            [IList] = reshapeImage(Image)';
            for i = 1:length(E)
                figure(100+i);  
                hold off;
                scatter3(IList(1:subsampleValue:end,1), IList(1:subsampleValue:end,2), IList(1:subsampleValue:end,3), 30, U(i,1:subsampleValue:end), 'filled');
                hold on;
                scatter3(E{i}(:,1), E{i}(:,2), E{i}(:,3), 100, 'k', 'filled'); title(['Scatter Plot of Partition', (num2str(i))]);
            end
                figure(600);  
                hold off;
                [zz, ll] = max(U(:,1:subsampleValue:end), [], 1);
                scatter3(IList(1:subsampleValue:end,1), IList(1:subsampleValue:end,2), IList(1:subsampleValue:end,3), 30, zz, 'filled');
        else
            [IList] = reshapeImage(Image)';
            m = mean(IList);
            [t, PCAresults] = princomp(IList);
            IList = PCAresults(:, 1:3);
            for i = 1:length(E)
                EE = (E{i} - repmat(m, [size(E{i},1), 1]))*t;
                figure(100+i); 
                hold off;
                scatter3(IList(1:subsampleValue:end,1), IList(1:subsampleValue:end,2), IList(1:subsampleValue:end,3), 30, U(i,1:subsampleValue:end),'filled');
                hold on;
                scatter3(EE(:,1), EE(:,2), EE(:,3), 100, 'k', 'filled'); title(['Scatter Plot of Partition', (num2str(i))]);
            end
        end

    end

    % Proportion maps
    if(ProportionMaps)
        for i = 1:length(P)
            figure(200+i);
            for j = 1:size(P{i},2)
                subplot(ceil(size(P{i},2)/2), 3, j);   
                PP = reshape(P{i}(:,j), [size(Image,1), size(Image,2)]);
                imagesc(PP, [0 1]); title(['Proportion Map of Partition', (num2str(i)), ' & Endmember ', (num2str(j))]);
            end
            if(savePlots)
                % save image
                strA = ['Proportion' num2str(i) '.jpg'];
                saveas(figure(200+i),strA);
                aaa{i} = strA;
            end
        end
    end
    
    % Memberships maps
    if(MembershipMaps)
        figure(300); hold off;
        for i = 1:size(U,1);
            subplot(ceil(size(U,1)/2), 2, i);
            MM = reshape(U(i,:), [size(Image,1), size(Image,2)]);
            imagesc(MM, [0 1]);  title(['Membership Map of Partition', (num2str(i))]);
        end
         if(savePlots)
            % save image
            strB = ['Membership.jpg'];
            saveas(figure(300),strB);
            bbb =strB;
        end
    end

    % Product maps
    if(ProductMaps)
        for i = 1:length(P)
            figure(500+i); hold off;
            MM = reshape(U(i,:), [size(Image,1), size(Image,2)]);
            for j = 1:size(P{i},2)
                subplot(ceil(size(P{i},2)/2), 3, j);
                PP = reshape(P{i}(:,j), [size(Image,1), size(Image,2)]);
                imagesc(PP.*MM, [0 1]); title(['Product Map of Partition', (num2str(i)), ' & Endmember ', (num2str(j))]);
            end
            if(savePlots)
                % save image
                strC = ['Product' num2str(i) '.jpg'];
                saveas(figure(500+i),strC);
                ccc{i} = strC;
            end
        end
    end
    
    % Endmember plots
    if(EndmembersPlot)
        for p = 1:parameters.C
            E1 = E{p};
            figure(600+p);
            plot(E1','DisplayName', 'Endmembers');
            xlabel('Wavelength'); ylabel('Reflectance');
            title(['Endmembers in partition ', (num2str(p))]);
            if(savePlots)
                % save image
                strD = ['Endmembers' num2str(p) '.jpg'];
                saveas(figure(600+p),strD);
                ddd{p} = strD;
            end
        end
    end
    
    % Weights
    if(Weights)
        weights = V';
        for p = 1:parameters.C
            figure(700+p);
            plot(weights(:,p)','DisplayName', 'Weights');
            xlabel('Wavelength'); ylabel('Weights');
            title(['Weights in partition ', (num2str(p))]);
            if(savePlots)
                % save image
                strE = ['Weights' num2str(p) '.jpg'];
                saveas(figure(700+p),strE);
                eee{p} = strE;
            end
        end  
    end
    
    % Weighted Endmembers
    if(WeightedEndmembers)
       weights = V';
       for k = 1:parameters.C
            weightedE = repmat(weights(:,k), [1,parameters.M]).*E{k}';
            figure(800+k);
            plot(weightedE,'DisplayName','WeightedEndmembers');
            xlabel('Wavelength'); ylabel('Reflectance');
            title(['Weighted Endmembers in partition ', (num2str(k))]);
            if(savePlots)
                % save image
                strF = ['WgtdEndmem' num2str(k) '.jpg'];
                saveas(figure(800+k),strF);
                fff{k} = strF;
            end
       end
    end
    
    % Weighted endmembers and true endmembers
    if(WeightedEndmembersVsTrue)
       weights = V';
       End = {Etrue(:,1:2),Etrue(:,3:4),Etrue(:,5:6)};
       for k = 1:parameters.C
            weightedE = repmat(weights(:,k), [1,parameters.M]).*E{k}';
            figure(900+k);
            plot(weightedE);
            hold on;
            plot(End{k},'--');
            hold off;
            xlabel('Wavelength'); ylabel('Reflectance');
            title(['Weighted Endmembers vs. True Endmembers in partition ', (num2str(k))]);
            if(savePlots)
                % save image
                strG = ['WgtdEndVsTrue' num2str(k) '.jpg'];
                saveas(figure(900+k),strG);
                ggg{k} = strG;
            end
       end
    end
    
    % Estimated endmember and true endmembers
    if(EstimatedEndmembersVsTrue)
       End = {Etrue(:,1:2),Etrue(:,3:4),Etrue(:,5:6)};
       for k = 1:parameters.C
            E1 = E{k}';
            figure(1001+k);
            plot(E1);
            hold on;
            plot(End{k},'--');
            hold off;
            xlabel('Wavelength'); ylabel('Reflectance');
            title(['Estimated Endmembers vs. True Endmembers in partition ', (num2str(k))]);
            if(savePlots)
                % save image
                strH = ['EstEndVsTrue' num2str(k) '.jpg'];
                saveas(figure(1001+k),strH);
                hhh{k} = strH;
            end
       end
    end
    clear weights p;
    
    % Save plots
    if(savePlots)
        if(ToyData)
            PlotsFileName = [ddd,eee,fff,ggg,hhh];
        elseif(RealData)
            PlotsFileName = [aaa,bbb,ccc,ddd,eee,fff];
        end
    else
        PlotsFileName = ['savePlots Flag not set'];
    end

    function [IList] = reshapeImage(Image)
        IList = reshape(shiftdim(Image(:,:,:),2),size(Image,3),size(Image,1)*size(Image,2));
    end

end
