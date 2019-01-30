clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/



parts=[5 7 9 11 13];
subs=[1 2 3 3 4];

sim_dir='/autofs/space/meghnn_001/users/fahimeh/simulations/';
sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/SNR_var/';



X{1} =[0     0;0    0];
X{2} =[0     0;0    0];

flagrest=2;

% POOL=parpool('local',10);


iparts=3;

P=[11    16    32    43    51    54    61    65   75    76    77    86    87    89    90 92    94    98];

nPerm_s=250;

for i_power=1:100
    
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
    
    indsub=1:3:parts(iparts)*2;
    
    %label_names=all_label([indsub,indsub+parts(iparts)]);
    label_names=all_label(indsub);
    
    %label_names=all_label([1:sub_num,(1:sub_num)+parts(iparts)]);
    
    label1=all_label(1:sub_num);
    
    all_label1=all_label(1:parts(iparts));
    all_label2=all_label(parts(iparts)+1:parts(iparts)*2);
    
    specific_tag=['per3_' num2str(sub_num) 'sub' num2str(parts(iparts)) 'Restvar_' num2str(i_power)];
    
    %%
    
    labeldir_tag=['stg' num2str(parts(iparts)) 'part/'];
    
    
    load([sim_dir 'power_analysis_per3_' num2str(i_power) '.mat'])
    
        
%     compare_avg_coh(sim_dir,all_label1,all_label2,noiseLevelr,specific_tag,SNR)
    
 %   temporal1={['t',all_label1{1}(1:end-11),all_label1{1}(end-8:end)]};
 %   temporal2={['t',all_label2{1}(1:end-11),all_label2{1}(end-8:end)]};
    
  %  do_sim_stats_avgcoh(sim_dir,temporal1,temporal2,X,noiseLevelr,specific_tag,flagrest,SNR)
    
  %  PValue(i_power)= do_sim_plot_avgcoh(sim_dir,temporal1,temporal2,X,noiseLevelr,specific_tag,flagrest,SNR,sim_doc);
    
    %  cluster_coh_eval(temporal1,temporal2,X,sim_dir,noiseLevelr,specific_tag,sim_doc,flagrest,SNR)
    
    %compute_permutation_pvalue(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR,nPerm_s)
    
    cfg.plot=0;
    
   [keep_it,count_box]= cluster_coh_eval(all_label1,all_label2,X,sim_dir,noiseLevelr,specific_tag,sim_doc,flagrest,SNR,cfg);
   counter(i_power)=count_box;
  %   pvalue(i_p) =  compute_permutation_pvalue(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR,nPerm_s)
    
    
    if ~isempty(find(P==i_power))
        Ppsrc(i_power) =compute_permutation_pvalue(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR,nPerm_s);
    else
        Ppsrc(i_power)=0.01;
    end
    
    
end

%save([sim_dir 'power_estimate_pvalues_' specific_tag '.mat'],'PValue','counter','Ppsrc')