clear all
clc
close all

fid=fopen('/autofs/cluster/transcend/fahimeh/fmm/doc/txt/simulation_labels_temp_lhrh.txt');

D=textscan(fid,'%s');
all_label=D{1,1};

sub_num=2;

label_names=D{1,1}([1:sub_num,(1:sub_num)+9]);

label1=D{1,1}(1:sub_num);

all_label1=D{1,1}(1:9);
all_label2=D{1,1}(10:18);

specific_tag=['templ_tempr_' num2str(sub_num) 'sub_first2_norand_15to20freq_8subj'];

%%
%POOL=parpool('local',8);

addpath /autofs/cluster/transcend/fahimeh/fm_functions/TimeFrequency


sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/';
noiseLevelr=1;

tag=[num2str(0) '_' num2str(0) '_' num2str(0) '_' num2str(0) '_nr_' num2str(noiseLevelr) ...
    '_' specific_tag];

isubj=1;
iLabel=1;
icond=1;
load([sim_dir 'label_epoch/simulation_subj_1epochs_superiortemporal_1-lh_cond1_0_0_0_0_nr_20_templ_tempr_2sub_first2_norand_15to20freq_8subj_rest0.mat'])

FREQ=5:55;

time_freq=zeros(size(labrep,1),size(labrep,2),length(FREQ),size(labrep,3));

subj='042201';

filename1=['/autofs/cluster/transcend/MEG/fix/' subj '/1/' subj '_fix_1_144fil_raw.fif'];
raw=fiff_setup_read_raw(filename1);

Fs=600;


for ivertex=1:size(labrep,1)
    
    TF1{1} = single(computeWaveletTransform(labrep(ivertex,:,:),Fs,FREQ,7,'morlet'));
    
    time_freq(ivertex,:,:,:)=TF1{1};
    
    name=[' '  ' vertex' num2str(ivertex) ' condition ' ' is successfully done ']
    
    clear TF1 TF2
    
end

time=-0.25:1/Fs:.75;

% compute AutoTF


tfs=permute(time_freq(:,:,:,:),[4 1 3 2]);



cfg1=[];
cfg1.times=time;
cfg1.startTime=-.2;
cfg1.endTime=0;
cfg1.Total_subtract=1;


[Total,Induced,Evoked,PLF,ITC]=ComputeAutoTF_sk(tfs,cfg1);

%sensorT=Total;
