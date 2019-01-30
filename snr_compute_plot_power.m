clear all
clc
close all

snr=[0.07 0.06 .05 ];
%snr=[0.1];.04 0.03

sim_dir='/autofs/space/meghnn_001/users/fahimeh/simulations/';
sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/SNR_var/';


jitter_noise(1,:)=[0 0];
jitter_noise(2,:)=[0 0];
noiseLevelr=1;



parts=[5 7 9 11 13];
subs=[1 2 3 3 4];
S={'blue','red','green','cyan'};

iparts=3;
sub_num=subs(iparts);
P=parts(iparts);



for i_power=1:100
    
    
    
    
  %  specific_tag=['templ_tempr_' num2str(sub_num) 'sub_norand_15to20f_8subj_stg' num2str(parts(iparts)) 'parts_Restvar_' num2str(i_power)];
    
     %specific_tag=['per3_' num2str(sub_num) 'sub' num2str(parts(iparts)) 'Restvar_' num2str(i_power)];
   
      specific_tag=['varsubj_' num2str(sub_num) 'sub_stg' num2str(parts(iparts)) 'Restvar_' num2str(i_power)];
   
     
    
    load([sim_dir 'power_analysis_varsubj_' num2str(i_power) '.mat'])
    
    
    tag=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
        '_snr_' num2str(SNR) '_' specific_tag];
    
    for isubj=1:8
        
        
        for icond=1:2
            
            tt=load([sim_dir 'sensordata_subj_' num2str(isubj) '_cond_' num2str(icond)  '_' tag '.mat']);
            
            D(isubj,icond,:)=mean(abs(tt.SensorData));
            
        end
        
        signal=squeeze(D(isubj,1,:));
        noise=squeeze(D(isubj,2,:));
        
        %signal=mean(signal(270:390));
        signal=mean(signal(290:350));        
        noise=mean(noise);
        snr_subj(isubj,i_power)= 20*log10(signal/noise);
        
        
        
        %         G1=squeeze((D(:,1,:)));
        %         G2=squeeze((D(:,2,:)));
        %
        %         G1=G1-repmat(mean(G1(:,1:100),2),1,size(D,3));
        %         G2=G2-repmat(mean(G2(:,1:100),2),1,size(D,3));
        %
        %         subplot(2,2,isnr)
        %         times=tt.time;
        %         cfg.line_style='-';
        %         plot_shadederror_input_color(G1,times,S{2},cfg)
        %         hold on
        %         cfg.line_style='-';
        %         plot_shadederror_input_color(G2,times,S{1},cfg)
        %         xlim([0 0.6])
        %          ylim([-1*1e-13 6*1e-13])
        % %
        %          Sn(iparts,isnr)=round(median(snr_subj(:,isnr))*10)./10;
        %
        %         title(['SNR = ' num2str(Sn) ' dB'])
        %         set(gca,'FontSize',10)
        
    end
    
    
    
end
% print([sim_doc 'time_series_snr_var'],'-dpdf')
%legend([num2str(Sn(1))],'',[num2str(Sn(2))],'',[num2str(Sn(3))],'',[num2str(Sn(4))])
%set(gca,'FontSize',18)
save([sim_dir 'snr_' specific_tag '.mat'],'snr_subj')

