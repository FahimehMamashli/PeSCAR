clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/



parts=[5 7 9 11 13];
subs=[1 2 3 3 4];




sim_dir='/autofs/space/meghnn_001/users/fahimeh/simulations/';
% sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/restvar/';

%sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/labelsize_var/';
sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/restvar/';


X{1} =[0     0;0    0];
X{2} =[0     0;0    0];

flagrest=2;

% POOL=parpool('local',15);

rate=0.05;
nPerm_s=250;

iparts=3;

%P=1;

%P=[30    31    37    43    47    56    65    69    74    77    80    81    85    88    92  98    99   100];
%P=[31    47    65    69    74    85    92    98    99   100];
P=[45    48    71    72    79    80];

%for i_p=1:length(P)
 for i_power=30:100
     
  %  i_power=P(i_p)
    
    
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
    
    specific_tag=['templ_tempr_' num2str(sub_num) 'sub_norand_15to20f_8subj_stg' num2str(parts(iparts)) 'parts_Restvar_' num2str(i_power)];
    
    %%
    
    labeldir_tag=['stg' num2str(parts(iparts)) 'part/'];
               
    
    %SNR=snr(isnr);
    %         s=0.03;
    %         while s<0.04
    %             SNR=rand(1)/10;
    %             s=SNR;
    %         end
    %
    %
    %         noiseLevelr=rand(1);
    
    %%%     save([sim_dir 'power_analysis_' num2str(i_power) '.mat'],'SNR','noiseLevelr','specific_tag');
    load([sim_dir 'power_analysis_' num2str(i_power) '.mat'])
    
    issptial_var.save_sensor=1;
    issptial_var.do = 0;
    
    %      simulation_coh_func_norandomness(sim_dir,label_names,all_label,all_label1,all_label2,label1,noiseLevelr,specific_tag,SNR,labeldir_tag, issptial_var)
    
    %% statistics
    
    
    %       do_sim_stats(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR)
    
    %     do_permutation_stats(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR,nPerm_s)
    
       cfg.plot=0;
       [keep_it,count_box]= cluster_coh_eval(all_label1,all_label2,X,sim_dir,noiseLevelr,specific_tag,sim_doc,flagrest,SNR,cfg);
       counter(i_power)=count_box;
% %     
%     if keep_it==1
%         store_ipower(P)=i_power;
%         P=P+1
%     end
%     
%     clear keep_it
    
    %[h, crit_p, adj_ci_cvrg, adj_p]= cluster_coh_fdr(all_label1,all_label2,X,sim_dir,noiseLevelr,specific_tag,sim_doc,flagrest,SNR,rate)
    
      %  compute_permutation_pvalue(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag,flagrest,SNR,nPerm_s)
    
    
   
    
end
