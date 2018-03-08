function do_coherence(temporal,frontal,time,isubj,icond,sim_dir,jitter_noise,tag)
                 

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Coherence


parfor iLabel1=1:length(temporal)
    
    data1=load([sim_dir 'label_epoch/simulation_subj_' num2str(isubj) 'epochs_' temporal{iLabel1}(1:end-6) '_cond' num2str(icond) '_' tag  '.mat']);
    
    for iLabel2=1:length(frontal)
        
                   
        tic
        data2=load([sim_dir 'label_epoch/simulation_subj_' num2str(isubj) 'epochs_' frontal{iLabel2}(1:end-6) '_cond' num2str(icond) '_' tag  '.mat']);
        
        %  fprintf('compute coherence between label %s and label %s for subj %s and condition %s \n',label_names{iLabel1},label_names{iLabel2},subj,num2str(icond))
        
        
        
        freq1=computeTF(mean(data1.labrep(:,:,:)),time,[]);
        freq2=computeTF(mean(data2.labrep(:,:,:)),time,[]);
        
        [PL, Coh]=crossPL(squeeze(freq1.fourierspctrm),squeeze(freq2.fourierspctrm));
        
        
        %    [PL, Coh, iCoh,wPLI,wPLI_debiased]=crossConn(squeeze(freq1.fourierspctrm),squeeze(freq2.fourierspctrm));
        
        filename=[sim_dir 'coherence/coh_subj_' num2str(isubj) '_' temporal{iLabel1}(1:end-6) '_' frontal{iLabel2}(1:end-6) '_cond' num2str(icond) '_' tag '.mat'];
        
        
        %         filename=[sim_dir 'coherence/crossConn_subj_' num2str(isubj) '_' temporal{iLabel1}(1:end-6) '_' frontal{iLabel2}(1:end-6) '_cond' num2str(icond) '_noiserest' num2str(NoiseLevelr) ...
        %             '_jitter_noiseTempFront_' num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '.mat'];
        
        %save_file(filename,PL,Coh,iCoh,wPLI,wPLI_debiased,time,freq,jitter_noise)
        
        save_file_coh(filename,PL,Coh,time,jitter_noise)
        
        toc
    end
end
