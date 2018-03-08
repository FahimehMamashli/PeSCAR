clear all
clc

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/labelsize_var/';
tag='0_0_0_0_nr_1_snr_0.06_templ_tempr_3sub_norand_15to20f_8subj_stg9parts';
label_names={'superiortemporal_1-lh.label'};

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/

for icond=1:2
    
    
    for isubj=1:8
        
        
        
        filename=[sim_dir 'wholecortex_' tag '_cond' num2str(icond) '_subj' num2str(isubj)];
        
        filename1=[filename '_coh_' label_names{1} '_towholecortex_freq_' num2str(FREQ(1)) 'to' num2str(FREQ(end)) '.mat'];
        
        c1=load(filename1);
        
        DATA(isubj,:,:,:)=c1.Coh(:,50:550,:);
        
    end
    
    G{icond}=DATA;
    
end

clear DATA

cfg1=[];
cfg1.statmethod='pairedttest';
cfg1.numperm=1;
cfg1.alpha=0.05;
load('/autofs/cluster/transcend/fahimeh/fm_functions/Mines/VertConn.mat')
cfg1.connectivity=VertConn;


G1=G{1};
G2=G{2};

fprintf('clusterstats3D running 1 \n')

tic
stats=clustterstat3D(G1,G2,cfg1);
toc

save([sim_dir 'nperm1_sim_cluster3D_' tag '.mat'],'stats','-v7.3')

%%
tt=load('/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/labelsize_var/nperm1_sim_cluster3D_0_0_0_0_nr_1_snr_0.06_templ_tempr_3sub_norand_15to20f_8subj_stg9parts.mat');



x1=squeeze(sum(x.mask));

x1=sum(sum(tt.stats.posclus(1).mask,2),3);



mne_read_stc_file()





