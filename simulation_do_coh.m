function simulation_do_coh(sim_dir,label_names,alllabel,all_label1,all_label2,label1,noiseLevelr,specific_tag)

addpath /cluster/transcend/scripts/MEG/Matlab_scripts/freesurfer/
addpath /cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/

%%


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
            '_' specific_tag];
        
 
        
        do_coherence(all_label1,all_label2,time,isubj,icond,sim_dir,jitter_noise,tag)
             
        clear cortex
        
    end
    
end



