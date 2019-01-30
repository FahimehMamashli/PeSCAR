function [h, crit_p, adj_ci_cvrg, adj_p]=cluster_coh_fdr(temporal,frontal,X,sim_dir,noiseLevelr,specific_tag,sim_doc,flagrest,SNR,rate)

pos=zeros(length(temporal),length(frontal));
neg=zeros(length(temporal),length(frontal));

posclus=0;
negclus=0;

if ~exist('SNR','var')
    SNR=1;
end

if flagrest==1
    tag1=[ 'nr_' num2str(noiseLevelr) '_' specific_tag];
    tag2=tag1;
    
elseif flagrest==2
        icond=1;
    jitter_noise=X{icond};
    
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


kp=1;kn=1;
for iLabel1=1:length(temporal)
    
    for iLabel2=1:length(frontal)
        
        [iLabel1 iLabel2]
        
        
        load([sim_dir 'coherence/stats/stats_coh_' temporal{iLabel1} '_' frontal{iLabel2}   ...
            '_' tag1 '_' tag2 '.mat']);
        
        
        if ~isempty(STATS)
            
            if ~isempty(STATS.posclus)
                
                
                for iclus=1:1
                    
                    pvalpos(kp)=STATS.posclus(1).pvalue;
                    kp=kp+1;
                end
            end
            
            
            if ~isempty(STATS.negclus)
                
                pvalneg(kn)=STATS.negclus(1).pvalue;
                kn=kn+1;
            end
            
        end
    end
    
end

addpath addpath /autofs/cluster/transcend/fahimeh/fm_functions/fdr_bh/


[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(pvalpos,rate,'dep','yes');
set(gca,'Linewidth',2,'Fontsize',18)

title(['SNR reduced by ' num2str(1-SNR) '-corrected fdr rate ' num2str(rate)])
filename=[sim_doc 'FDR_pos_sub_labels_' tag2 ];
print(filename,'-dpdf')




