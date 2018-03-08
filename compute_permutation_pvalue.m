function compute_permutation_pvalue(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR,nPerm_s)




if flagrest==2
    
    jitter_noise=X{1};
    
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


load([sim_dir 'permutations/permutation_' tag1 '_' tag2 '_nPerm_s' num2str(nPerm_s) '.mat'])


fprintf('%s SNR %s',specific_tag,num2str(SNR))

p_value_Allfreq_cond1=(sum(sum(sum(abs(sig_matrix_cond1_Allfreq_p(:,:,:)),3),2)>=sum(sum(abs(sig_matrix_cond1_Allfreq),2)))+1)/(size(sig_matrix_cond1_Allfreq_p(:,:,:),1)+1)

figure;
imagesc(sig_matrix_cond1_Allfreq);axis xy;colorbar;

p_value_Allfreq_cond2=(sum(sum(sum(abs(sig_matrix_cond2_Allfreq_p(:,:,:)),3),2)>=sum(sum(abs(sig_matrix_cond2_Allfreq),2)))+1)/(size(sig_matrix_cond2_Allfreq_p(:,:,:),1)+1)

connection=[sum((sig_matrix_cond1_Allfreq~=0),2); (sum(sig_matrix_cond1_Allfreq~=0))']