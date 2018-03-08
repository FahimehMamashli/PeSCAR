function Coh_A=sim_compute_Coh_wholecortex(data_cortex,label,fname_inv)

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
inv = mne_read_inverse_operator(fname_inv);

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


%nepochs_A=size(data_cortex,3);

Coher=zeros(length(srcind),size(data_cortex,1),size(data_cortex,2),'single');


for j=1:length(srcind) 
    TF2=squeeze(data_cortex(srcind(j),:,:));
    TF2=permute(repmat(TF2,[1 1 size(data_cortex,1) ]),[3 1 2]);
    Coh=data_cortex.*conj(TF2);
    
    Coher(j,:,:)=abs(squeeze((mean(Coh,3)))./sqrt((squeeze(mean(abs(data_cortex).^2,3))).*(squeeze(mean(abs(TF2).^2,3)))));
    clear TF2
end

Coh_A=squeeze(mean(Coher));









