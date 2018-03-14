clear all
clc
close all

sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/cluster/';
sim_dir1='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/labelsize_var/';
sim_dir=sim_dir1;
%sim_dir='/cluster/transcend/fahimeh/fmm/resources/Simulations2/var_jitter/';
tag='0_0_0_0_nr_1_snr_0.1_templ_tempr_3sub_norand_15to20f_8subj_stg9parts';
%tag='10_0.5_10_0.5_nr_1_snr_1_templ_tempr_3sub_jitter_15to20f_8subj_stg9parts';
%tag='10_0.1_10_0.1_nr_1_snr_1_templ_frontl_first3sub_jitter_15to20f_8subj_stg9parts';
%tag='0_0_0_0_nr_1_snr_0.07_templ_tempr_per3_3sub_norand_15to20f_8subj_stg9parts';
% var subj
%  tag='0_0_0_0_nr_1_snr_0.06_templ_tempr_discR_varsubj_3sub_norand_15to20f_8subj_stg9parts';

nperm=250;
label_names={'superiortemporal_1-lh.label'};

tt=load([sim_dir 'nperm' num2str(nperm) '_sim_cluster3D_' tag '_seed_' label_names{1}(1:end-6) '_nomedialwall.mat']);
%/cluster/transcend/fahimeh/fmm/resources/Simulations2/var_jitter/nperm200_sim_cluster3D_10_0.5_10_0.5_nr_1_snr_1_templ_tempr_3sub_jitter_15to20f_8subj_stg9parts_seed_superiortemporal_1-lh_nomedialwall.mat

num=2;
mask=squeeze(sum(tt.stats.posclus(num).mask));
fs=600;
time=-0.25:1/fs:.75;
figure;
imagesc(time(50:550),tt.FREQ,mask);axis xy;colormap('jet');colorbar

print([sim_doc 'cluster-num-' num2str(num) '_' tag],'-dpdf')


stc = squeeze(sum(tt.stats.posclus(num).mask,2));

lh=mne_read_stc_file([sim_dir1 'wholecortex_0_0_0_0_nr_1_snr_0.06_templ_tempr_3sub_norand_15to20f_8subj_stg9parts_cond1_subj8_coh_superiortemporal_1-lh.label_towholecortex_freq_9-morph-lh.stc']);
rh=mne_read_stc_file([sim_dir1 'wholecortex_0_0_0_0_nr_1_snr_0.06_templ_tempr_3sub_norand_15to20f_8subj_stg9parts_cond1_subj8_coh_superiortemporal_1-lh.label_towholecortex_freq_9-morph-rh.stc']);


lh.tmin = time(50);
lh.data = stc(1:2562,:);
lh.tstep = 2/fs;

rh.tmin = time(50);
rh.data = stc(2563:end,:);
rh.tstep = 2/fs;

mne_write_stc_file([sim_dir 'cluster-restuls-clusnum' num2str(num) '_' tag '_' num2str(nperm) '-lh.stc'],lh)
mne_write_stc_file([sim_dir 'cluster-restuls-clusnum' num2str(num) '_' tag '_' num2str(nperm) '-rh.stc'],rh)


