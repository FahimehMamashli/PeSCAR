function timefreq=do_time_freq_sensor(epoch_data,Fs,FREQ)

addpath /autofs/cluster/transcend/fahimeh/fm_functions/TimeFrequency

for isensor=1:306
    
    tic;
    
    fprintf('sensor timefreq %s \n',num2str(isensor))
    
    TF{1} = single(computeWaveletTransform_nopool(epoch_data(isensor,:,:),Fs,FREQ,7,'morlet'));
    
    timefreq(isensor,:,:,:)=TF{1};
    
    
    clear TF
    
    toc;
    
end