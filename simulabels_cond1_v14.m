clear all
clc
close all


addpath /cluster/transcend/scripts/MEG/Matlab_scripts/freesurfer/
addpath /cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/

sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/';
label_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/fslabels/038301/fsmorphedto_038301-';


%%
fname_inv='/autofs/cluster/transcend/fmm/038301/1/038301_fmm_0.1_140_fil_fixed_new_erm_megreg_0_new_MNE_proj-inv.fif';
inv = mne_read_inverse_operator(fname_inv);
fwd=mne_read_forward_solution('/autofs/cluster/transcend/fmm/038301/1/038301_fmm_1-fwd.fif',1);


% fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labelslh.txt');
% 
% D=textscan(fid,'%s');
% label_names=D{1,1};
% 
% label_names=label_names([1:9,17:25]);
% 
% temporallh=label_names(1:9);
% frontal=label_names(10:18);
fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labelslh.txt');

D=textscan(fid,'%s');
label_names=D{1,1};

alllabel=label_names;

label_names=label_names([1:3,15:18]);

temporallh=label_names(1:3);
frontal=label_names(4:7);


tempall=alllabel(1:9);
frontall=alllabel(10:18);


for iLabel=1:length(label_names)
    
    label=[label_dir label_names{iLabel}];
    
    %addpath /autofs/cluster/transcend/sheraz/scripts/freesurfer/matlab
    labverts = read_label('',label);
    % Getting only the vertex numbers. Read the help for read_label.
    % Vertex numbers are zero based.
    labverts = 1+squeeze(labverts(:,1));
    
    [~,~,lsrcind] = intersect(labverts,inv.src(1).vertno);
    [~,~,rsrcind] = intersect(labverts,inv.src(2).vertno);
    
    if(strfind(label,'lh.'))
        srcind{iLabel} = lsrcind;
        
    elseif(strfind(label,'rh.'))
        srcind{iLabel} = inv.src(1).nuse + int32(rsrcind);
        
    end
    
    clear lsrcind rsrcind
    
    
end

%%
raw=fiff_setup_read_raw('/autofs/cluster/transcend/MEG/fix/038301/1/038301_fix_1_0.1_144fil_raw.fif');
% POOL=parpool('local',16);


for isubj=1:8
    % condition1-occipital
    icond=1;
    nEpochs=50;
    maxJitter=9;
    fs=raw.info.sfreq;
    time=-0.25:1/fs:.75;
    nTime=length(time);
    jitter=randi(maxJitter,1,nEpochs);
    freq=10:30;
    noiseLevel=1.5;
    %varAcrossFreq=ones(length(freq),1);
    varAcrossFreq=rand(length(freq),1);
    cortex=zeros(inv.nsource,nTime,nEpochs,'single');
    
    jitter_noise(1,:)=[maxJitter noiseLevel];
    
    parfor iLabel=1:length(temporallh)
        iLabel
        tt{iLabel}=genLabelData(freq,length(srcind{iLabel}),nEpochs,jitter,time,noiseLevel,varAcrossFreq);
        
    end
    for iLabel=1:length(temporallh)
        cortex(srcind{iLabel},:,:)=tt{iLabel};
    end
    
    % condition2-frontal
    maxJitter=9;
    jitter=randi(maxJitter,1,nEpochs);
    noiseLevel=1.5;
    %varAcrossFreq=ones(length(freq),1);
    varAcrossFreq=rand(length(freq),1);
    
    jitter_noise(2,:)=[maxJitter noiseLevel];
    
    
    tt=cell(1);
    tic
    parfor iLabel=length(temporallh)+1:length(srcind)
        
        tt{iLabel}=genLabelData(freq,length(srcind{iLabel}),nEpochs,jitter,time,noiseLevel,varAcrossFreq);
        
    end
    for iLabel=length(temporallh)+1:length(srcind)
        cortex(srcind{iLabel},:,:)=tt{iLabel};
    end
    toc
    
    
    
    
    
    cortex=(cortex./max(cortex(:))).*1e-8;
    
    
    noiseLevelr=4;
    ranStart=randperm(6000,1);
    [rest,T] = fiff_read_raw_segment(raw,ranStart+raw.first_samp,ranStart+raw.first_samp+nTime*nEpochs-1,1:306);
    rest=rest-repmat(mean(rest,2),1,size(rest,2));
    rest=reshape(rest,306,nTime,nEpochs);
    
    cortex1=reshape(cortex,size(cortex,1),size(cortex,2)*size(cortex,3));
    data_cortex=fwd.sol.data*cortex1;
    data_cortex=reshape(data_cortex,306,nTime,nEpochs);
    
    epoch_data=data_cortex+rest/noiseLevelr;
    
    
    % get the source label time series
    
    % sol: vertices*time*epochs
    data_input=epoch_data;
    nave=1;
    dSPM=0;
    pickNormal=0;
    
    
    sol = single(labelrep_cortex(data_input,fname_inv,nave,dSPM,pickNormal));
    
    S=squeeze(mean(sol,3));
    
    stem=[sim_dir 'source_data_subj_' num2str(isubj) '_cond_' num2str(icond)];
    tmin=time(1);
    tstep=1/fs;
    mne_write_inverse_sol_stc(stem,inv,abs(S),tmin,tstep)
    
    
    isMean=0;
    isSpatial=0;
    
    
    for iLabel=1:length(alllabel)
        
        label=[label_dir alllabel{iLabel}];
        
        
        [labrep, rsrcind, LSrcind,SRCind] = labelmean(label,inv,sol,isMean,isSpatial);
        
        data_info.label_name=alllabel{iLabel};
        data_info.structure='vertices_time_epochs';
        
        save([sim_dir 'simulation_subj_' num2str(isubj) 'epochs_' alllabel{iLabel}(1:end-6) '_cond' num2str(icond) '.mat'], ...
            'labrep','SRCind','time','fname_inv','epoch_data','data_info');
        
        clear labrep rsrcind
    end
    
    
    do_coherence(tempall,frontall,time,isubj,freq,icond,sim_dir, noiseLevelr,jitter_noise)
    
    clear cortex
    
end


%%

