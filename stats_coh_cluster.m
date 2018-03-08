clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/
sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/';


%  POOL=parpool('local',50);

NoiseLevelr=[.065 .065];

X{1} =[6 1;7 1];
X{2} =[0     0;0     0];
nsubj=8;

%NoiseLevelr_cond1=0.;
icond=1;
jitter_noise=X{icond};
fcond1=[sim_dir 'coherence/data_subj_coherence_cond' num2str(icond) '_noiserest' num2str(NoiseLevelr(icond)) '_nsubj' ...
        num2str(nsubj) '_' num2str(jitter_noise(1,1)) num2str(jitter_noise(1,2)) num2str(jitter_noise(2,1)) num2str(jitter_noise(2,2)) '.mat'];
   
cond1=load(fcond1);


icond=2;
jitter_noise=X{icond};
fcond2=[sim_dir 'coherence/data_subj_coherence_cond' num2str(icond) '_noiserest' num2str(NoiseLevelr(icond)) '_nsubj' ...
        num2str(nsubj) '_' num2str(jitter_noise(1,1)) num2str(jitter_noise(1,2)) num2str(jitter_noise(2,1)) num2str(jitter_noise(2,2)) '.mat'];
cond2=load(fcond2);

time=cond1.time;
freq=cond1.freq;
temporal=cond1.temporal;
frontal=cond1.frontal;

nperm=200;
statsmethod='pairedttest';
ALPHA=0.01;

tag='6171_0000';

for iLabel1=1:length(temporal)
    
    for iLabel2=1:length(frontal)
        
        [iLabel1 iLabel2]
        G1=squeeze(cond1.data_subj(:,iLabel1,iLabel2,:,:));
        G2=squeeze(cond2.data_subj(:,iLabel1,iLabel2,:,:));
        
        
        STATS=do_stats2D(G1,G2,nperm,statsmethod,ALPHA);
        
        save([sim_dir 'coherence/stats/stats_coh_' temporal{iLabel1} '_' frontal{iLabel2} '_noiserest' num2str(NoiseLevelr(1)) '_' num2str(NoiseLevelr(2))  ...
             '_nsubj' num2str(nsubj) '_' tag '.mat'],'STATS','time','freq','temporal','frontal','X','NoiseLevelr');
        
    end
    
end

delete(POOL);
