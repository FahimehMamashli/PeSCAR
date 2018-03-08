clear all
clc
close all

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/';

fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labelslh.txt');

D=textscan(fid,'%s');
label_names=D{1,1};

temporal=label_names(1:9);
frontal=label_names(10:18);

%NoiseLevelr=[1 .065];
NoiseLevelr=[4 4];

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
%tag='0000_0000';
%    tag='71.500_0000';
tag='91.591.5_71.581.5';




pos=zeros(length(temporal),length(frontal));
neg=zeros(length(temporal),length(frontal));
k=1;
for iLabel1=1:length(temporal)
    
    for iLabel2=1:length(frontal)
        
        [iLabel1 iLabel2]
        
        
            
        
        load([sim_dir 'coherence/stats/stats_coh_' temporal{iLabel1} '_' frontal{iLabel2} '_noiserest' num2str(NoiseLevelr(1)) '_' num2str(NoiseLevelr(2))  ...
            '_nsubj' num2str(nsubj) '_' tag '.mat']);
        %
        %            load([sim_dir 'coherence/stats/stats_coh_' temporal{iLabel1} '_' frontal{iLabel2} '_noiserest' num2str(NoiseLevelr(1)) '_noiseEpochsVerts_' ...
        %             num2str(noiselevel(1)) '_' num2str(noiselevel(2)) '.mat']);
        
        if ~isempty(STATS)
            if ~isempty(STATS.posclus)
                
                P(k)=STATS.posclus(1).pvalue;
                k=k+1;
                for iclus=1:length(STATS.posclus)
                    if STATS.posclus(iclus).pvalue<0.05
                        posclus=posclus+STATS.posclus(iclus).mask;
                        pos(iLabel1,iLabel2)=STATS.posclus(iclus).clustermass;
                        
                    end
                end
            end
            
            
            if ~isempty(STATS.negclus)
                
                for iclus=1:length(STATS.negclus)
                    if STATS.negclus(iclus).pvalue<0.05
                        negclus=negclus+STATS.negclus(iclus).mask;
                        neg(iLabel1,iLabel2)=STATS.negclus(iclus).clustermass;
                        
                    end
                end
            end
            
        end
    end
    
end

T=time(50:550);

% figure('position',[360   502   560   420])
% imagesc(T,1:46,posclus);axis xy;colorbar;colormap('jet')
% title('cond1>cond2')
% figure;
% imagesc(pos);axis xy;colorbar;colormap('jet')

figure('position',[360   502   560   420])
imagesc(negclus);axis xy;colorbar;colormap('jet')
title('cond2>cond1 temporal-frontal')

% frontal(find(sum(pos~=0)))
% temporal(find(sum(pos,2)))

figure;
imagesc(-neg);axis xy;colorbar;colormap('jet');title('temporal-frontal')


% figure;
% imagesc(pos)
%
% [num_rejected, fdr_vec, idx] = fdr_sheraz(P)



