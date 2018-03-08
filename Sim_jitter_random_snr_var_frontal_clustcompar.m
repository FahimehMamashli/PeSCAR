clear all
clc
%close all

addpath /cluster/transcend/fahimeh/fm_functions/Mines/

fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/frontal_temp_sim_labels.txt');

D=textscan(fid,'%s');
all_label=D{1,1};

parts=[5 7 9 11 13];

subs=[1 2 3 4 5];

snr=[1 0.2 0.06 .03];
%snr=[1 0.1 0.09 .08 .07 0.06 .05 .04 0.03];

sim_dir='/cluster/transcend/fahimeh/fmm/resources/Simulations2/var_jitter/';
sim_doc='/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/var_jitter/';

noiseLevelr=1;

flagrest=3;

POOL=parpool('local',8);

maxJitter=10;
noiseLevel=0.1;

X{1}=[maxJitter noiseLevel;maxJitter noiseLevel];
X{2}=[0 0;0 0];



for iparts=3:3
    
    %     k=1;
    %     all_label=cell(1);
    %     for ipart=1:parts(iparts)
    %         all_label{k,1}=['superiortemporal_' num2str(ipart) '-lh.label'];
    %         k=k+1;
    %     end
    %     for ipart=1:parts(iparts)
    %         all_label{k,1}=['superiortemporal_' num2str(ipart) '-rh.label'];
    %         k=k+1;
    %     end
    %
    
    sub_num=subs(iparts);
    
    label_names=all_label([1:sub_num,(1:sub_num)+parts(iparts)]);
    
    label1=all_label(1:sub_num);
    
    all_label1=all_label(1:parts(iparts));
    all_label2=all_label(parts(iparts)+1:parts(iparts)*2);
    
    specific_tag=['templ_frontl_first' num2str(sub_num) 'sub_jitter_15to20f_8subj_stg' num2str(parts(iparts)) 'parts'];
    
    
    %%
    
    labeldir_tag=['stg' num2str(parts(iparts)) 'part/'];
    
    
    for isnr=1:1
        
        SNR=snr(isnr);
        
 %        [tag, FREQ, fs] =  simulation_coh_func_2_clustercomp(sim_dir,label_names,label1,noiseLevelr,specific_tag,SNR,labeldir_tag,maxJitter,noiseLevel);
        
        %% statistics
         tag{1}='10_0.1_10_0.1_nr_1_snr_1_templ_frontl_first3sub_jitter_15to20f_8subj_stg9parts';
         tag{2}='0_0_0_0_nr_1_snr_1_templ_tempr_3sub_jitter_15to20f_8subj_stg9parts';
 
         FREQ=round(logspace(0.79,1.7,20));
        fs=600;
        nperm=200;
        
        stats=  do_sim_stats_clustercompar(sim_dir,tag,label_names,FREQ,nperm,fs);
        
      
    end
    
end
