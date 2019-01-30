clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/

% parts=[5 7 9 11 13];
% subs=[1 2 3 4 5];

parts=[5 7 9 11 13];
%subs=[1 2 3 4 5];
subs=[1 2 3 4 5];


%snr=[0.1 0.06 .03];
%snr=[1 0.1 0.09 .08 .07 0.06 .05 .04 0.03];
%snr=[1 0.1 .08 0.06 .04 0.03];


%sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/labelsize_var/';
sim_dir='/autofs/space/meghnn_001/users/fahimeh/simulations/';
sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/SNR_var/';

%noiseLevelr=1;

X{1} =[0     0;0    0];
X{2} =[0     0;0    0];

flagrest=2;

%  POOL=parpool('local',20);


iparts=3;

sub_num=subs(iparts);

specific_tag=['per3_' num2str(sub_num) 'sub' num2str(parts(iparts)) 'Restvar_' num2str(100)];


tt=load([sim_dir 'power_estimate_pvalues_' specific_tag '.mat'])

P=(tt.counter>15 & tt.counter<50);


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
    
    
   
    
    indsub=1:3:parts(iparts)*2;
    
    %label_names=all_label([indsub,indsub+parts(iparts)]);
    label_names=all_label(indsub);
    
    %label_names=all_label([1:sub_num,(1:sub_num)+parts(iparts)]);
    
    label1=all_label(1:sub_num);
    
    all_label1=all_label(1:parts(iparts));
    all_label2=all_label(parts(iparts)+1:parts(iparts)*2);
    
    specific_tag=['per3_' num2str(sub_num) 'sub' num2str(parts(iparts)) 'Restvar_' num2str(i_power)];
    
    %%
    
%     labeldir_tag=['stg' num2str(parts(iparts)) 'part/'];
    
    
    load([sim_dir 'power_analysis_per3_' num2str(i_power) '.mat'])
    
    
%     [tag, FREQ, fs] = simulation_coh_func_norandom_clustercompar(sim_dir,label_names,label1,noiseLevelr,specific_tag,SNR,labeldir_tag);
    
    
    %% statistics
    
  
    nperm=150;
    %         fs = 600;
%     TAG{1}=tag;
%     TAG{2}=tag;
%     
%     stats=  do_sim_stats_clustercompar(sim_dir,TAG,label_names,FREQ,nperm,fs);
    
    
    tag=[num2str(0) '_' num2str(0) '_' num2str(0) '_' num2str(0) '_nr_' num2str(noiseLevelr) ...
            '_snr_' num2str(SNR) '_' specific_tag];
        %
        %
         F=[sim_dir 'nperm' num2str(nperm) '_sim_cluster3D_' tag '_seed_' label_names{1}(1:end-6) '_nomedialwall.mat'];
            
        tt= load(F);
        %
        %
        Pcluster(i_power)=tt.stats.posclus(1).pvalue;
        
    
    end
    
    
end
