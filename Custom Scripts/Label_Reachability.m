function Label_Reachability(yvector1)
%CREATEFIGURE(YVECTOR1)
%  YVECTOR1:  bar yvector

%  Auto-generated by MATLAB on 04-Mar-2010 14:56:34

% Create figure
figure1 = figure('Name','Reachability Plot');

% Create axes
axes('Parent',figure1);
% Uncomment the following line to preserve the X-limits of the axes
% xlim([0 6522]);
box('on');
hold('all');

% Create bar
bar(yvector1,'EdgeColor','flat');

% Create xlabel
xlabel('Ordered Pnoints (n-->)');

% Create title
title('Reachability Plot fo PCASet, Eps = 2, MntPnts=25');

