%tCAF analysis script for Nerurkar and Otchy (2018) and Darkwa, Nerurkar,
%and Otchy (2018). This makes timeseries plots of the syllable durations
%and changes. Also saves some summary data to a file to group data over
%birds and conditions.

%% Set it up
clear 

%File location
mother = 'C:\Users\Tim\Desktop\Matlab Code\General Scripts\Custom Scripts\tCAF Analysis';
file = 'summaryStats.mat'; %<=== Update this to load different file

%Load it
load([mother, filesep, file])

cats = {'Control', 'ChABC'};

%Create the figure
f = figure(102); clf
set(f, 'Units', 'inches', 'Position', [24, 7, 6, 5.75])

%Marker List
mkrs = {'o', 'd', '+'};

barCents =1:4;


%% Plot max streches
subplot(2,1,1); cla

%Group data
birdID = []; tStretch = []; nStretch = [];
numCats = numel(cats);
v = getFieldVectorCell(stats, 'batch'); 
for i = 1:numCats
    %Make analysis mask
    mask = strcmp(v, cats{i});
    
    %apply
    subset = stats(mask);
    numSets = numel(subset);
    
    for j = 1:numSets
        %Running list
        tStretch = [tStretch,  subset(j).tStretch];
        nStretch = [nStretch, subset(j).ntStretch(:)];
        
        %Plot the stretches
        tXs = i*ones(size(subset(j).tStretch));
        nXs = (i+2)*ones(size(subset(j).ntStretch(:)));
        scatter([tXs', nXs'], [subset(j).tStretch', subset(j).ntStretch(:)'],'k', 'Marker', mkrs{j}); hold on
    
    
    end
    
    
    
end
a = 1;
