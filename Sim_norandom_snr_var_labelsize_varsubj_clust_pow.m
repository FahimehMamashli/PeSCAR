clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/

% parts=[5 7 9 11 13];
% subs=[1 2 3 4 5];

parts=[5 7 9 11 13];
%subs=[1 2 3 4 5];
subs=[1 2 3 4 5];



%sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/labelsize_var/';
sim_dir='/autofs/space/meghnn_001/users/fahimeh/simulations/';
sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/SNR_var/';


X{1} =[0     0;0    0];
X{2} =[0     0;0    0];

flagrest=2;

POOL=parpool('local',12);


iparts=3;
sub_num=subs(iparts);
specific_tag=['varsubj_' num2str(sub_num) 'sub_stg' num2str(parts(iparts)) 'Restvar_' num2str(100)];


tt=load([sim_dir 'power_estimate_pvalues_' specific_tag '.mat']);

P=(tt.counter>10 & tt.counter<60);

for i_power=1:100
    
    if P(i_power)
        
        k=1;
        all_label=cell(1);
        for ipart=1:parts(iparts)
            all_label{k,1}=['superiortemporal_' num2str(ipart) '-lh.label'];
            k=k+1;
        end
        for ipart=1:parts(iparts)
            all_label{k,1}=['superiortemporal_' num2str(ipart) '-rh.label'];
            k=k+1;
        end
        
        
                        
        isspatial_var.do=1;
        isspatial_var.sub_num =sub_num;
        isspatial_var.parts = parts;
        isspatial_var.iparts = iparts;
        isspatial_var.random = 0;
        isspatial_var.discont = 1;
        
        
        
        label1=all_label(1:sub_num);
        %
        %     all_label1=all_label(1:parts(iparts));
        %     all_label2=all_label(parts(iparts)+1:parts(iparts)*2);
        
        label_names=all_label;
        
        specific_tag=['varsubj_'  'Restvar_' num2str(i_power)];
        
        load([sim_dir 'power_analysis_varsubj_' num2str(i_power) '.mat']);
        
        labeldir_tag=['stg' num2str(parts(iparts)) 'part/'];
        
        [tag, FREQ, fs] = simulation_coh_func_norandom_clustercompar_2(sim_dir,label_names,label1,noiseLevelr,specific_tag,SNR,labeldir_tag,isspatial_var);
        
        
        %% statistics
        
        
        nperm=150;
        %         fs = 600;
        TAG{1}=tag;
        TAG{2}=tag;
        
        stats=  do_sim_stats_clustercompar(sim_dir,TAG,label_names,FREQ,nperm,fs);
        
        
    end
    
end
