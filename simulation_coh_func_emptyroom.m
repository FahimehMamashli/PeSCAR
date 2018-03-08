function simulation_coh_func_rest(sim_dir,label_names,alllabel,all_label1,all_label2,label1,noiseLevelr,icond,specific_tag,flag)


addpath /cluster/transcend/scripts/MEG/Matlab_scripts/freesurfer/
addpath /cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/

label_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/fslabels/038301/fsmorphedto_038301-';


%%
fname_inv='/autofs/cluster/transcend/fmm/038301/1/038301_fmm_0.1_140_fil_fixed_new_erm_megreg_0_new_MNE_proj-inv.fif';
inv = mne_read_inverse_operator(fname_inv);

%%
raw=fiff_setup_read_raw('/autofs/cluster/transcend/MEG/fix/038301/1/038301_fix_1_0.1_144fil_raw.fif');

jitter_noise=[0 0;0 0];
freq=0;

for isubj=1:8
    % condition1-occipital
    
    nEpochs=50;
    fs=raw.info.sfreq;
    time=-0.25:1/fs:.75;
    nTime=length(time);
    
           
    ranStart=randperm(6000,1);
    [rest,T] = fiff_read_raw_segment(raw,ranStart+raw.first_samp,ranStart+raw.first_samp+nTime*nEpochs-1,1:306);
    rest=rest-repmat(mean(rest,2),1,size(rest,2));
    rest=reshape(rest,306,nTime,nEpochs);
    
    
    epoch_data=rest/noiseLevelr;
    
    
    tag=[ 'nr_' num2str(noiseLevelr) '_' specific_tag];
    
    % get the source label time series
    
    % sol: vertices*time*epochs
    data_input=epoch_data;
    nave=1;
    dSPM=0;
    pickNormal=0;
    
    
    sol = single(labelrep_cortex(data_input,fname_inv,nave,dSPM,pickNormal));
        
    
    S=squeeze(mean(sol,3));
    
    stem=[sim_dir 'source_stc/source_data_subj_' num2str(isubj) '_cond_' num2str(icond) '_' tag];
    tmin=time(1);
    tstep=1/fs;
    mne_write_inverse_sol_stc(stem,inv,abs(S),tmin,tstep)
    
    
    isMean=0;
    isSpatial=0;
    
    
    for iLabel=1:length(alllabel)
        
        label=[label_dir alllabel{iLabel}];
        
        
        [labrep, rsrcind, LSrcind,SRCind] = labelmean(label,inv,sol,isMean,isSpatial);
        
        data_info.label_name=alllabel{iLabel};
        data_info.structure='vertices_time_epochs';
        
        save([sim_dir 'label_epoch/simulation_subj_' num2str(isubj) 'epochs_' alllabel{iLabel}(1:end-6) '_cond' num2str(icond) '_' tag '.mat'], ...
            'labrep','SRCind','time','fname_inv','epoch_data','data_info');
        
        clear labrep rsrcind
        
    end
    
    
    do_coherence(all_label1,all_label2,time,isubj,freq,icond,sim_dir,jitter_noise,tag)
    
    clear cortex
    
end



