clear all
clc
close all

fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/list_fmm_n_goodsubjects_18July14.txt');
C=textscan(fid,'%s%s%s%s%s');

ind=1:36;
subjects=C{1,1}(ind,:);
visits=C{1,2}(ind,:);
runs=C{1,3}(ind,:);
deviant=C{1,4}(ind,:);
ASD_TD=C{1,5}(ind,:);

cfg.highpass=0.5;
cfg.lowpass=40;
cfg.protocol='fmm';
cfg.data_rootdir='/autofs/cluster/transcend/fmm';

nepochs=50;


for j=1:length(subjects)
    
    visitNo=visits{j};
    run=runs{j};
    subj=subjects{j};
    
    filename=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_',cfg.protocol,'_',num2str(run),'_',num2str(cfg.highpass) '_' num2str(cfg.lowpass),'fil-' num2str(nepochs) 'epochs-ave.fif'];
    
    data=fiff_read_evoked_all(filename);
    
    grad_data=data.evoked(1,1).epochs;
    D=mean(grad_data(:,150:200))
    
    clear data
    
end