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


sim_dir='/autofs/space/meghnn_001/users/fahimeh/simulations/';
sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/SNR_var/';



X{1} =[0     0;0    0];
X{2} =[0     0;0    0];

flagrest=2;

%POOL=parpool('local',20);

P=[7    38    41    45    52];

nPerm_s=250;
iparts=3;

for i_power=1:100
% for i_p=1:length(P)
     
%     i_power=P(i_p);
    
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
    
    
    sub_num=subs(iparts);
    
    
    label_names=all_label;
    
    isspatial_var.do=1;
    isspatial_var.sub_num =sub_num;
    isspatial_var.parts = parts;
    isspatial_var.iparts = iparts;
    isspatial_var.random = 0;
    isspatial_var.discont = 1;
    
    %label_names=all_label([1:sub_num,(1:sub_num)+parts(iparts)]);
    
    label1=all_label(1:sub_num);
    
    all_label1=all_label(1:parts(iparts));
    all_label2=all_label(parts(iparts)+1:parts(iparts)*2);
    
    specific_tag=['varsubj_' num2str(sub_num) 'sub_stg' num2str(parts(iparts)) 'Restvar_' num2str(i_power)];
    
    %%
    
    labeldir_tag=['stg' num2str(parts(iparts)) 'part/'];
    
    
    
%     s=0.03;
%     while s<0.06
%         SNR=rand(1)/8;
%         s=SNR;
%     end
%     
%     
%     noiseLevelr=rand(1);
    
    %save([sim_dir 'power_analysis_varsubj_' num2str(i_power) '.mat'],'SNR','noiseLevelr','specific_tag');
    
    load([sim_dir 'power_analysis_varsubj_' num2str(i_power) '.mat']);
   
    isspatial_var.save_sensor=1;
    
%     simulation_coh_func_norandomness(sim_dir,label_names,all_label,all_label1,all_label2,label1,noiseLevelr,specific_tag,SNR,labeldir_tag,isspatial_var)
    
    %% statistics
    
  %  do_sim_stats(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR)
    
       %  do_permutation_stats(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR,nPerm_s)
       
       
     cfg.plot=0;
    [keep_it,count_box] = cluster_coh_eval(all_label1,all_label2,X,sim_dir,noiseLevelr,specific_tag,sim_doc,flagrest,SNR,cfg);
    counter(i_power)=count_box;
    
   % pvalue(i_p)=   compute_permutation_pvalue(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR,nPerm_s)
    
    
  %  compare_avg_coh(sim_dir,all_label1,all_label2,noiseLevelr,specific_tag,SNR)
    
    temporal1={['t',all_label1{1}(1:end-11),all_label1{1}(end-8:end)]};
    temporal2={['t',all_label2{1}(1:end-11),all_label2{1}(end-8:end)]};
    
   % do_sim_stats_avgcoh(sim_dir,temporal1,temporal2,X,noiseLevelr,specific_tag,flagrest,SNR)
    
    %  do_sim_plot_avgcoh(sim_dir,temporal1,temporal2,X,noiseLevelr,specific_tag,flagrest,SNR,sim_doc)
    PValue(i_power)= do_sim_plot_avgcoh(sim_dir,temporal1,temporal2,X,noiseLevelr,specific_tag,flagrest,SNR,sim_doc);
    %   cluster_coh_eval(temporal1,temporal2,X,sim_dir,noiseLevelr,specific_tag,sim_doc,flagrest,SNR)
    
    if ~isempty(find(P==i_power))
        Ppsrc(i_power) =compute_permutation_pvalue(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR,nPerm_s);
    else
        Ppsrc(i_power)=0.01;
    end
    
    
end


%%
save([sim_dir 'power_estimate_pvalues_' specific_tag '.mat'],'PValue','counter','Ppsrc')