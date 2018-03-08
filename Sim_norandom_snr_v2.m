clear all
clc
close all

addpath /eris/p41p3/transcend/fahimeh/fm_functions/Mines/


fid=fopen('/eris/p41p3/transcend/fahimeh/fmm/doc/txt/simulation_labels_temp_lhrh.txt');

D=textscan(fid,'%s');
all_label=D{1,1};

sub_num=3;

label_names=D{1,1}([1:sub_num,(1:sub_num)+9]);

label1=D{1,1}(1:sub_num);

all_label1=D{1,1}(1:9);
all_label2=D{1,1}(10:18);

specific_tag=['templ_tempr_' num2str(sub_num) 'firstsubs_norand_15to20f_8subj_stg9part_'];

%%
% POOL=parpool('local',8);

sim_dir='/eris/p41p3/transcend/fahimeh/fmm/resources/Simulations2/';
sim_doc='/eris/p41p3/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/';

noiseLevelr=1;


snr=[1 0.1 0.09 .08 .07 .06 .05 .04 .03]; %sub_num=2
%snr=[0.1 0.06 .03];

labeldir_tag='stg9part/';

X{1} =[0     0;0    0];
X{2} =[0     0;0    0];

flagrest=2;



for isnr=5:5
    
    SNR=snr(isnr);
    
    
    %     simulation_coh_func_norandomness(sim_dir,label_names,all_label,all_label1,all_label2,label1,noiseLevelr,specific_tag,SNR,labeldir_tag)
    
    %% statistics
    
    %     do_sim_stats(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR)
    
     
    cluster_coh_eval(all_label1,all_label2,X,sim_dir,noiseLevelr,specific_tag,sim_doc,flagrest,SNR)
    
end


