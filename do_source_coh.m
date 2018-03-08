function do_source_coh(timefreq,FREQ,fname_inv,label_dir,label_names,filename,icond,isubj,time,fs)

for ifreq=1:length(FREQ)
    
    tf_freq=timefreq(:,:,ifreq,:);
    
    tf1=reshape(tf_freq,size(tf_freq,1),size(tf_freq,2),size(tf_freq,3)*size(tf_freq,4));
    
    fprintf('computing cortex for subj %s and condition %s and freq %s \n',num2str(isubj),num2str(icond),num2str(ifreq))
    
    tic
    
    data_input=tf1;
    nave=1;
    dSPM=0;
    pickNormal=1;
    
    
    sol = single(labelrep_cortex(data_input,fname_inv,nave,dSPM,pickNormal));
    
    toc
    
    
    seed_label=[label_dir label_names{1}];
    
    coh_a=sim_compute_Coh_wholecortex(sol,seed_label,fname_inv);
    
  %  Coh(:,:,ifreq)=coh_a;
    
    tmin=time(1);
    tstep=1/fs;
    
    stemCoh=[filename '_coh_' label_names{1} '_towholecortex_freq_' num2str(FREQ(ifreq)) ];
    
    inv = mne_read_inverse_operator(fname_inv);
    
    mne_write_inverse_sol_stc(stemCoh,inv,coh_a,tmin,tstep)
    
    clear sol tf1 coh_a
    
end

% filename1=[filename '_coh_' label_names{1} '_towholecortex_freq_' num2str(FREQ(1)) 'to' num2str(FREQ(end)) '.mat'];
% 
% save(filename1,'Coh','time','fs','fname_inv','pickNormal','FREQ')




