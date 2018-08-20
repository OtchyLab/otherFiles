function displaySpecgramQuick(signal, Fs, freqRange, cLimits, startTime,xdata, nCourse, windowSize, NFFT)
%nCourse specified the number of pixes per column of specgram... default is
%1.

%TODO:  Maybe automatically adjust the window size and NFFT is 
if(exist('xdata'))
    ud.xdata=xdata;
end
if(~exist('startTime'))
    startTime = 0;
end

if(~exist('nCourse'))
    nCourse = 1;
end

if(~exist('cLimits'))
    cLimits = [];
end

if(~exist('windowSize'))
    windowSize = 512;
end

if(~exist('NFFT'))
    NFFT = 512;
end


%Determine the size of the axis... to determine the 
ud.ax = gca;
ud.nCourse = nCourse;
%ud.windowSize = 512;
ud.windowSize = 512;
%ud.NFFT = 512;
ud.NFFT = 512;
ud.signal = signal;
ud.Fs = Fs;
ud.startTime = startTime;
ud.freqRange = freqRange;
ud.cLimits = cLimits;
ud.startndx = 1;
ud.endndx = length(signal);

set(ud.ax, 'UserData', ud);
set(ud.ax, 'ButtonDownFcn', @buttondown_quickspectrogram);

helper_quickspectrogram(ud);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function helper_quickspectrogram(ud)
windowSize = ud.windowSize;
windowSize = min(windowSize, ud.endndx - ud.startndx);
NFFT = ud.NFFT;  %greater freq precision can be achieved by increasing this.

%determine size of axis relative to size of the signal,
%use this to adapt the window overlap and downsampling of the signal.
%no need to worry about size of fftwindow, this doesn't effect speed.
set(ud.ax,'Units','pixels')
pixSize = get(ud.ax,'Position');
numPixels = pixSize(3) / ud.nCourse;
numWindows = (ud.endndx - ud.startndx) / windowSize;
if(numWindows < numPixels)
    %If we have more pixels, then ffts, then increase the overlap
    %of fft windows accordingly.
    ratio = ceil(numPixels/numWindows);
    windowOverlap = min(.999, 1 - (1/ratio));
    windowOverlap = floor(windowOverlap*windowSize);
    sss = ud.signal(ud.startndx:ud.endndx);
    Fs = ud.Fs;
else
    %If we have more ffts then pixels, then we can do things, we can
    %downsample the signal, or we can skip signal between ffts.
    %Skipping signal mean we may miss bits of song altogether.
    %Decimating throws away high frequency information.
    ratio = floor(numWindows/numPixels);
    windowOverlap = -1*ratio;
    windowOverlap = floor(windowOverlap*windowSize);
    sss = ud.signal(ud.startndx:ud.endndx);
    Fs = ud.Fs;   
    %windowOverlap = 0;
    %sss = decimate or downsample(ud.signal(ud.startndx:ud.endndx), ratio);
    %Fs = ud.Fs / ratio; 
end

%Compute the spectrogram
[S,F,T,P] = spectrogram(sss,windowSize,windowOverlap,NFFT,Fs); 

ndx = find((F>=ud.freqRange(1)) & (F<=ud.freqRange(2)));

%Draw the spectrogram
if(isequal(ud.cLimits,[]))
    i = imagesc(T+ud.startTime + (ud.startndx-1)/ud.Fs,F(ndx),10*log10(abs(S(ndx,:)) + .02)); axis xy;
else
    i = imagesc(T+ud.startTime + (ud.startndx-1)/ud.Fs,F(ndx),10*log10(abs(S(ndx,:)) + .02), ud.cLimits); axis xy;
end
if (isfield(ud,'xdata'))
    set(i,'XData',ud.xdata);
end
axis xy; axis tight; colormap(jet);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
set(i,'HitTest', 'off');

set(ud.ax,'Units','normalized')
set(ud.ax, 'UserData', ud);
set(ud.ax, 'ButtonDownFcn', @buttondown_quickspectrogram);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function buttondown_quickspectrogram(src, evnt)
ud = get(src, 'UserData');
axes(ud.ax);
mouseMode = get(gcf, 'SelectionType');
clickLocation = get(ud.ax, 'CurrentPoint');

if(strcmp(mouseMode, 'alt'))
    rect = rbbox;
    endPoint = get(gca,'CurrentPoint'); 
    point1 = clickLocation(1,1:2);              % extract x and y
    point2 = endPoint(1,1:2);
    shiftTime = point1(1) - point2(1);
    shiftNdx = round((shiftTime * ud.Fs) + 1);
    shiftNdx = shiftNdx - max(0, ud.endndx + shiftNdx - length(ud.signal));
    shiftNdx = shiftNdx - min(0, ud.startndx + shiftNdx -1);
    ud.startndx = ud.startndx + shiftNdx;
    ud.endndx = ud.endndx + shiftNdx;
elseif(strcmp(mouseMode, 'open'))
    %double click to zoom out
    ud.startndx = 1;
    ud.endndx = length(ud.signal);
elseif(strcmp(mouseMode, 'normal'))
    %left click to zoom in.
    rect = rbbox;
    endPoint = get(gca,'CurrentPoint'); 
    point1 = clickLocation(1,1:2);              % extract x and y
    point2 = endPoint(1,1:2);
    p1 = min(point1,point2);             % calculate locations
    offset = abs(point1-point2);         % and dimensions
    if(offset(1)/diff(xlim) < .001)
        quarter = round((ud.endndx - ud.startndx) / 4);
        midndx = round((p1(1) - ud.startTime)*ud.Fs + 1);
        ud.startndx = max(1,midndx - quarter);
        ud.endndx = min(length(ud.signal), midndx + quarter);
    else
        ud.startndx = max(round((p1(1) - ud.startTime)*ud.Fs + 1),1);
        ud.endndx = min(round((p1(1) + offset(1) - ud.startTime)*ud.Fs + 1),length(ud.signal));
    end
end
set(ud.ax,'UserData',ud);
helper_quickspectrogram(ud);


