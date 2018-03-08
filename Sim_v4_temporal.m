clear all
clc
close all

fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labels_temp_lhrh.txt');

D=textscan(fid,'%s');
all_label=D{1,1};

%ind1=randperm(9);
%ind2=randperm(9);

sub_num=4;
%label_names=D{1,1}([ind1(1:sub_num),ind2(1:sub_num)+9]);

label_names=D{1,1}([1:sub_num,(3:6)+9]);

label1=D{1,1}(1:sub_num);

all_label1=D{1,1}(1:9);
all_label2=D{1,1}(10:18);

% specific_tag=['templ_tempr_' num2str(sub_num) 'sub_' num2str(ind2(1)) num2str(ind2(2)) num2str(ind2(3)) num2str(ind2(4))];
specific_tag=['templ_tempr_' num2str(sub_num) 'sub_first4'];

%%
POOL=parpool('local',16);

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/';
noiseLevelr=4;


maxj1_cond1=9;
noisel1_cond1=1.5;
maxj2_cond1=9;
noisel2_cond1=1.5;

maxj1_cond2=7;
noisel1_cond2=1.5;
maxj2_cond2=8;
noisel2_cond2=1.5;


X(1,:) =[maxj1_cond1     noisel1_cond1 maxj2_cond1    noisel2_cond1];
X(2,:)=[maxj1_cond2     noisel1_cond2 maxj2_cond2    noisel2_cond2];

simulation_coh_func(sim_dir,label_names,all_label,all_label1,all_label2,label1,X,noiseLevelr,icond,specific_tag)

                    
%% statistics


do_sim_stats(sim_dir,all_label1,all_label2,X,noiseLevelr,specific_tag)

sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/';

cluster_coh_eval(all_label1,all_label2,X,sim_dir,noiseLevelr,specific_tag,sim_doc)


