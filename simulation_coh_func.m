function simulation_coh_func(sim_dir,label_names,alllabel,all_label1,all_label2,label1,X,noiseLevelr,specific_tag)


addpath /cluster/transcend/scripts/MEG/Matlab_scripts/freesurfer/
addpath /cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/

%%

subjects={'042201','AC022','AC070','AC054','AC056','048102','AC058','AC064','038301'};


gradReject=1000e-13;
magReject=3e-12;

grad=1:306;
mag=3:3:306;
grad(mag)=[];


for isubj=1:8
   
    
    subj=subjects{isubj};
    
    label_dir=['/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/labels/' subj '/fsmorphedto_' subj '-'];
    
    filename1=['/autofs/cluster/transcend/MEG/fix/' subj '/1/' subj '_fix_1_144fil_raw.fif'];
    filename2=['/autofs/cluster/transcend/MEG/fix/' subj '/1/' subj '_fix_1_0.1_144fil_raw.fif'];
    
    if exist(filename1,'file')
        f=filename1;
    elseif exist(filename2,'file')
        f=filename2;
    else
        continue;
    end
    
    raw=fiff_setup_read_raw(f);
    
    fname_inv=['/autofs/cluster/transcend/MEG/fix/' subj '/1/' subj '_fix_0.1_144_fil_loose_new_erm_megreg_0_new_MNE_proj-inv.fif'];
    inv = mne_read_inverse_operator(fname_inv);
    
    fwd=mne_read_forward_solution(['/autofs/cluster/transcend/MEG/fix/' subj '/1/' subj '_fix_1-fwd.fif'],1);
    
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
    
    fprintf(' subj %s \n',num2str(isubj))
    
    nEpochs_all=150;
    nEpochs=50;
    fs=raw.info.sfreq;
    time=-0.25:1/fs:.75;
    nTime=length(time);
    
    
    ranStart=randperm(6000,1);
    [rest,T] = fiff_read_raw_segment(raw,ranStart+raw.first_samp,ranStart+raw.first_samp+nTime*nEpochs_all-1,1:306);
    rest=rest-repmat(mean(rest,2),1,size(rest,2));
    rest=reshape(rest,306,nTime,nEpochs_all);
    
    indgrej=find(squeeze(sum((sum(abs(rest(grad,:,:))>gradReject)),2)));
    indmrej=find(squeeze(sum((sum(abs(rest(mag,:,:))>magReject)),2)));
    
    indrej=[indgrej;indmrej];
    
    if ~isempty(indrej)
        rest(:,:,indrej)=[];
    end
    
    if size(rest,3)<nEpochs*2
        continue;
    else
        rest=rest(:,:,1:nEpochs*2);
    end
    
    indperm=randperm(100);
    
    
  
    for icond=1:2
        
        indp=indperm((icond-1)*nEpochs+1:nEpochs*icond);
        
        restd=rest(:,:,indp);
        
       
                
        maxj1=X(icond,1);
        noisel1=X(icond,2);
        maxj2=X(icond,3);
        noisel2=X(icond,4);
        
                        
        maxJitter=maxj1;       
        jitter=randi(maxJitter,1,nEpochs);
        freq=15:20;
        noiseLevel=noisel1;        
        varAcrossFreq=rand(length(freq),1);
        cortex=zeros(inv.nsource,nTime,nEpochs,'single');
        
       
        tt=cell(1);
        parfor iLabel=1:length(label1)
            iLabel
            tt{iLabel}=genLabelData(freq,length(srcind{iLabel}),nEpochs,jitter,time,noiseLevel,varAcrossFreq);
            
        end
        for iLabel=1:length(label1)
            cortex(srcind{iLabel},:,:)=tt{iLabel};
        end
        
        
        % condition2
        maxJitter=maxj2;
        jitter=randi(maxJitter,1,nEpochs);
        noiseLevel=noisel2;       
        varAcrossFreq=rand(length(freq),1);
        
       
        
        
        tt=cell(1);
        tic
        parfor iLabel=length(label1)+1:length(srcind)
            
            tt{iLabel}=genLabelData(freq,length(srcind{iLabel}),nEpochs,jitter,time,noiseLevel,varAcrossFreq);
            
        end
        for iLabel=length(label1)+1:length(srcind)
            cortex(srcind{iLabel},:,:)=tt{iLabel};
        end
        toc
        
        
                        
        cortex=(cortex./max(cortex(:))).*1e-8;
                               
        
        cortex=reshape(cortex,size(cortex,1),size(cortex,2)*size(cortex,3));
        cortex=fwd.sol.data*cortex;
        cortex=reshape(cortex,306,nTime,nEpochs);
        
        cortex=cortex+restd/noiseLevelr;
        
        
        tag=[num2str(X(icond,1)) '_' num2str(X(icond,2)) '_' num2str(X(icond,3)) '_' num2str(X(icond,4)) '_nr_' num2str(noiseLevelr) '_' specific_tag];
               
        
        %% sol: vertices*time*epochs
        data_input=cortex;
        nave=1;
        dSPM=0;
        pickNormal=1;
        
        
        sol = single(labelrep_cortex(data_input,fname_inv,nave,dSPM,pickNormal));
        
        S=squeeze(mean(sol,3));
        
        stem=[sim_dir 'source_stc/source_data_subj_' num2str(isubj) '_cond_' num2str(icond) '_' tag];
        tmin=time(1);
        tstep=1/fs;
        mne_write_inverse_sol_stc(stem,inv,abs(S),tmin,tstep)
        
        
        %% label time series
        isMean=0;
        isSpatial=0;
                
        for iLabel=1:length(alllabel)
            
            label=[label_dir alllabel{iLabel}];
            
            
            [labrep, rsrcind, LSrcind,SRCind] = labelmean(label,inv,sol,isMean,isSpatial);
            
            data_info.label_name=alllabel{iLabel};
            data_info.structure='vertices_time_epochs';
            
            save([sim_dir 'label_epoch/simulation_subj_' num2str(isubj) 'epochs_' alllabel{iLabel}(1:end-6) '_cond' num2str(icond) '_' tag '.mat'], ...
                'labrep','SRCind','time','fname_inv','epoch_data','data_info');
            
            clear labrep rsrcind
        end
        
        
        do_coherence(all_label1,all_label2,time,isubj,freq,icond,sim_dir,jitter_noise,tag)
        
        clear cortex
        
    end
    
end



