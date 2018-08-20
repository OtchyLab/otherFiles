caller='Playback';
birdname='nif3';
songtypeP=1;  % 1=BOS
is_forward=1;   % 1=forward,  0=reverse
close all;
bytes=8000;
path(path,'..');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CHANNELS
micro=8;         % -1 = off
speaker_input=7;  % -1 = off
channels=[1 2 3];  % [] = empty, electrode channels to be recorded
channels_o=[0];
scanrate=40000; 
scanrate_o=40000;

pre_bos_int=5; % time before BOS playbacks in seconds
post_bos_int=5; % time after BOS playbacks in seconds
num_playbacks=30;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEFAULTS
points_per_pixel=3; % the number of samples per pixel for the plotting routine
do_save_playback=1;  
do_plot_playback=1;
loadpath='/Matlab-6.5/Data/';  % where BOS files are
savepath='/Matlab-6.5/Data/';  % where to save the data
input_device='nidaq'; input_hwaddress='1';
output_device='nidaq'; output_hwaddress='1';


load([loadpath birdname '/BOS_' birdname '.mat']);
if is_forward
bos_data=[zeros(1,pre_bos_int*scanrate) sdata zeros(1,post_bos_int*scanrate)]';
else
bos_data=[zeros(1,pre_bos_int*scanrate) sdata(end:-1:1) zeros(1,post_bos_int*scanrate)]';
end
bos_data=bos_data/max(bos_data);
bos_samples=length(bos_data);
%figure(1); clf; specgram1(sdata,1024,scanrate,400,360); ylim([0 8000]);  axis off
startup_engines;

    putdata(ao,bos_data);

if do_save_playback  
    dirname= datestr(date,29);  % directory for saving of data
    if ~(exist([savepath birdname '/' dirname])==7)
        mkdir([savepath birdname],dirname);
    end
    songtype_prefix=set_songtype_prefix(caller,songtypeP);
    caller_prefix=set_caller_prefix(caller,is_forward);
    fnames=get_fnames(savepath,birdname,dirname,'PLAY_',songtype_prefix,caller_prefix,bytes);
    if length(fnames)>0
        namehelp=char(fnames{end}(1:end-4));
        namehelp=NextName(namehelp);
        filecount=namehelp(end-3:end);
    else
        filecount='0001';
    end
    namehelp=['PLAY_' birdname  songtype_prefix '-' caller_prefix filecount];
    filename=[savepath birdname '/' dirname '/' namehelp '.daq'];
    set(ai,'LoggingMode','Disk&Memory');
    set(ai,'LogToDiskMode','index');
    set(ai,'LogFileName',filename);    
else
    set(ai,'LoggingMode','Memory');
    set(ai,'LogFileName','');
end
fprintf('Press enter when ready for %s-%s playback to %s\n',songtype_prefix,caller_prefix,birdname);
    fprintf('Next file: %s \n',namehelp);
pause
%%%%%%%%%%%%%%%%%%%%%%% Playback
for i=1:num_playbacks
    start(ai); start(ao);
    while strcmp(ai.Running,'Off') | strcmp(ao.Running,'Off')
    end
    trigger(ai); trigger(ao);
    fprintf('Currently: %s \n',namehelp);
    pause(bos_samples/scanrate+.1);
    stop(ai); stop(ao); flushdata(ai);putdata(ao,bos_data);
    if do_save_playback
namehelp=NextName(namehelp);
    filename=[savepath birdname '/' dirname '/' namehelp '.daq'];
    set(ai,'LogFileName',filename);        
end
end
delete(ai); delete(ao);