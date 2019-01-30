function do_permutation_stats(sim_dir,temporal,frontal,X,noiseLevelr,specific_tag,flagrest,SNR,nPerm_s)

cond=cell(1);

for icond=1:2
    
    
    jitter_noise=X{icond};
    
    tag=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
        '_snr_' num2str(SNR) '_' specific_tag];
    
    cond{icond}=load([sim_dir 'coherence/stats/data_allsubj_coh_cond' num2str(icond) '_' tag '.mat']);
    
end



if flagrest==2
    
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

Thresh=0.05;
sig_matrix_cond1_Allfreq=zeros(length(temporal),length(frontal));
sig_matrix_cond2_Allfreq=zeros(length(temporal),length(frontal));


for iLabel1=1:length(temporal)
    
    for iLabel2=1:length(frontal)
        
        
        load([sim_dir 'coherence/stats/stats_coh_' temporal{iLabel1} '_' frontal{iLabel2}  '_' tag1 '_' tag2 '.mat']);
        
        mask1=0;mask2=0;
        clussum_pos=0;clussum_neg=0;
        
        
        if ~isempty(STATS)
            [clussum_pos,clussum_neg,mask1,mask2]=stats_eval_cluster(STATS,mask1,mask2,Thresh);
        end
        
        
        sig_matrix_cond1_Allfreq(iLabel1,iLabel2)=clussum_pos;
        sig_matrix_cond2_Allfreq(iLabel1,iLabel2)=clussum_neg;
        
        clear STATS
        
    end
    
end

cond1cond2=[cond{1}.data_subj;cond{2}.data_subj];

sig_matrix_cond1_Allfreq_p=zeros(nPerm_s,length(temporal),length(frontal));
sig_matrix_cond2_Allfreq_p=zeros(nPerm_s,length(temporal),length(frontal));

L=size(cond{1}.data_subj,1);

nperm=250;
statsmethod='pairedttest';
ALPHA=0.05;

k1=1;



for iPerm_s=1:nPerm_s
    
    ind_perm=randperm(size(cond1cond2,1));
    
    cond1=cond1cond2(ind_perm(1:L),:,:,:,:);
    cond2=cond1cond2(ind_perm(L+1:end),:,:,:,:);
    
    
    for iLabel1=1:length(temporal)
        
        
        for iLabel2=1:length(frontal)
            
            iPerm_s
            
            
            
            try
            
                tic
                
            cond1D=squeeze(cond1(:,iLabel1,iLabel2,:,:));
            cond2D=squeeze(cond2(:,iLabel1,iLabel2,:,:));
            
            
            STATS=do_stats2D(cond1D,cond2D,nperm,statsmethod,ALPHA);
            
            
            mask1=0;mask2=0;
            clussum_pos=0;clussum_neg=0;
            
            
            if ~isempty(STATS)
                [clussum_pos,clussum_neg,mask1,mask2]=stats_eval_cluster(STATS,mask1,mask2,Thresh);
            end
            
            
            sig_matrix_cond1_Allfreq_p(iPerm_s,iLabel1,iLabel2)=clussum_pos;            
            
            sig_matrix_cond2_Allfreq_p(iPerm_s,iLabel1,iLabel2)=clussum_neg;
            
                        
            toc
            
            clear STATS
            
            catch
                
               missed_perms(k1)=iPerm_s;
               k1=k1+1;
            end
            
        end
        
    end
end


if ~exist('missed_perms','var')
    missed_perms=0;
end

save([sim_dir 'permutations/permutation_' tag1 '_' tag2 '_nPerm_s' num2str(nPerm_s) '.mat'], ...
    'sig_matrix_cond1_Allfreq','sig_matrix_cond1_Allfreq_p','sig_matrix_cond2_Allfreq','sig_matrix_cond2_Allfreq_p', ...
    'temporal','frontal','Thresh','nPerm_s','ALPHA','time','freq','missed_perms')










