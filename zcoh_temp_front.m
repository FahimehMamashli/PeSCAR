clear all
clc
close all

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/';


fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labelslh.txt');

D=textscan(fid,'%s');
label_names=D{1,1};

temporal=label_names(1:9);
frontal=label_names(17:25);

X{1} =[9  1.5;9 1.5];
X{2} =[7 1.5;8 1.5];

NoiseLevelr=[5 5];

tag='91.591.5_71.581.5';

for isubj=1:8
    
    for iLabel1=1:length(temporal)
        
        
        for iLabel2=1:length(frontal)
            
            [isubj iLabel1 iLabel2]
            
            icond=1;
            jitter_noise=X{icond};
            filename1=[sim_dir 'coherence/coherence_subj_' num2str(isubj) '_' temporal{iLabel1}(1:end-6) '_' frontal{iLabel2}(1:end-6) '_cond' num2str(icond) '_noiserest' num2str(NoiseLevelr(icond)) ...
                '_jitter_noiseTempFront_' num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '.mat'];
            
            icond=2;
            jitter_noise=X{icond};
            filename2=[sim_dir 'coherence/coherence_subj_' num2str(isubj) '_' temporal{iLabel1}(1:end-6) '_' frontal{iLabel2}(1:end-6) '_cond' num2str(icond) '_noiserest' num2str(NoiseLevelr(icond)) ...
                '_jitter_noiseTempFront_' num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '.mat'];
            
            
            coh_cond1=load(filename1);
            
            coh_cond2=load(filename2);
            
            
            nepochs_A=50;
            nepochs_B=50;
            
            Coh_A=coh_cond1.Coh;
            Coh_B=coh_cond2.Coh;
            
            Z_Coh=(  ( atanh(Coh_A) - (1/(nepochs_A-2)) )  -   ( atanh(Coh_B) - (1/(nepochs_B-2)) )  ) /(sqrt(1/(nepochs_A-2)) + (1/(nepochs_B-2))) ;
            
            
            
            time=coh_cond1.time;
            freq=coh_cond1.freq;
            
            info='zcoh is cond1 minus cond2';
            
            save([sim_dir 'coherence/zcoh/zcoh_subj_' num2str(isubj) '_' temporal{iLabel1}(1:end-6) '_' frontal{iLabel2}(1:end-6) '_noiserest' num2str(NoiseLevelr(icond)) '_'  tag '.mat'],'Z_Coh','time','freq','X','info','nepochs_A','nepochs_B', ...
                'temporal','frontal','NoiseLevelr','-v7.3');
            
            
        end
        
    end
    
    
end




