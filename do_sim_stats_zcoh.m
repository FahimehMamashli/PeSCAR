function do_sim_stats_zcoh(sim_dir,temporal,frontal,X,noiseLevelr,specific_tag,SNR)

if ~exist('SNR','var')
    SNR=1;
end
nsubj=8;


data_subj=zeros(nsubj,length(temporal),length(frontal),46,501);




for isubj=1:nsubj
    
    
    
    for iLabel1=1:length(temporal)
        
        
        for iLabel2=1:length(frontal)
            
            
            icond=1;
            jitter_noise=X{icond};
            
            tag1=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
                '_snr_' num2str(SNR) '_' specific_tag];
            
            filename=[sim_dir 'coherence/coh_subj_' num2str(isubj) '_' temporal{iLabel1}(1:end-6) '_' frontal{iLabel2}(1:end-6) '_cond' num2str(icond) '_' tag1 '.mat'];
            
            tt1=load(filename);
            
            
             icond=2;
            jitter_noise=X{icond};
            
            tag2=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
                '_snr_' num2str(SNR) '_' specific_tag];
            
            filename=[sim_dir 'coherence/coh_subj_' num2str(isubj) '_' temporal{iLabel1}(1:end-6) '_' frontal{iLabel2}(1:end-6) '_cond' num2str(icond) '_' tag2 '.mat'];
            
            tt2=load(filename);
            
        
            
            nepochs_A=50;
            nepochs_B=50;
            
            Coh_A=tt1.Coh;
            Coh_B=tt2.Coh;
            
            Z_Coh=(  ( atanh(Coh_A) - (1/(nepochs_A-2)) )  -   ( atanh(Coh_B) - (1/(nepochs_B-2)) )  ) /(sqrt(1/(nepochs_A-2)) + (1/(nepochs_B-2))) ;
                        
            
            data_subj(isubj,iLabel1,iLabel2,:,:)=Z_Coh(5:50,50:550);
            
        end
    end
end

time=tt1.time(50:550);
freq=5:50;


save([sim_dir 'coherence/stats/data_allsubj_Zcoh_' tag1 '_' tag2 '.mat'], ...
    'data_subj','time','freq','temporal','frontal')


nperm=250;
statsmethod='pairedttest';
ALPHA=0.05;


for iLabel1=1:length(temporal)
    
    for iLabel2=1:length(frontal)
        
        [iLabel1 iLabel2]
        G1=squeeze(data_subj(:,iLabel1,iLabel2,:,:));
        G2=zeros(size(G1));
        
        tic
        STATS=do_stats2D(G1,G2,nperm,statsmethod,ALPHA);
        
        save([sim_dir 'coherence/stats/stats_Zcoh_' temporal{iLabel1} '_' frontal{iLabel2}   ...
            '_' tag1 '_' tag2 '.mat'],'STATS','time','freq','temporal','frontal','X','noiseLevelr');
        toc
    end
    
end


