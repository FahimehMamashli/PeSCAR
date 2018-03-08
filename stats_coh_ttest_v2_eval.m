clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/
sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/';


%POOL=parpool('local',20);

%NoiseLevelr=[1 .065];
NoiseLevelr=[0.4 1];


X{1} =[7 1.5;8 1.5];
X{2} =[0     0;0     0];
nsubj=8;

%NoiseLevelr_cond1=0.;
icond=1;
jitter_noise=X{icond};
fcond1=[sim_dir 'coherence/data_subj_coherence_occipital_frontal_cond' num2str(icond) '_noiserest' num2str(NoiseLevelr(icond)) '_nsubj' ...
        num2str(nsubj) '_' num2str(jitter_noise(1,1)) num2str(jitter_noise(1,2)) num2str(jitter_noise(2,1)) num2str(jitter_noise(2,2)) '.mat'];
   
cond1=load(fcond1);


icond=2;
jitter_noise=X{icond};
fcond2=[sim_dir 'coherence/data_subj_coherence_occipital_frontal_cond' num2str(icond) '_noiserest' num2str(NoiseLevelr(icond)) '_nsubj' ...
        num2str(nsubj) '_' num2str(jitter_noise(1,1)) num2str(jitter_noise(1,2)) num2str(jitter_noise(2,1)) num2str(jitter_noise(2,2)) '.mat'];
cond2=load(fcond2);

time=cond1.time;
freq=cond1.freq;
occipital=cond1.occipital;
frontal=cond1.frontal;


tag='71.581.5_0000';

for iLabel1=1:length(occipital)
    
    for iLabel2=1:length(frontal)
        
        
        
        load([sim_dir 'coherence/stats/stats_ttest_coh_' occipital{iLabel1} '_' frontal{iLabel2} '_noiserest' num2str(NoiseLevelr(1)) '_' num2str(NoiseLevelr(2))  ...
             '_nsubj' num2str(nsubj) '_' tag '.mat']);
         
         [num_rejected, fdr_vec, idx] = fdr_sheraz(squeeze(p(:)))
         
        
         pause
        
    end
    
end

%delete(POOL);
