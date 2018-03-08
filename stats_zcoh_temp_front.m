clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/
sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/';

tag='91.591.5_71.581.5';
NoiseLevelr=[5 5];

load([sim_dir 'coherence/zcoh/allzcoh_subj_temp_front_lh_noiser_' num2str(NoiseLevelr(1)) '_' num2str(NoiseLevelr(2)) '_' tag '.mat'])

nperm=200;
statsmethod='pairedttest';
ALPHA=0.05;

nsubj=8;

POOL=parpool('local',8);

for iLabel1=1:length(temporal)
    
    for iLabel2=1:length(frontal)
        
        [iLabel1 iLabel2]
        tic
        G1=squeeze(allzcoh(:,iLabel1,iLabel2,5:50,91:512));
        G2=zeros(size(G1));
        
        
        STATS=do_stats2D(G1,G2,nperm,statsmethod,ALPHA);
        
        save([sim_dir 'coherence/zcoh/stats_zcoh_' temporal{iLabel1} '_' frontal{iLabel2} '_'  ...
             '_nsubj' num2str(nsubj) '_noiser_' num2str(NoiseLevelr(1)) '_' num2str(NoiseLevelr(2)) '_'  tag '.mat'],'STATS','time','freq','temporal','frontal','X','NoiseLevelr');
        toc
    end
    
end

delete(POOL);