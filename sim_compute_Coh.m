function sim_compute_Coh_wholecortex(cfg,subj,freq,label_name,nepochs,label_dir,data_dir)

% Input
%subj: subject ID, string
%run: run number, integer
%freq: frequency band of intesrest, integer vector
%label_name: label name as string

% output save mat file which is vertices x times for  PL, Coh,Z-PL,Z-Coh, 
% [data_dir 'Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond1_cond2_freq_' label_name '_' num2str(freq(1)) '-' num2str(freq(end)) '.mat']
% Sheraz Khan
% me@skhan.me

% label=[label_dir label_name];

%fname_inv = strcat(inv_dir,subj,'_',cfg.protocol,'_0.1_140_calc-inverse_fixed_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif');
% fname_inv=strcat(cfg.data_rootdir,'/',subj,'/',visitNo,'/',subj,'_',cfg.protocol,'_0.1_144_calc-inverse_fixed_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif');
%   
% inv = mne_read_inverse_operator(fname_inv);

% standard condition epochs


labverts = read_label('',label);
labverts = 1+squeeze(labverts(:,1)); 

[~,~,lsrcind] = intersect(labverts,inv.src(1).vertno);
[~,~,rsrcind] = intersect(labverts,inv.src(2).vertno);

if(strfind(label,'lh.'))
    srcind = lsrcind;
    
elseif(strfind(label,'rh.'))
    srcind = inv.src(1).nuse + int32(rsrcind);
    
end



% condition 1    
cortex_cond1=[data_dir 'Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond1_freq_' num2str(freq) '_rightepochs.mat'];
 
c1=load(cortex_cond1);

nepochs_A=size(c1.cortex,3);

Coher=zeros(length(srcind),size(c1.cortex,1),size(c1.cortex,2),'single');
PL=zeros(length(srcind),size(c1.cortex,1),size(c1.cortex,2),'single');

for j=1:length(srcind) 
    TF2=squeeze(c1.cortex(srcind(j),:,:));
    TF2=permute(repmat(TF2,[1 1 size(c1.cortex,1) ]),[3 1 2]);
    Coh=c1.cortex.*conj(TF2);
    PL(j,:,:)=abs(mean((Coh./abs(Coh)),3));
    Coher(j,:,:)=abs(squeeze((mean(Coh,3)))./sqrt((squeeze(mean(abs(c1.cortex).^2,3))).*(squeeze(mean(abs(TF2).^2,3)))));
    clear TF2
end
PL_A=squeeze(mean(PL));
Coh_A=squeeze(mean(Coher));
clear Coher PL 

clear c1 




% condition 2    
cortex_cond2=[data_dir 'Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond2_freq_' num2str(freq) '_rightepochs.mat'];
c2=load(cortex_cond2);


nepochs_B=size(c2.cortex,3);
Coher=zeros(length(srcind),size(c2.cortex,1),size(c2.cortex,2),'single');
PL=zeros(length(srcind),size(c2.cortex,1),size(c2.cortex,2),'single');

for j=1:length(srcind) 
    TF2=squeeze(c2.cortex(srcind(j),:,:));
    TF2=permute(repmat(TF2,[1 1 size(c2.cortex,1) ]),[3 1 2]);
    Coh=c2.cortex.*conj(TF2);
    PL(j,:,:)=abs(mean((Coh./abs(Coh)),3));
    Coher(j,:,:)=abs(squeeze((mean(Coh,3)))./sqrt((squeeze(mean(abs(c2.cortex).^2,3))).*(squeeze(mean(abs(TF2).^2,3)))));
    clear TF2
end
PL_B=squeeze(mean(PL));
Coh_B=squeeze(mean(Coher));
clear Coher PL 

clear c2 



% Z-coherence
Z_Coh=(  ( atanh(Coh_A) - (1/(nepochs_A-2)) )  -   ( atanh(Coh_B) - (1/(nepochs_B-2)) )  ) /(sqrt(1/(nepochs_A-2)) + (1/(nepochs_B-2))) ;

Z_PL=(  ( atanh(PL_A) - (1/(nepochs_A-2)) )  -   ( atanh(PL_B) - (1/(nepochs_B-2)) )  ) /(sqrt(1/(nepochs_A-2)) + (1/(nepochs_B-2))) ;


save([data_dir 'Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond1_cond2_freq_' label_name(1:end-6) '_' num2str(freq(1)) '_' num2str(nepochs) 'rightepochs.mat'],...
    'PL_B','PL_A','Coh_B','Coh_A','Z_PL','Z_Coh','freq','label_name','nepochs_A','nepochs_B');

stemPL=[data_dir 'Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond1_cond2_freq_PL_' label_name(1:end-6) '_' num2str(freq(1)) '-' num2str(freq(end)) '-' num2str(nepochs) 'rightepochs'];
stemCoh=[data_dir 'Time_Freq/' subj '_cortex_inv_fixed_all_sensors_ds_cond1_cond2_freq_Coh_' label_name(1:end-6) '_' num2str(freq(1)) '-' num2str(freq(end)) '-' num2str(nepochs) 'rightepochs'];

tmin=-0.2;
tstep=4/600.615;
mne_write_inverse_sol_stc(stemPL,inv,Z_PL,tmin,tstep)
mne_write_inverse_sol_stc(stemCoh,inv,Z_Coh,tmin,tstep)







