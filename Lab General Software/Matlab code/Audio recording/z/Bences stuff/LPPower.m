%looks at the powerspectrum of a low pass filtered version of the
%songenvelope; in practice this isn't very potent way of discriminating
%songs, since calls and noise also have high power in the 4-8 Hz frequency
%range.
song=yA;

clear spectraNorm;
filtWindow=2000;
downsample_factor=50;
NFFT=512;
scanrate=30000;
freqWindow=128;
noverlap=ceil(freqWindow/1.5);
Fs=scanrate/downsample_factor;

song_abs=abs(song);%rectify the song
song_filt=filter(ones(1,filtWindow)/filtWindow,1,song_abs);
song_small = downsample(song_abs,downsample_factor);
[spectra,f,t]=specgram1(song_small,NFFT,Fs,freqWindow,noverlap); 

spectraAbs=abs(spectra);
normVector=1./sum(spectraAbs,1);
for k = 1:size(spectraAbs,2), spectraNorm(1:size(spectraAbs,1),k) = normVector(1,k); end
spectraNormal=spectraNorm.*spectraAbs;
figure; plot(spectraNormal(7,:)+spectraNormal(8,:)+spectraNormal(9,:));
figure;imagesc(t,f,20*log10(spectraNormal+10e-1));axis xy; colormap(jet);ylim([0 50]); 