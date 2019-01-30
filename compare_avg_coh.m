function compare_avg_coh(sim_dir,all_label1,all_label2,noiseLevelr,specific_tag,SNR)

addpath /autofs/cluster/transcend/scripts/MEG/Matlab_scripts/freesurfer/
addpath /autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/

%%
if ~exist('labeldir_tag','var')
    labeldir_tag='';
end


subjects={'042201','AC022','AC070','AC054','AC056','048102','AC058','AC064','038301'};


jitter_noise(1,:)=[0 0];
jitter_noise(2,:)=[0 0];


for isubj=1:8
    
    subj=subjects{isubj};
    
    filename1=['/autofs/cluster/transcend/MEG/fix/' subj '/1/' subj '_fix_1_144fil_raw.fif'];
    filename2=['/autofs/cluster/transcend/MEG/fix/' subj '/1/' subj '_fix_1_0.1_144fil_raw.fif'];
    
    if exist(filename1,'file')
        filen=filename1;
    elseif exist(filename2,'file')
        filen=filename2;
    else
        continue;
    end
    
    raw=fiff_setup_read_raw(filen);
                
    
    fs=raw.info.sfreq;
    time=-0.25:1/fs:.75;
    
    
    for icond=1:2
        
        tag=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
            '_snr_' num2str(SNR) '_' specific_tag];
        
        
        for iLabel=1:length(all_label1)
            
            
            tt=load([sim_dir 'label_epoch/simulation_subj_' num2str(isubj) 'epochs_' all_label1{iLabel}(1:end-6) '_cond' num2str(icond) '_' tag '.mat']);
            label1(iLabel,:,:)=squeeze(mean(tt.labrep));
            
            
        end
        
        temporal1={['t',all_label1{1}(1:end-11),all_label1{1}(end-8:end)]};
        labrep=label1;
        
        save([sim_dir 'label_epoch/simulation_subj_' num2str(isubj) 'epochs_' temporal1{1}(1:end-6) '_cond' num2str(icond) '_' tag  '.mat'],...
            'labrep','time')
        
        clear labrep
        
        for iLabel=1:length(all_label2)
            
            
            tt=load([sim_dir 'label_epoch/simulation_subj_' num2str(isubj) 'epochs_' all_label2{iLabel}(1:end-6) '_cond' num2str(icond) '_' tag '.mat']);
            label2(iLabel,:,:)=squeeze(mean(tt.labrep));
            
            
        end
        
        temporal2={['t',all_label2{1}(1:end-11),all_label2{1}(end-8:end)]};
        labrep=label2;
        
        save([sim_dir 'label_epoch/simulation_subj_' num2str(isubj) 'epochs_' temporal2{1}(1:end-6) '_cond' num2str(icond) '_' tag  '.mat'],...
            'labrep','time')
        
        clear labrep
        
        
        do_coherence(temporal1,temporal2,time,isubj,icond,sim_dir,jitter_noise,tag)
        
        
    end
    
    
    
end



