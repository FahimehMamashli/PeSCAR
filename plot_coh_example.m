clear all
clc
%close all

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/';

fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labelslh.txt');
D=textscan(fid,'%s');
label_names=D{1,1};

temporal=label_names(1:16);
frontal=label_names(17:25);

NoiseLevelr=[.065 .065];
%for icond=1:2


for isubj=1:1
    
    
    
    for iLabel1=1:length(temporal)
        
        
        for iLabel2=1:length(frontal)
            
            
            icond=1;
            jitter_noise =[7 2;10 3];

            filename=[sim_dir 'coherence/coherence_subj_' num2str(isubj) '_' temporal{iLabel1}(1:end-6) '_' frontal{iLabel2}(1:end-6) '_cond' num2str(icond) '_noiserest' num2str(NoiseLevelr(icond)) ...
                '_jitter_noiseTempFront_' num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '.mat'];
            
            load(filename);
            
            subplot(2,1,1)
            imagesc(Coh);axis xy;colorbar
            title(['cond' num2str(icond)])
            
            
            clear Coh
            
            icond=2;
            jitter_noise =[80     3;160     4];

            
            filename=[sim_dir 'coherence/coherence_subj_' num2str(isubj) '_' temporal{iLabel1}(1:end-6) '_' frontal{iLabel2}(1:end-6) '_cond' num2str(icond) '_noiserest' num2str(NoiseLevelr(icond)) ...
                '_jitter_noiseTempFront_' num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '.mat'];
            
            load(filename);
            
            subplot(2,1,2)
            imagesc(Coh);axis xy;colorbar
            title(['cond' num2str(icond)])
            
            
            clear Coh
            pause;
            
        end
    end
end

%end
