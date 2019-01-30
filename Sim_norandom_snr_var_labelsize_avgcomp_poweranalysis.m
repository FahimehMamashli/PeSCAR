clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/


parts=[5 7 9 11 13];
subs=[1 2 3 3 4];




sim_dir='/autofs/space/meghnn_001/users/fahimeh/simulations/';
sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/SNR_var/';

noiseLevelr=1;

X{1} =[0     0;0    0];
X{2} =[0     0;0    0];

flagrest=2;

% POOL=parpool('local',8);

rate=0.05;
nPerm_s=250;

iparts=3;

% P=[30    31    37    43    47    56    65    69    74    77    80    81    85    88    92  98    99   100 45    48    71    72    79    80 , ...
%     32    34    40    55    59    61    66    76    83    94    95];
%P=[];
%P=[];
P=[92,100,99,47,98,69,85,74,31,65];

for i_p=30:100
    


    
    i_power=i_p;
    
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
    
    label_names=all_label([1:sub_num,(1:sub_num)+parts(iparts)]);
    
    label1=all_label(1:sub_num);
    
    all_label1=all_label(1:parts(iparts));
    all_label2=all_label(parts(iparts)+1:parts(iparts)*2);
    
    %   specific_tag=['templ_tempr_' num2str(sub_num) 'sub_norand_15to20f_8subj_stg' num2str(parts(iparts)) 'parts'];
    
    specific_tag=['templ_tempr_' num2str(sub_num) 'sub_norand_15to20f_8subj_stg' num2str(parts(iparts)) 'parts_Restvar_' num2str(i_power)];
    
    %%
    
    labeldir_tag=['stg' num2str(parts(iparts)) 'part/'];
            
    
    issptial_var.save_sensor=0;
    issptial_var.do = 0;
    
    %       simulation_coh_func_norandomness(sim_dir,label_names,all_label,all_label1,all_label2,label1,noiseLevelr,specific_tag,SNR,labeldir_tag, issptial_var)
    
    %% statistics
    
    %      do_sim_stats(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR)
    
    load([sim_dir 'power_analysis_' num2str(i_power) '.mat'])
    
    
    %    compare_avg_coh(sim_dir,all_label1,all_label2,noiseLevelr,specific_tag,SNR)
    
    temporal1={['t',all_label1{1}(1:end-11),all_label1{1}(end-8:end)]};
    temporal2={['t',all_label2{1}(1:end-11),all_label2{1}(end-8:end)]};
    
    %     do_sim_stats_avgcoh(sim_dir,temporal1,temporal2,X,noiseLevelr,specific_tag,flagrest,SNR)
    
    PValue(i_p)=do_sim_plot_avgcoh(sim_dir,temporal1,temporal2,X,noiseLevelr,specific_tag,flagrest,SNR,sim_doc)
    
    close all
    
    cfg.plot=0;
    [keep_it,count_box]= cluster_coh_eval(all_label1,all_label2,X,sim_dir,noiseLevelr,specific_tag,sim_doc,flagrest,SNR,cfg);
    counter(i_power)=count_box;
    
    
    %                  cluster_coh_eval(all_label1,all_label2,X,sim_dir,noiseLevelr,specific_tag,sim_doc,flagrest,SNR)
    
    %[h, crit_p, adj_ci_cvrg, adj_p]= cluster_coh_fdr(all_label1,all_label2,X,sim_dir,noiseLevelr,specific_tag,sim_doc,flagrest,SNR,rate)
    
    if ~isempty(find(P==i_p))
        
      
        Ppsrc(i_p) =compute_permutation_pvalue(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR,nPerm_s);
    else
        Ppsrc(i_p)=0.01;
        
    end
    
end

save([sim_dir 'power_estimate_pvalues_' specific_tag '.mat'],'PValue','counter','Ppsrc')
