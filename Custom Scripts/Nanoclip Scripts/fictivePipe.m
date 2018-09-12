% Script for sequencing the fictive singing analysis
%This operates on the outputs of makeStimSnips.m; principle output (at this
%point) are plots of syllable trajectories through PCA space.

%Load the required snips packages from file
% 
% motherLoc = 'C:\Users\Tim\Desktop\Anestetized Singing Bird\Analyzed Data\2018-05-08 LW28\';
% toLoad = {'snipsPat11.mat', 'snipsPat12.mat','snipsPat15.mat', 'snipsPat16.mat','snipsPat17.mat', 'snipsPat18.mat','snipsPat19.mat', 'snipsPat20.mat'};
motherLoc = 'C:\Users\Tim\Desktop\Anestetized Singing Bird\Analyzed Data\2018-03-30 RY176\';
toLoad = {'snipsPat01.mat', 'snipsPat03.mat','snipsPat05.mat', 'snipsPat13.mat'};

%Define/clear structures
featCube = []; snipsCube = []; startsCube = []; filesCube = []; patternList = []; snipSet = []; zCube = [];

%Sequentially load files for processing
for i = 1:numel(toLoad)
    %Load from file
    load([motherLoc toLoad{i}]);
    
    numSyls = size(snips,1);
    patNum = toLoad{i}(9:10);
    patName = repmat(str2num(patNum), [numSyls, 1]);
    
    %Stack them in a matrix
    snipsCube = [snipsCube; snips];
    startsCube = [startsCube; starts];
    filesCube = [filesCube; files];
    patternList = [patternList; patName];
end

% %Calculate feature projections for each snip in the 
% for i = 1:size(snipsCube,1)
%     %extract features
%     S = featureBuilder(snipsCube(i,:));
% %     S = S(:,50:250);
%     S = S(:,95:225);
%     
%     %Add to the PCA list
%     snipSet = [snipSet, S];
% end
% 
% %Normalize (z-score) each of the features over all snips and timepoints
% snipSet(isnan(snipSet)) = 350;
% zSnips = zscore(snipSet');
%     
% %PCA analysis
% [coeff, score, latent, ~, explained] = pca(zSnips);
% 
% %Unwrap the scores matrix into syllables again
% snipSize = size(score,1)/size(snipsCube,1);
% sc = score';
% for i = 1:size(snipsCube,1)
%     starts = snipSize*(i-1)+1;
%     ends = snipSize*(i);
%     featCube(i,:,:) = sc(:, starts:ends);
% end
% 
% %Plotting
% t = get(0,'defaultAxesColorOrder');
% colors = [t; rand(23,3)]; %30 initial plotting colors to work with
% patternTypes = unique(patternList);
% 
% % %This is a plot of first 2 or 3 PCs for every syllable token
% % %Nice plot but a little busy
% % figure(668); clf
% % for i = 1:numel(patternTypes)
% %     %Determine which indices are for a given pattern
% %     idx = find(patternList==patternTypes(i));
% % 
% %     for j = idx'
% %         %Plot first 3 PCs in 3D space
% %         PC1 = smooth(squeeze(featCube(j,1,:))', 5, 'moving')';
% %         PC2 = smooth(squeeze(featCube(j,2,:))', 5, 'moving')';
% %         PC3 = smooth(squeeze(featCube(j,3,:))', 5, 'moving')';
% %         %plot3(PC1, PC2, PC3, 'Color', colors(i,:), 'Marker', '.', 'LineWidth', 0.25, 'MarkerSize', 6); hold on
% %         plot(PC1, PC2, 'Color', colors(i,:)); hold on
% %     end
% % end
% % axis tight
% % lims = axis; [az, el] = view;
% % set(gca, 'Box', 'off', 'TickDir', 'out')
% % set(gca, 'XTick', [-3,0,3],'YTick', [-3,0,3],'ZTick', [-2,0,2])
% % xlabel('PC1'); ylabel('PC2'); zlabel('PC3');
% % grid
% % 
% % %This is a plot of first 3 PCs averages over syllable types
% % %Very clear presentation
% % figure(67); clf
% % for i = 1:numel(patternTypes)
% %     %Determine which indices are for a given pattern
% %     idx = find(patternList==patternTypes(i));
% % 
% %     %Plot first 3 PCs in 3D space
% % %     PC1 = smooth(squeeze(mean(featCube(idx,1,:)))', 5, 'moving')';
% % %     PC2 = smooth(squeeze(mean(featCube(idx,2,:)))', 5, 'moving')';
% % %     PC3 = smooth(squeeze(mean(featCube(idx,3,:)))', 5, 'moving')';
% %     PC1 = squeeze(mean(featCube(idx,1,:)));
% %     PC2 = squeeze(mean(featCube(idx,2,:)));
% %     PC3 = squeeze(mean(featCube(idx,3,:)));
% %     plot3(PC1, PC2, PC3, 'Color', colors(i,:), 'Marker', '.', 'LineWidth', 1, 'MarkerSize', 10); hold on
% % end
% % % xlim([-4, 4]); ylim([-3, 3]); zlim([-2.5, 2.5]);
% % axis(lims)
% % set(gca, 'Box', 'off', 'TickDir', 'out')
% % set(gca, 'XTick', [-3,0,3],'YTick', [-3,0,3],'ZTick', [-2,0,2])
% % xlabel('PC1'); ylabel('PC2'); zlabel('PC3');
% % %axis(l); view([az,el])
% % 
% % %This is a plot of first 2 PCs averages over syllable types
% % %Very clear presentation
% % figure(670); clf
% % for i = 1:numel(patternTypes)
% %     %Determine which indices are for a given pattern
% %     idx = find(patternList==patternTypes(i));
% % 
% %     %Plot first 3 PCs in 3D space
% %     PC1 = smooth(squeeze(mean(featCube(idx,1,:)))', 5, 'moving')';
% %     PC2 = smooth(squeeze(mean(featCube(idx,2,:)))', 5, 'moving')';
% %     plot(PC1, PC2, 'Color', colors(i,:), 'Marker', '.', 'LineWidth', 1, 'MarkerSize', 10); hold on
% % end
% % % xlim([-4, 4]); ylim([-3, 3]); zlim([-2.5, 2.5]);
% % axis(lims)
% % set(gca, 'Box', 'off', 'TickDir', 'out')
% % set(gca, 'XTick', [-3,0,3],'YTick', [-3,0,3],'ZTick', [-2,0,2])
% % xlabel('PC1'); ylabel('PC2'); zlabel('PC3');
% % 
% % % %This is a plot of first 2 PCs averages over syllable types
% % % %Not correct and very misleading
% % % figure(672); clf
% % % for i = 1:numel(patternTypes)
% % %     %Determine which indices are for a given pattern
% % %     idx = find(patternList==patternTypes(i));
% % % 
% % %     %Plot first 3 PCs in 3D space
% % %     PC1 = smooth(squeeze(mean(featCube(idx,1,:)))', 5, 'moving')';
% % %     PC2 = smooth(squeeze(mean(featCube(idx,2,:)))', 5, 'moving')';
% % %     PC1s = smooth(squeeze(std(featCube(idx,1,:))./sqrt(numel(idx)))', 5, 'moving')';
% % %     PC2s = smooth(squeeze(std(featCube(idx,2,:))./sqrt(numel(idx)))', 5, 'moving')';
% % %     
% % %     plot(PC1, PC2, 'Color', colors(i,:), 'Marker', '.', 'LineWidth', 1, 'MarkerSize', 10); hold on
% % %     %plot(PC1+PC1s, PC2+PC2s, 'Color', colors(i,:), 'LineWidth', 1);
% % %     %plot(PC1-PC1s, PC2-PC2s, 'Color', colors(i,:), 'LineWidth', 1);
% % %     patch([PC1+PC1s, fliplr(PC1-PC1s)],[PC2+PC2s, fliplr(PC2-PC2s)], colors(i,:), 'FaceAlpha', .3, 'EdgeColor','none')
% % % end
% % % % xlim([-4, 4]); ylim([-3, 3]); zlim([-2.5, 2.5]);
% % % axis(lims)
% % % set(gca, 'Box', 'off', 'TickDir', 'out')
% % % set(gca, 'XTick', [-3,0,3],'YTick', [-3,0,3])
% % % xlabel('PC1'); ylabel('PC2');
% % 
% % 
% % % %This is a plot of first 3 PCs averages over syllable types, with plane for
% % % %sem -- not a great image.
% % % figure(68); clf
% % % for i = 1:numel(patternTypes)
% % %     %Determine which indices are for a given pattern
% % %     idx = find(patternList==patternTypes(i));
% % % 
% % %     %Plot first 3 PCs in 3D space
% % %     PC1 = smooth(squeeze(mean(featCube(idx,1,:)))', 5, 'moving')';
% % %     PC2 = smooth(squeeze(mean(featCube(idx,2,:)))', 5, 'moving')';
% % %     PC3 = smooth(squeeze(mean(featCube(idx,3,:)))', 5, 'moving')';
% % %     PC1s = smooth(squeeze(std(featCube(idx,1,:))./numel(idx))', 5, 'moving')';
% % %     PC2s = smooth(squeeze(std(featCube(idx,2,:))./numel(idx))', 5, 'moving')';
% % %     PC3s = smooth(squeeze(std(featCube(idx,3,:))./numel(idx))', 5, 'moving')';
% % % %     PC1 = squeeze(mean(featCube(idx,1,:)));
% % % %     PC2 = squeeze(mean(featCube(idx,2,:)));
% % % %     PC3 = squeeze(mean(featCube(idx,3,:)));
% % %     plot3(PC1, PC2, PC3, 'Color', colors(i,:), 'Marker', '.', 'LineWidth', 1, 'MarkerSize', 10); hold on
% % %     fill3([PC1+PC1s, fliplr(PC1-PC1s)],[PC2+PC2s, fliplr(PC2-PC2s)],[PC3+PC3s, fliplr(PC3-PC3s)], colors(i,:), 'FaceAlpha', .3, 'EdgeColor','none')
% % % end
% % % % xlim([-4, 4]); ylim([-3, 3]); zlim([-2.5, 2.5]);
% % % axis(lims)
% % % set(gca, 'Box', 'off', 'TickDir', 'out')
% % % set(gca, 'XTick', [-3,0,3],'YTick', [-3,0,3],'ZTick', [-2,0,2])
% % % xlabel('PC1'); ylabel('PC2'); zlabel('PC3');
% % % %axis(l); view([az,el])
% % 
% % 
% % %This is a plot of first 3 PCs averages over syllable types
% % %with circles indicating the mean euclidean distance at each 1ms time point
% % figure(70); clf
% % PCDist = [];
% % for i = 1:numel(patternTypes)
% %     %Determine which indices are for a given pattern
% %     idx = find(patternList==patternTypes(i));
% % 
% %     %Plot first 3 PCs in 3D space
% %     PC1 = smooth(squeeze(mean(featCube(idx,1,:)))', 5, 'moving')';
% %     PC2 = smooth(squeeze(mean(featCube(idx,2,:)))', 5, 'moving')';
% %     PC3 = smooth(squeeze(mean(featCube(idx,3,:)))', 5, 'moving')';
% %     V = [PC1', PC2', PC3'];
% %     Ds = [];
% %     
% %     %Calculate the point-wise Euclidean distance for each syllable
% %     for j = idx'
% %         PC1i = smooth(squeeze(featCube(j,1,:))', 5, 'moving')';
% %         PC2i = smooth(squeeze(featCube(j,2,:))', 5, 'moving')';
% %         PC3i = smooth(squeeze(featCube(j,3,:))', 5, 'moving')';
% % 
% %         %Pointwise EU Dist
% %         D = pdist2(V, [PC1i', PC2i', PC3i'], 'euclidean');
% %         Ds(j,:) = diag(D)';
% %         
% %     end
% %     
% %     %Calc mean pointwise distance
% %     PCDist(i,:) = mean(Ds,1);
% %     PCDistRad = (PCDist(i,:).^2).*pi; %Radius to area conversion
% %     
% %     %Plot
% %     plot3(PC1, PC2, PC3, 'Color', colors(i,:), 'LineWidth', 1); hold on
% %     scatter3(PC1, PC2, PC3, 100*PCDistRad, colors(i,:))
% %     
% % end
% % % xlim([-4, 4]); ylim([-3, 3]); zlim([-2.5, 2.5]);
% % axis(lims)
% % set(gca, 'Box', 'off', 'TickDir', 'out')
% % set(gca, 'XTick', [-3,0,3],'YTick', [-3,0,3],'ZTick', [-2,0,2])
% % xlabel('PC1'); ylabel('PC2'); zlabel('PC3');
% % 
% % %This is a plot of first 2 PCs averages over syllable types
% % %Shaded band indicating mean euclidean distance
% % figure(71); clf
% % PCDist = [];
% % for i = 1:numel(patternTypes)
% %     %Determine which indices are for a given pattern
% %     idx = find(patternList==patternTypes(i));
% % 
% %     %Plot first 3 PCs in 3D space
% %     PC1 = smooth(squeeze(mean(featCube(idx,1,:)))', 5, 'moving')';
% %     PC2 = smooth(squeeze(mean(featCube(idx,2,:)))', 5, 'moving')';
% % 
% %     V = [PC1', PC2'];
% %     Ds = [];
% %     
% %     %Calculate the point-wise Euclidean distance for each syllable
% %     for j = idx'
% % %         PC1i = smooth(squeeze(featCube(j,1,:))', 5, 'moving');
% % %         PC2i = smooth(squeeze(featCube(j,2,:))', 5, 'moving');
% %         PC1i = squeeze(featCube(j,1,:));
% %         PC2i = squeeze(featCube(j,2,:));
% %         
% %         %Pointwise EU Dist
% %         D = pdist2(V, [PC1i, PC2i], 'euclidean');
% %         Ds(j,:) = diag(D)';
% %     end
% %     
% %     %Calc mean pointwise distance
% %     PCDist(i,:) = mean(Ds,1)./5;
% %     [innerx, innery, outerx, outery] = xyshadedbar(PC1, PC2, PCDist(i,:));
% %     
% %     %Plot
% %     plot(PC1, PC2, 'Color', colors(i,:), 'LineWidth', 2); hold on
% %     
% %     %Lines
% % %     plot(innerx, innery, 'Color', colors(i,:), 'LineStyle', '--', 'LineWidth', 0.5);
% % %     plot(outerx, outery, 'Color', colors(i,:), 'LineStyle', '--', 'LineWidth', 0.5);
% %     
% %     %Shaded
% %     patch([innerx, fliplr(outerx)], [innery, fliplr(outery)], colors(i,:), 'FaceAlpha', .3, 'EdgeColor','none')
% % 
% % end
% % % xlim([-4, 4]); ylim([-3, 3]); zlim([-2.5, 2.5]);
% % set(gca, 'Box', 'off', 'TickDir', 'out')
% % set(gca, 'XTick', [-3,0,3],'YTick', [-3,0,3])
% % xlabel('PC1'); ylabel('PC2');
% 
% %This is a plot of first 3 PCs averages vs time  over syllable types
% %Shaded band indicating mean euclidean distance
% figure(78); clf
% PCDist = [];
% % timepnts = -100:392;
% timepnts = -5:125;
% for i = 1:numel(patternTypes)
%     %Determine which indices are for a given pattern
%     idx = find(patternList==patternTypes(i));
% 
%     %Plot first 3 PCs in 3D space
%     PC1 = smooth(squeeze(mean(featCube(idx,1,:)))', 5, 'moving')';
%     PC2 = smooth(squeeze(mean(featCube(idx,2,:)))', 5, 'moving')';
%     PC3 = smooth(squeeze(mean(featCube(idx,3,:)))', 5, 'moving')';
% 
%     V = [PC1, PC2, PC3];
%     Ds = [];
%     
% %     %Calculate the point-wise Euclidean distance for each syllable
% %     for j = idx'
% %         %         PC1i = smooth(squeeze(featCube(j,1,:))', 5, 'moving');
% %         %         PC2i = smooth(squeeze(featCube(j,2,:))', 5, 'moving');
% %         PC1i = squeeze(featCube(j,1,:));
% %         PC2i = squeeze(featCube(j,2,:));
% %         PC3i = squeeze(featCube(j,3,:));
% %         
% %         %Pointwise EU Dist
% %         D = pdist2(V, [PC1i, PC2i, PC3i], 'euclidean');
% %         Ds(j,:) = diag(D)';
% %     end
% %     
% %     %Calc mean pointwise distance
% %     PCDist(i,:) = mean(Ds,1);
%     
%     %Plot
%     subplot(3,1,1)
%     plot(timepnts, PC1, 'LineWidth', 2); hold on
%     xlim([-70, 400])
%     set(gca, 'Box', 'off', 'TickDir', 'out')
%     ylabel('PC1');
%     
%     subplot(3,1,2)
%     plot(timepnts, PC2, 'LineWidth', 2); hold on
%     xlim([-75, 400])
%     set(gca, 'Box', 'off', 'TickDir', 'out')
%     ylabel('PC2');
%     
%     subplot(3,1,3)
%     plot(timepnts, PC3, 'LineWidth', 2); hold on
%     xlim([-75, 400])
%     set(gca, 'Box', 'off', 'TickDir', 'out')
%     xlabel('Time (ms)'); ylabel('PC3');
% end
% for i =1:3
%     subplot(3,1,i)
%     ys = ylim;
%     line([0, 0], ys, 'Color', 'r', 'LineStyle', ':');
% end
% % xlim([-4, 4]); ylim([-3, 3]); zlim([-2.5, 2.5]);
% % set(gca, 'Box', 'off', 'TickDir', 'out')
% % set(gca, 'XTick', [-3,0,3],'YTick', [-3,0,3])


%tSNE embedding

%Calculate feature projections for each snip in the 
for i = 1:size(snipsCube,1)
    %extract features
    S = specBuilder(snipsCube(i,:));
%     S = featureBuilder(snipsCube(i,:));
%     S = S(:,50:250);
%     S = S(:,100:200);
    padmat = gaussPad(S);
    S = [S;padmat];
    
    %Add to the PCA list
    snipSet = [snipSet, S];
end

%Perform tSNE embedding
rng('default') % for reproducibility
Y = tsne(snipSet','Algorithm','barneshut', 'Distance', 'correlation', 'NumDimensions', 2);
% figure; scatter(Y(:,1),Y(:,2))

%Unwrap the embedding matrix into syllable snips again
snipSize = size(Y,1)/size(snipsCube,1);
sc = Y';
for i = 1:size(snipsCube,1)
    starts = snipSize*(i-1)+1;
    ends = snipSize*(i);
    featCube(i,:,:) = sc(:, starts:ends);
end

%Plotting
t = get(0,'defaultAxesColorOrder');
colors = [t; rand(23,3)]; %30 initial plotting colors to work with
patternTypes = unique(patternList);

%This is a plot
figure(40); clf
for i = 1:numel(patternTypes)
    %Determine which indices are for a given pattern
    idx = find(patternList==patternTypes(i));

     %Plot each timeseries in lowD space
    for j = idx'
        plot(squeeze(featCube(j,1,:)), squeeze(featCube(j,2,:)), 'Marker', '.', 'Color', colors(i,:)); hold on
    end
end

%This is a plot
figure(41); clf
for i = 1:numel(patternTypes)
    %Determine which indices are for a given pattern
    idx = find(patternList==patternTypes(i));

     %Plot each timeseries in lowD space
    for j = idx'
        d1 = smooth(squeeze(featCube(j,1,:))', 9, 'moving')';
        d2 = smooth(squeeze(featCube(j,2,:))', 9, 'moving')';
        
        plot(d1, d2, 'Marker', '.', 'Color', colors(i,:)); hold on
    end
end


























