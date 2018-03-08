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
            
            
            
            load([sim_dir 'coherence/zcoh/zcoh_subj_' num2str(isubj) '_' temporal{iLabel1}(1:end-6) '_' frontal{iLabel2}(1:end-6) '_noiserest' num2str(NoiseLevelr(1)) '_'  tag '.mat']);
            
            allzcoh(isubj,iLabel1,iLabel2,:,:)=Z_Coh;
            
        end
        
    end
    
    
end

save([sim_dir 'coherence/zcoh/allzcoh_subj_temp_front_lh_noiser_' num2str(NoiseLevelr(1)) '_' num2str(NoiseLevelr(2)) '_' tag '.mat'],'allzcoh','time','freq','NoiseLevelr','X','temporal','frontal')


