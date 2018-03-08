clear all
clc
close all

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/';

fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labelslh.txt');
D=textscan(fid,'%s');
label_names=D{1,1};

temporal=label_names(1:16);
frontal=label_names(17:25);

NoiseLevelr=[.065 .065];

nsubj=8;

posclus=0;
negclus=0;

%tag='6171_8041804';40,11, .065, .065
%tag='71101_8041804';
%tag='6171_8041804';
%tag='6171_9042004';
tag='6171_0000';

pos=zeros(length(temporal),length(frontal));
neg=zeros(length(temporal),length(frontal));

for iLabel1=1:length(temporal)
    
    for iLabel2=1:length(frontal)
        
        [iLabel1 iLabel2]
        
        load([sim_dir 'coherence/stats/stats_coh_' temporal{iLabel1} '_' frontal{iLabel2} '_noiserest' num2str(NoiseLevelr(1)) '_' num2str(NoiseLevelr(2))  ...
             '_nsubj' num2str(nsubj) '_' tag '.mat']);
%         
%            load([sim_dir 'coherence/stats/stats_coh_' temporal{iLabel1} '_' frontal{iLabel2} '_noiserest' num2str(NoiseLevelr(1)) '_noiseEpochsVerts_' ...
%             num2str(noiselevel(1)) '_' num2str(noiselevel(2)) '.mat']);
      
        if ~isempty(STATS.posclus) 
            
            for iclus=1:length(STATS.posclus)
                if STATS.posclus(iclus).pvalue<0.05
                    posclus=posclus+STATS.posclus(iclus).mask;
                    pos(iLabel1,iLabel2)=1;
                                    
                end
            end
        end
        
        if ~isempty(STATS.negclus) 
            
            for iclus=1:length(STATS.negclus)
                if STATS.negclus(iclus).pvalue<0.05
                    negclus=negclus+STATS.negclus(iclus).mask;
                    neg(iLabel1,iLabel2)=1;
                
                end
            end
        end
        
    end
    
end

figure('position',[360   502   560   420])
imagesc(posclus);axis xy;colorbar
title('cond1>cond2')
figure('position',[360   502   560   420])
imagesc(negclus);axis xy;colorbar
title('cond2>cond1')

figure;
imagesc(pos)



