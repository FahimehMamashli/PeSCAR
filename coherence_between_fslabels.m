clear all
clc
close all


addpath /cluster/transcend/scripts/MEG/Matlab_scripts/freesurfer/
addpath /cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/';
label_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/fslabels/038301/fsmorphedto_038301-';

fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labelslh_2.txt');

D=textscan(fid,'%s');
label_names=D{1,1};

% occipital-frontal
occipital=label_names(1:11);
frontal=label_names(12:20);

raw=fiff_setup_read_raw('/autofs/cluster/transcend/MEG/fix/038301/1/038301_fix_1_sss.fif');
fs=raw.info.sfreq;

freq=10:30;
time=-0.25:1/fs:.75;

POOL=parpool('local',20);

% cond1
icond=1;
jitter_noise=[7 1.5;8 1.5];
NoiseLevelr=0.4;

for isubj=1:8    
do_coherence(occipital,frontal,time,isubj,freq,icond,sim_dir, NoiseLevelr, jitter_noise)
end

% cond2
icond=2;
jitter_noise=[0 0; 0 0];
NoiseLevelr=1;

for isubj=1:8
do_coherence(occipital,frontal,time,isubj,freq,icond,sim_dir, NoiseLevelr, jitter_noise)
end


%%
fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labelslh.txt');

D=textscan(fid,'%s');
label_names2=D{1,1};

% temporal-frontal
temporal=label_names2(1:9);


% cond1
icond=1;
jitter_noise=[7 1.5;8 1.5];
NoiseLevelr=0.4;

for isubj=1:8
do_coherence(temporal,frontal,time,isubj,freq,icond,sim_dir, NoiseLevelr, jitter_noise)
end

% cond2
icond=2;
jitter_noise=[0 0; 0 0];
NoiseLevelr=1;

for isubj=1:8
do_coherence(temporal,frontal,time,isubj,freq,icond,sim_dir, NoiseLevelr, jitter_noise)
end




