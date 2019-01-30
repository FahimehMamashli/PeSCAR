clear all
clc
close all

 snr=[0.07 0.06 .05 ];
 %snr=[0.1];.04 0.03

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/labelsize_var/';
sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/SNR_var/';


jitter_noise(1,:)=[0 0];
jitter_noise(2,:)=[0 0];
noiseLevelr=1;



parts=[5 7 9 11 13];
subs=[1 2 3 3 4];
S={'blue','red','green','cyan'};

for iparts=3:3
    
    sub_num=subs(iparts);
    P=parts(iparts);
    
    specific_tag=['templ_tempr_per3_' num2str(sub_num) 'sub_norand_15to20f_8subj_stg' num2str(P) 'parts'];
    
    
    for isnr=1:length(snr)
        
        SNR=snr(isnr);
        
        tag=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
            '_snr_' num2str(SNR) '_' specific_tag];
        
        for isubj=1:8
            
            for icond=1:2
                
                tt=load([sim_dir 'sensordata_subj_' num2str(isubj) '_cond_' num2str(icond)  '_' tag '.mat']);
                
                D(isubj,icond,:)=mean(abs(tt.SensorData));
                
            end
            
            signal=squeeze(D(isubj,1,:));
            noise=squeeze(D(isubj,2,:));
            
            signal=mean(signal(270:390));
            noise=mean(noise);
            snr_subj(isubj,isnr)= 20*log10(signal/noise);
            
        end
        
        G1=squeeze((D(:,1,:)));
        G2=squeeze((D(:,2,:)));
        
        G1=G1-repmat(mean(G1(:,1:100),2),1,size(D,3));
        G2=G2-repmat(mean(G2(:,1:100),2),1,size(D,3));
        
        subplot(2,2,isnr)
        times=tt.time;
        cfg.line_style='-';
        plot_shadederror_input_color(G1,times,S{2},cfg)
        hold on
        cfg.line_style='-';
        plot_shadederror_input_color(G2,times,S{1},cfg)
        xlim([0 0.6])
         ylim([-1*1e-13 6*1e-13])
%         
         Sn(iparts,isnr)=round(median(snr_subj(:,isnr))*10)./10;
%         
%         title(['SNR = ' num2str(Sn) ' dB'])
%         set(gca,'FontSize',10)
        
    end
    
    
    
end
% print([sim_doc 'time_series_snr_var'],'-dpdf')
%legend([num2str(Sn(1))],'',[num2str(Sn(2))],'',[num2str(Sn(3))],'',[num2str(Sn(4))])
%set(gca,'FontSize',18)


