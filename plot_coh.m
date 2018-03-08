clear all
clc

isubj=1;icond=2
for iLabel1=1:length(temporal)
    
     
    for iLabel2=1:length(frontal)
        
        
        
           
        load([sim_dir 'coherence/coherence_subj_' num2str(isubj) '_' temporal{iLabel1}(1:end-6) '_' frontal{iLabel2}(1:end-6) '_cond' num2str(icond) '.mat'])
        imagesc(time,freq,Coh);axis xy
        pause              
    end
end

