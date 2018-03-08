clear all
clc
close all

subjects={'042201','AC022','AC070','AC054','AC056','048102','AC058','AC064','038301'};

cfg1.data_rootdir='/autofs/cluster/transcend/MEG/fix/';
cfg1.protocol='fix';

for isubj=7:length(subjects)
    
    
    subj=subjects{isubj};
    visitNo='1';
    run='1';
    
    
    inv_fix_name=[cfg1.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg1.protocol '_0.1_140_calc-inverse_fixed_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif'];
   
    check=exist(inv_fix_name,'file');
    
    if check==0
    
        tic
    command1=['mne_setup_source_space  --subject  ' subj ' --ico 4 --cps --overwrite '];
    
    [st,ct]=system(command1);
    
    filtered_data=[cfg1.data_rootdir  subj '/' visitNo '/' subj '_' cfg1.protocol '_' run '_0.1_144fil_raw.fif'];
    
    mri_trans= ['/cluster/transcend/MEG/erm/' subj '/' visitNo '/' subj '_1-trans.fif'];
    
    fw_name=[cfg1.data_rootdir  subj '/' visitNo '/' subj '_' cfg1.protocol '_' run '_ico4-fwd.fif'];
    
    log_file=[cfg1.data_rootdir  subj '/' visitNo '/' subj '_' cfg1.protocol '_' run '_ico4-fwd.log'];
    
    command2=['mne_do_forward_solution --meas ' filtered_data ' --megonly --overwrite --spacing ico-4 --mri ' mri_trans ' --fwd ' fw_name ' --subject ' subj ' > ' log_file];
    
    [st,ct]=system(command2);
    
    
    %Please make sure --noiserank is correct
    [ fid, tree ] = fiff_open(filtered_data);
    [ info ] = fiff_read_proj(fid,tree);
    noise_rank=64-size(info,2);
    
    
    ind=find(strcmp(subj,subjects));
%     projs=proj_type{ind};
%     ecgeog=str2double(remove_ecgeog{ind});
    
    ecgproj=[cfg1.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg1.protocol '_' run '_ecg_proj.fif'];
    eogproj=[cfg1.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg1.protocol '_' run '_eog_proj.fif'];
   
    
%     if strcmp(projs,'checked') 
%         
%         proj_file=[cfg1.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg1.protocol '_' run '_ecgeog_checked-proj.fif'];
%     
%     elseif strcmp(projs,'eyeball') 
%        
%         eyeball_proj=[cfg1.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg1.protocol '_' run '_eyeballed_eog_proj.fif'];
%         
%         proj_file=[ecgproj ' ' eyeball_proj ' '];
%         
%     elseif ecgeog==1
%         proj_file=[ecgproj ' ' ];
%         
%     else
%                 
         proj_file=[ecgproj ' ' eogproj ' '];
%         
%     end    
%     
           
    erm_cov_file=[cfg1.data_rootdir '/' subj '/' visitNo '/' subj '_erm_1_0.1-144fil-cov.fif'];
    
    
     [ fid, tree ] = fiff_open(erm_cov_file);
     [ info_erm ] = fiff_read_proj(fid,tree);
     
%      if size(info,2)~=size(info_erm,2)
%          
%          different_projs{k}=subj;
%          k=k+1;
%          
%          save('/autofs/cluster/transcend/fahimeh/fmm/resources/erm_proj_check.mat','different_projs')
%          
%      end
   
                
    inv_loose_name=[cfg1.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg1.protocol '_0.1_144_calc-inverse_loose_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.fif .fif'];
    
    log_file=[cfg1.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg1.protocol '_0.1_144_calc-inverse_loose_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.log'];
    
    command3=['mne_do_inverse_operator --meg  --depth --loose 0.3  --noiserank ' num2str(noise_rank) ' --fwd ' fw_name '  --proj ' proj_file ...
    ' --senscov ' erm_cov_file ' --inv '  inv_loose_name ' -v >& ' log_file ];
    
    [st,ct]=system(command3);
    
    
     
    log_file=[cfg1.data_rootdir '/' subj '/' visitNo '/' subj '_' cfg1.protocol '_0.1_144_calc-inverse_fixed_ico4_weight_new_erm_megreg_0_new_MNE_proj-inv.log'];
    
     command4=['mne_do_inverse_operator --meg --fixed   --noiserank ' num2str(noise_rank) ' --fwd ' fw_name '  --proj ' proj_file ...
    ' --senscov ' erm_cov_file ' --srccov ' inv_loose_name ...
    ' --inv ' inv_fix_name  ' -v >& ' log_file ];
   
    [st,ct]=system(command4);
    
    toc
    
    end
    
end