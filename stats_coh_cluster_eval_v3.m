clear all
clc
close all

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/';

fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labelslh.txt');

D=textscan(fid,'%s');
label_names=D{1,1};

temporal=label_names(1:9);
frontal=label_names(17:25);

%NoiseLevelr=[1 .065];
NoiseLevelr=[0.4 1];

nsubj=8;

posclus=0;
negclus=0;

%tag='6171_8041804';40,11, .065, .065
%tag='71101_8041804';
%tag='6171_8041804';
%tag='6171_9042004';
%tag='6171_0000';
%tag='7.17.1_0000';
%tag='7171_0000';
%tag='71.271.2_0000';
%tag='8292_0000';
tag='71.581.5_0000';

Thresh=.05;

pos=zeros(length(temporal),length(frontal));
neg=zeros(length(temporal),length(frontal));
k=1;
for iLabel1=1:length(temporal)
    
    for iLabel2=1:length(frontal)
        
        [iLabel1 iLabel2]
        
        load([sim_dir 'coherence/stats/stats_coh_' temporal{iLabel1} '_' frontal{iLabel2} '_noiserest' num2str(NoiseLevelr(1)) '_' num2str(NoiseLevelr(2))  ...
             '_nsubj' num2str(nsubj) '_' tag '.mat']);
      

%                  load([sim_dir 'coherence/stats/stats_coh_' temporal{iLabel1} '_' frontal{iLabel2} '_noiserest' num2str(NoiseLevelr(1)) '_' num2str(NoiseLevelr(2))  ...
%              '_nsubj' num2str(nsubj) '_' tag '.mat']);

        if ~isempty(STATS.posclus) && STATS.posclus(1).pvalue <=Thresh
            
            clussum=0;
            for iclus=1:length(STATS.posclus)
                
                if STATS.posclus(iclus).pvalue<=Thresh
                    clussum=clussum+STATS.posclus(iclus).clustermass;
                    posclus=posclus+STATS.posclus(iclus).mask;
                end
            end
            
            sig_matrix_cond1_Allfreq(iLabel1,iLabel2)=clussum;
            
            
        end
        
        if ~isempty(STATS.negclus) && STATS.negclus(1).pvalue <=Thresh
            
            clussum=0;
            for iclus=1:length(STATS.negclus)
                
                if STATS.negclus(iclus).pvalue<=Thresh
                    clussum=clussum+STATS.negclus(iclus).clustermass;
                    negclus=negclus+STATS.negclus(iclus).mask;
                end
            end
            
            sig_matrix_cond2_Allfreq(iLabel1,iLabel2)=clussum;
            
        end
        
    end
    
end

time=time(50:550);
freq=1:46;

figure('position',[360   502   560   420])
imagesc(time,freq,posclus);axis xy;colorbar;set(gca,'fontsize',12,'fontweight','bold');colormap('jet')
title('cond1>cond2-temporal-frontal')
figure('position',[360   502   560   420])
imagesc(time,freq,negclus);axis xy;colorbar;set(gca,'fontsize',12,'fontweight','bold');colormap('jet')
title('cond2>cond1-temporal-frontal')

figure;
imagesc(sig_matrix_cond1_Allfreq);colormap('jet');axis xy;colorbar;set(gca,'clim',[-4000 4000]);set(gca,'fontsize',12,'fontweight','bold')
title('cond1>cond2-temporal-frontal')

figure;
imagesc(sig_matrix_cond2_Allfreq);colormap('jet');axis xy;colorbar;set(gca,'clim',[-4000 4000]);set(gca,'fontsize',12,'fontweight','bold')
title('cond2>cond1-temporal-frontal')


% figure;
% imagesc(pos);axis xy;colorbar;set(gca,'fontsize',12,'fontweight','bold');colormap('jet')
% title('cond1>cond2-temporal-frontal')
% 
% figure;
% imagesc(neg);axis xy;colorbar;set(gca,'fontsize',12,'fontweight','bold');colormap('jet')
% title('cond2>cond1-temporal-frontal')


frontal((sum(sig_matrix_cond2_Allfreq~=0))~=0)
temporal((sum((sig_matrix_cond2_Allfreq~=0),2))~=0)

%sum(sum((sig_matrix_cond2_Allfreq~=0),2))~=0))


%[num_rejected, fdr_vec, idx] = fdr_sheraz(P)



