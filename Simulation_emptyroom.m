clear all
clc
close all

fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labels_temp_lhrh.txt');

D=textscan(fid,'%s');
all_label=D{1,1};

%ind1=randperm(9);
%ind2=randperm(9);

sub_num=2;
%label_names=D{1,1}([ind1(1:sub_num),ind2(1:sub_num)+9]);

label_names=D{1,1}([1:sub_num,(1:2)+9]);

label1=D{1,1}(1:sub_num);

all_label1=D{1,1}(1:9);
all_label2=D{1,1}(10:18);

% specific_tag=['templ_tempr_' num2str(sub_num) 'sub_' num2str(ind2(1)) num2str(ind2(2)) num2str(ind2(3)) num2str(ind2(4))];
specific_tag=['templ_tempr_' num2str(sub_num) 'sub_first2_norandomness_15to20freq'];

%%
POOL=parpool('local',8);

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/';
noiseLevelr=1;

% cond1
icond=1;

flag=1;

simulation_coh_func_norandomness(sim_dir,label_names,all_label,all_label1,all_label2,label1,noiseLevelr,icond,specific_tag,flag)

clear icond

%%

% cond2
icond=2;

flag=0;

simulation_coh_func_norandomness(sim_dir,label_names,all_label,all_label1,all_label2,label1,noiseLevelr,icond,specific_tag,flag)
                    
%% statistics

X{1} =[0     0;0    0];
X{2} =[0     0;0    0];

do_sim_stats(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag)

sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/';

cluster_coh_eval(all_label1,all_label2,X,sim_dir,noiseLevelr,specific_tag,sim_doc)


