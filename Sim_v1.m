clear all
clc
close all

% POOL=parpool('local',16);


sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/';


fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labelslh.txt');

D=textscan(fid,'%s');
all_label=D{1,1};

label_names=D{1,1}([1:3,15:18]);

label1=D{1,1}(1:3);

all_label1=D{1,1}(1:9);
all_label2=D{1,1}(10:18);

noiseLevelr=4;
specific_tag='temp_front';

%%
% cond1
icond=1;

maxj1=9;
noisel1=1.5;
maxj2=9;
noisel2=1.5;
                   
simulation_coh_func(sim_dir,label_names,all_label,all_label1,all_label2,label1,maxj1,noisel1,maxj2,noisel2,noiseLevelr,icond,specific_tag)

clear maxj1 noisel1 maxj2 noisel2 icond

% cond2
icond=2;

maxj1=7;
noisel1=1.5;
maxj2=8;
noisel2=1.5;
simulation_coh_func(sim_dir,label_names,all_label,all_label1,all_label2,label1,maxj1,noisel1,maxj2,noisel2,noiseLevelr,icond,specific_tag)

%% statistics

X{1} =[9     1.5;9    1.5];
X{2} =[7     1.5;8     1.5];

do_sim_stats(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag)

cluster_coh_eval(all_label1,all_label2,X,sim_dir,noiseLevelr,specific_tag)


