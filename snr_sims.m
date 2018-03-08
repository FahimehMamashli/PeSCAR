clear all
close all
clc

jitter_noise(1,:)=[0 0];
jitter_noise(2,:)=[0 0];

parts=[5 7 9 11 13];

noiseLevelr=1;

sub_num=3;

icond=1;

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/labelsize_var/';
sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/SNR_var/';

snr_all=[1 0.06 .05 .04 0.03];

SNR_subj=zeros(8,length(snr_all));

for iparts=3:3
        
    specific_tag=['templ_tempr_' num2str(sub_num) 'sub_norand_15to20f_8subj_stg' num2str(parts(iparts)) 'parts'];
    
    for isnr=1:length(snr_all)
        
        SNR=snr_all(isnr);
        
        tag=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
            '_snr_' num2str(SNR) '_' specific_tag];
        
        for isubj=1:8
            
            if SNR==1
            
            load([sim_dir 'snr_subj_' num2str(isubj) '_cond_' num2str(icond)  '_' tag '.mat'])
           
            else
                
            snr=importdata([sim_dir 'snr_subj_' num2str(isubj) '_cond_' num2str(icond)  '_' tag]);
            
            end
            
            SNR_subj(isubj,isnr)=snr*20;
            
        end
        
    end
    
end

plot(SNR_subj','o')
semilogy(SNR_subj','o')
% ylim([2*1e-2 20])
%ylim([0.8*1e-2 1])
% print([sim_doc 'SNR_fig'],'-dpdf')

