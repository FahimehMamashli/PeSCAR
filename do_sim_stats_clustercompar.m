function stats=do_sim_stats_clustercompar(sim_dir,tag,label_names,FREQ,nperm,fs)

subjects={'042201','AC022','AC070','AC054','AC056','048102','AC058','AC064','038301'};

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/



for icond=1:2
    
    for ifreq=1:length(FREQ)
        
        for isubj=1:8
            
            [icond isubj ifreq]
            
            subj = subjects{isubj};
            
            filename=[sim_dir 'wholecortex_' tag{icond} '_cond' num2str(icond) '_subj' num2str(isubj)];
            
            stc_file=[filename '_coh_' label_names{1} '_towholecortex_freq_' num2str(FREQ(ifreq)) ];
            
            if ~exist([stc_file '-morph-lh.stc'],'file')
                
            morph_coherence(stc_file,subj)
            
            end
            
            stc_out=[stc_file '-morph'];
            
            stc_lh =  mne_read_stc_file([stc_out '-lh.stc']);
            stc_rh =  mne_read_stc_file([stc_out '-rh.stc']);
            
            
            [stc_lh,stc_rh]=removeMedialWall(stc_lh,stc_rh);
            
            nfs=round(fs/6);
            fs=round(fs);
            
            lh=resample(stc_lh.data(:,50:550)',nfs,fs);
            rh=resample(stc_rh.data(:,50:550)',nfs,fs);
            
            
            DATAlh(isubj,:,:,ifreq)=lh';
            DATArh(isubj,:,:,ifreq)=rh';
            
            clear lh rh
            
        end
        
    end
    
    G{icond}=cat(2,DATAlh,DATArh);
    %Grh{icond}=DATArh;
    
    
    clear DATAlh DATArh
    
    
end


cfg1=[];
cfg1.statmethod='pairedttest';
cfg1.numperm=nperm;
cfg1.alpha=0.05;
load('/autofs/cluster/transcend/fahimeh/fm_functions/Mines/VertConn5124.mat')
cfg1.connectivity=VertConn;


G1=G{1};
G2=G{2};


fprintf('clusterstats3D running 1 \n')

tic
stats=clustterstat3D(G1,G2,cfg1);
toc

save([sim_dir 'nperm' num2str(cfg1.numperm) '_sim_cluster3D_' tag{1} '_seed_' label_names{1}(1:end-6) '_nomedialwall.mat'],'stats','-v7.3','FREQ')

clear G G1 G2