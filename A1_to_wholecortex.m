clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Coherence
addpath /autofs/cluster/transcend/scripts/MEG/Matlab_scripts/freesurfer/
addpath /autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/
addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/

cfg1.protocol = 'fmm';
cfg1.data_rootdir = '/autofs/cluster/transcend/fmm';


fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/list_fmm_n_goodsubjects_18July14.txt');
C=textscan(fid,'%s%s%s%s%s');

ind=1:36;
subjects=C{1,1}(ind,:);
visits=C{1,2}(ind,:);
runs=C{1,3}(ind,:);
deviant=C{1,4}(ind,:);
ASD_TD=C{1,5}(ind,:);


FREQ=round(logspace(0.83,1.82,20));

N=[150 50];

labeld='/autofs/cluster/transcend/fahimeh/fmm/resources/fslabelsSK/';
label1={'superiortemporal_1-lh.label'};

for isubj=1:length(subjects)
    
    if str2double(ASD_TD{isubj})==0
        
        subj = subjects{isubj};
        visitNo = visits{isubj};
        run = runs{isubj};
        
        fname_inv=strcat(cfg1.data_rootdir,'/',subj,'/',visitNo,'/',subj,'_',cfg1.protocol,'_0.1_140_calc-inverse_fixed_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif');
        
        
        for icond=1:2
            
            [isubj icond]
            
            epoch_data=[cfg1.data_rootdir '/epochMEG/' subj '_' cfg1.protocol '_VISIT_' visitNo '_run_' run '_cond_' num2str(icond) '_0.1-140fil_ds_all_epochs.mat'];
            
            data=load(epoch_data);
            
            
            max_epochs=N(icond);
            
            epoch_file=[cfg1.data_rootdir '/' subj '/' visitNo '/cond' num2str(icond) '_' num2str(max_epochs) 'epochs_indices.mat'];
            
            
            if str2double(deviant{isubj})<max_epochs && icond == 2
                max_epochs=str2double(deviant{isubj});
            end
            
            tt=load(epoch_file);
            
            indices=tt.indices;
            
            
            all_good_epochs=data.epochs_ds_all_epochs(1:306,:,indices(1:N(icond)));
            
            
            time = data.times;
            fs = data.Fs;
            
            timefreq=do_time_freq_sensor(all_good_epochs,fs,FREQ);
            
            label_dir=[labeld subj '/fsmorphedto_' subj '-' ];
            
            filename=[cfg1.data_rootdir,'/',subj,'/',visitNo,'/' subj '_wholecortex_'  '_cond' num2str(icond) ];
            
            do_source_coh(timefreq,FREQ,fname_inv,label_dir,label1,filename,icond,isubj,time,fs)
            
            
        end                
       
    end
end

