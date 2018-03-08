clear all
clc
close all

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/';

fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labelslh.txt');

D=textscan(fid,'%s');
label_names=D{1,1};

temporal=label_names(1:9);
frontal=label_names(10:18);

NoiseLevelr=[4 4];


%X{1} =[7 1.5;8 1.5];
%X{2} =[80     8;180     10];
X{1} =[9     1.5;9    1.5];
X{2} =[7     1.5;8     1.5];

nsubj=8;

for icond=1:2
    
    data_subj=zeros(nsubj,length(temporal),length(frontal),46,422);
    
    jitter_noise=X{icond};
    
    for isubj=1:nsubj
        
        
        
        for iLabel1=1:length(temporal)
            
            
            for iLabel2=1:length(frontal)
                
                
                
                filename=[sim_dir 'coherence/coherence_subj_' num2str(isubj) '_' temporal{iLabel1}(1:end-6) '_' frontal{iLabel2}(1:end-6) '_cond' num2str(icond) '_noiserest' num2str(NoiseLevelr(icond)) ...
                    '_jitter_noiseTempFront_' num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '.mat'];
                
                load(filename)
                
                data_subj(isubj,iLabel1,iLabel2,:,:)=Coh(5:50,91:512);
                
            end
        end
    end
    
    save([sim_dir 'coherence/data_subj_coherence_temporal_frontal_cond' num2str(icond) '_noiserest' num2str(NoiseLevelr(icond)) '_nsubj' ...
        num2str(nsubj) '_' num2str(jitter_noise(1,1)) num2str(jitter_noise(1,2)) num2str(jitter_noise(2,1)) num2str(jitter_noise(2,2)) '.mat'], ...
        'data_subj','time','freq','temporal','frontal')
    
    %     figure;
    %     imagesc(squeeze((mean(data_subj(:,5,3,:,:)))));axis xy;colorbar
end
