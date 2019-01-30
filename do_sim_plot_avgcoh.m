function PValue=do_sim_plot_avgcoh(sim_dir,temporal,frontal,X,noiseLevelr,specific_tag,flagrest,SNR,sim_doc)

if ~exist('SNR','var')
    SNR=1;
end

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


icond=1;
fcond1=[sim_dir 'coherence/stats/data_allsubj_coh_cond' num2str(icond) '_' temporal{1}(1:end-6) '_' frontal{1}(1:end-6) '_' tag1 '.mat'];

cond1=load(fcond1);

clear icond


icond=2;
fcond2=[sim_dir 'coherence/stats/data_allsubj_coh_cond' num2str(icond) '_' temporal{1}(1:end-6) '_' frontal{1}(1:end-6) '_' tag2 '.mat'];

cond2=load(fcond2);

time=cond1.time;
freq=cond1.freq;

G1=squeeze(cond1.data_subj(:,1,1,:,:));
G2=squeeze(cond2.data_subj(:,1,1,:,:));

S=load([sim_dir 'coherence/stats/stats_coh_' temporal{1} '_' frontal{1}   ...
    '_' tag1 '_' tag2 '.mat']);


    
% mask=S.STATS.posclus(1).mask;
% 
% tt=squeeze(mean(G1)-mean(G2));
% figure;
% imagesc(time*1000,freq,tt,[0,0.4]);axis xy;colormap('jet');colorbar
% hold on
% 
% %if S.STATS.posclus(1).pvalue<0.05
% contour(time*1000,freq,mask,1,'linewidth',3,'linecolor','black')
% %end
% 
% set(gca,'fontsize',16,'fontweight','bold')
% xlabel('Time (ms)')
% ylabel('Frequency (Hz)')
% 
% title([num2str(S.STATS.posclus(1).pvalue)])

PValue=(S.STATS.posclus(1).pvalue);

% print([sim_doc 'TF_mask_' temporal{1}(1:end-6) '_' frontal{1}(1:end-6) '_' tag2],'-dpdf')

