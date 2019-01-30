function do_sim_stats_avgcoh(sim_dir,temporal,frontal,X,noiseLevelr,specific_tag,flagrest,SNR)

if ~exist('SNR','var')
    SNR=1;
end
nsubj=8;

indf=5:50;

for icond=1:2
    
    data_subj=zeros(nsubj,length(temporal),length(frontal),length(indf),501);
    
    jitter_noise=X{icond};
    
    
    if flagrest==1
        tag=[ 'nr_' num2str(noiseLevelr) '_' specific_tag];
    elseif flagrest==2
        
        tag=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
            '_snr_' num2str(SNR) '_' specific_tag];
    else
        
        tag=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
            '_snr_' num2str(SNR) '_' specific_tag];
    end
    
    for isubj=1:nsubj
        
        
        
        for iLabel1=1:length(temporal)
            
            
            for iLabel2=1:length(frontal)
                
                
                filename=[sim_dir 'coherence/coh_subj_' num2str(isubj) '_' temporal{iLabel1}(1:end-6) '_' frontal{iLabel2}(1:end-6) '_cond' num2str(icond) '_' tag '.mat'];
                
                tt=load(filename);
                
                data_subj(isubj,iLabel1,iLabel2,:,:)=tt.Coh(indf,50:550);
                
            end
        end
    end
    
    time=tt.time(50:550);
    freq=indf;
    
    save([sim_dir 'coherence/stats/data_allsubj_coh_cond' num2str(icond) '_' temporal{1}(1:end-6) '_' frontal{1}(1:end-6) '_' tag '.mat'], ...
        'data_subj','time','freq','temporal','frontal')
    
    
end


clear data_subj




if flagrest==1
    
    tag1=[ 'nr_' num2str(noiseLevelr) '_' specific_tag];
    tag2=[ 'nr_' num2str(noiseLevelr) '_' specific_tag];
    
elseif flagrest==2
    
    tag1=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
        '_snr_' num2str(SNR) '_' specific_tag];
    tag2=tag1;
    
    
else
    
    icond=1;
    jitter_noise=X{icond};
    tag1=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
        '_snr_' num2str(SNR) '_' specific_tag];
    
    icond=2;
    jitter_noise=X{icond};
    
    tag2=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
        '_snr_' num2str(SNR) '_' specific_tag];
    
end


icond=1;
fcond1=[sim_dir 'coherence/stats/data_allsubj_coh_cond' num2str(icond) '_' temporal{1}(1:end-6) '_' frontal{1}(1:end-6) '_' tag1 '.mat'];

cond1=load(fcond1);

clear icond


icond=2;
fcond2=[sim_dir 'coherence/stats/data_allsubj_coh_cond' num2str(icond) '_' temporal{1}(1:end-6) '_' frontal{1}(1:end-6) '_' tag2 '.mat'];

cond2=load(fcond2);


nperm=250;
statsmethod='pairedttest';
ALPHA=0.05;


for iLabel1=1:length(temporal)
    
    for iLabel2=1:length(frontal)
        
        [iLabel1 iLabel2]
        G1=squeeze(cond1.data_subj(:,iLabel1,iLabel2,:,:));
        G2=squeeze(cond2.data_subj(:,iLabel1,iLabel2,:,:));
        
        tic
        STATS=do_stats2D(G1,G2,nperm,statsmethod,ALPHA);
        
        save([sim_dir 'coherence/stats/stats_coh_' temporal{iLabel1} '_' frontal{iLabel2}   ...
            '_' tag1 '_' tag2 '.mat'],'STATS','time','freq','temporal','frontal','X','noiseLevelr');
        toc
    end
    
end


