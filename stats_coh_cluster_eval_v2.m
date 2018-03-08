clear all
clc
close all

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/';
sim_fig='/autofs/cluster/transcend/fahimeh/fmm/doc/Simulation/';

fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labelslh_2.txt');
D=textscan(fid,'%s');
label_names=D{1,1};

occipital=label_names(1:11);
frontal=label_names(12:20);

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


sig_matrix_cond1_Allfreq=zeros(length(occipital),length(frontal));
sig_matrix_cond2_Allfreq=zeros(length(occipital),length(frontal));

posclus=0;
negclus=0;
Thresh=0.05;

for iLabel1=1:length(occipital)
    
    for iLabel2=1:length(frontal)
        
        [iLabel1 iLabel2]
        
        load([sim_dir 'coherence/stats/stats_coh_' occipital{iLabel1} '_' frontal{iLabel2} '_noiserest' num2str(NoiseLevelr(1)) '_' num2str(NoiseLevelr(2))  ...
             '_nsubj' num2str(nsubj) '_' tag '.mat']);
%         
% load([sim_dir 'coherence/stats/stats_coh_' occipital{iLabel1} '_' frontal{iLabel2} '_noiserest' num2str(NoiseLevelr(1)) '_' num2str(NoiseLevelr(2))  ...
%              '_nsubj' num2str(nsubj) '_' tag '.mat']);
%             

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

figure;
imagesc(time,freq,posclus);axis xy;colorbar;colormap('jet');set(gca,'fontsize',12,'fontweight','bold');set(gca,'clim',[1 14])
title('cond1>cond2-occipital-frontal')
% print([sim_fig 'cond1>cond2-occipital-frontal'],'-dpdf')
        
figure;
imagesc(time,freq,negclus);axis xy;colorbar;colormap('jet');set(gca,'fontsize',12,'fontweight','bold');set(gca,'clim',[1 14])
title('cond2>cond1-occipital-frontal')
% print([sim_fig 'cond2>cond1-occipital-frontal'],'-dpdf')

reorder=[7 8 2  3 9 4 10 5 11 6 1];

figure;
imagesc(sig_matrix_cond1_Allfreq(reorder,:));colormap('jet');axis xy;colorbar;set(gca,'clim',[-4000 4000]);set(gca,'fontsize',12,'fontweight','bold')
% print([sim_fig 'posclus-occipital-frontal'],'-dpdf')

figure;
imagesc(sig_matrix_cond2_Allfreq(reorder,:));colormap('jet');axis xy;colorbar;set(gca,'clim',[-4000 4000]);set(gca,'fontsize',12,'fontweight','bold')
% print([sim_fig 'negclus-occipital-frontal'],'-dpdf')

%[num_rejected, fdr_vec, idx] = fdr_sheraz(P)
frontal((sum(sig_matrix_cond2_Allfreq~=0))~=0)
occipital((sum((sig_matrix_cond2_Allfreq~=0),2))~=0)


