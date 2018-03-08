clear all
clc
close all


fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labels_temp_lhrh.txt');

D=textscan(fid,'%s');
all_label=D{1,1};

ind1=randperm(9);
ind2=randperm(9);

label_names=D{1,1}([ind1(1:4),ind2(1:4)+9]);

label1=D{1,1}(1:4);

all_label1=D{1,1}(1:9);
all_label2=D{1,1}(10:18);


specific_tag='templ_tempr_4sub';


%%
% POOL=parpool('local',16);

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/';
noiseLevelr=4;

% cond1
icond=1;

maxj1_cond1=9;
noisel1_cond1=1.5;
maxj2_cond1=9;
noisel2_cond1=1.5;
                   
simulation_coh_func(sim_dir,label_names,all_label,all_label1,all_label2,label1,maxj1_cond1,noisel1_cond1,maxj2_cond1,noisel2_cond1,noiseLevelr,icond,specific_tag)

clear icond

% cond2
icond=2;

maxj1_cond2=7;
noisel1_cond2=1.5;
maxj2_cond2=8;
noisel2_cond2=1.5;
simulation_coh_func(sim_dir,label_names,all_label,all_label1,all_label2,label1,maxj1_cond2,noisel1_cond2,maxj2_cond2,noisel2_cond2,noiseLevelr,icond,specific_tag)

%% statistics

X{1} =[maxj1_cond1     noisel1_cond1;maxj2_cond1    noisel2_cond1];
X{2} =[maxj1_cond2     noisel1_cond2;maxj2_cond2    noisel2_cond2];

do_sim_stats(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag)

cluster_coh_eval(all_label1,all_label2,X,sim_dir,noiseLevelr,specific_tag)


