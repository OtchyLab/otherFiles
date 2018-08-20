function spikeMat = genHVCpool(nHVC, mu_ISI, sig_ISI, mu_numBurst, sig_numBurst, dt, nodeSpace)
% function HVC_spikes = genHVCinput(W_HVC, numSpikes, mu_ISI, sig_ISI, dt, nodeSpace)
% This function generates physiologically realistic HVC input (to a modeled
% RA cell) based on input parameters derived from Okubo et al 2015.
%
% created by TMO 2016; last modified 09-10-2016
%
% INPUTS:
%   nHVC:           a scalar value of the number of HVC neurons in the pool
%   mu_ISI:         scalar value of the mu/mean of the ISI distribution (in ms)
%   sig_ISI:        scalar value of the sigma/std of the ISI distribution (in ms)
%   mu_numBurst:    scalar value of the mu/mean of the number of spikes in a burst
%   sig_numBurst:   scalar value of the sigma/std of the number of spikes in a burst
%   dt:             timestep of simulation (in ms)
%   nodeSpace:      time between onset of each HVC neuron activity (in ms)
%
% OUTPUTS:
%   HVC_spikes:     a matrix of length nHVC x (nHVC*nodeSpace/dt) representing
%                   the spiketimes for each of the neurons in a pool during a
%                   single rendition

%Testing data
%load('testParams.mat')

%Boolean switch for plotting output
plotIt = false;

%Calculate the number of timesteps in the simulation
simDur = (nHVC*nodeSpace)/dt; %(in timesteps)
time = dt:dt:(nHVC*nodeSpace);

%Initialize the spike matrix
spikeMat = zeros(nHVC, simDur);

%Sample distribution to get number of spikes for each neuron
numSpikes = round(lognrnd(mu_numBurst, sig_numBurst, [1, nHVC]));      %normal distribution
numSpikes(numSpikes<2) = 2;

%Fill in the spiketime matrix neuron by neuron
for i = 1:nHVC
    %Retrive the correct number of spike ISIs as defined by distributions
    ISIs = lognrnd(mu_ISI, sig_ISI, 1, numSpikes(i));      %lognormal distribution
    
    %Assemble single burst
    HVC_burst_template = [];
    for j = 1:numSpikes(i)
        timebins = round((ISIs(j)-dt)/dt);
        spike = [1, zeros(1, timebins)];
        
        HVC_burst_template = [HVC_burst_template, spike];
    end
    
    %Define insertion point
    s_idx = ((i-1)*nodeSpace)/dt+1;
    e_idx = s_idx + numel(HVC_burst_template)-1;
    
    %Add it to the running matrix
    spikeMat(i, s_idx:e_idx) = HVC_burst_template;
    spikeMat = spikeMat(:,1:simDur); %Maintain matrix size
end

%Apply the synapse weighting (not the most efficient method...)
spikesPlot = spikeMat;
% wIdx = find(W_HVC ~= 0);
% for i = wIdx
%     spikeMat(i,:) = W_HVC(i) .* spikeMat(i,:);
% end

%Sum these spike weights across neurons for net input at ea h moment of time
% HVC_spikes =  sum(spikeMat,1);

%For debugging, turn off plotting with a boolean
lineSize = 1; %raster line length
if plotIt
    %Raster plot of the non zero-weighted HVC input to the current RA cell
    figure(999); clf
    for i = 1:nHVC
        %Synapse weight time time for the neuron input
        s = time .* spikesPlot(i,:);
        
        %Simplify by eliminating the zero-weights
        spikeTimes = s(s~=0);
        
        %Plot it as a single line using the rasterLine function to generate
        %a NaN'd array
        [tSx, tSy]  = rasterLine(spikeTimes', (i - (lineSize/2)), (i + (lineSize/2)));
        line(tSx, tSy,'color','k'); hold on
    end
    
    %Format
    axis ij; xlim([0,nHVC*nodeSpace]); ylim([0,nHVC+1])
    xlabel('Simulation Time (ms)'); ylabel('HVC Neuron Number')
    set(gca, 'Box', 'off', 'TickDir', 'out', 'XTick', [0, 500, 1000], 'YTick', [0, 50, 100]);
    
    %     figure(1050)
    %     clf
    %     plot(HVC_spikes)
end