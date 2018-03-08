clear all
clc
close all

dir='/autofs/eris/p41p3/transcend/fahimeh/fmm/resources/Simulations2/labelsize_var/permutations/';

%load([dir 'permutation_occipital_frontal_thresh0.05_nPerm_s200_8subj_71.581.5_0000_NoiseR0.4_1.mat'])

load([dir '/permutation_0_0_0_0_nr_1_snr_1_templ_tempr_3sub_norand_15to20f_8subj_stg9parts_0_0_0_0_nr_1_snr_1_templ_tempr_3sub_norand_15to20f_8subj_stg9parts_nPerm_s500.mat'])

p_value_Allfreq_cond1=(sum(sum(sum(abs(sig_matrix_cond1_Allfreq_p(:,:,:)),3),2)>=sum(sum(abs(sig_matrix_cond1_Allfreq),2)))+1)/(size(sig_matrix_cond1_Allfreq_p(:,:,:),1)+1)

imagesc(sig_matrix_cond1_Allfreq)

p_value_Allfreq_cond2=(sum(sum(sum(abs(sig_matrix_cond2_Allfreq_p(:,:,:)),3),2)>=sum(sum(abs(sig_matrix_cond2_Allfreq),2)))+1)/(size(sig_matrix_cond2_Allfreq_p(:,:,:),1)+1)

connection=[sum((sig_matrix_cond1_Allfreq~=0),2); (sum(sig_matrix_cond1_Allfreq~=0))']