clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/

dir1={'/autofs/cluster/transcend/fmm','/autofs/space/calvin_002/users/meg/fmmn'};
dir2={'/autofs/cluster/transcend/fmm','/autofs/cluster/transcend/fmmn'};

protocols={'fmm','fmmn'};

hemisphere={'lh','rh'};

cfg1.save_sim_dir=['/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/coherence/td_coh/'];


POOL=parpool('local',15);

for iprot=1:1
    
    cfg1.protocol=protocols{iprot};
    
    cfg1.data_rootdir=dir1{iprot};
    
    cfg1.data_rootdir2=dir2{iprot};
    
    cfg1.save_dir=['/autofs/cluster/transcend/fahimeh/' cfg1.protocol '/resources/coh_stats/between_labels/temporal_frontal/'];
    
    
    fid=fopen(['/autofs/cluster/transcend/fahimeh/' cfg1.protocol '/doc/txt/list_' cfg1.protocol '_final.txt']);
    C=textscan(fid,'%s%s%s%s%s');
    
    subjects=C{1,1};
    visits=C{1,2};
    runs=C{1,3};
    deviant=C{1,4};
    ASD_TD=C{1,5};
    
    
    k1=1;k2=1;
    for isubj=1:length(subjects)
        
        
        subj=subjects{isubj};
        visitNo=visits{isubj};
        run=runs{isubj};
        
        if str2double(ASD_TD{isubj})==1
            asd_ind(k1)=isubj;
            k1=k1+1;
        else
            td_ind(k2)=isubj;
            k2=k2+1;
        end
        
    end
    
    for ihem=1:1
        
        Hem=hemisphere{ihem};
        
        tt=load([cfg1.save_dir cfg1.protocol '_temporal_frontal_' Hem '_coh_st_dev_allsubj.mat']);
        
        indt=find(tt.time>0.054,1,'first'):find(tt.time>.504,1,'first');
        
        Times=tt.time(indt)-0.054;
        
        freq=tt.freq;
        
        temporal_labels=tt.temporal_names;
        frontal_labels=tt.frontal_names;
        
        td_st=tt.allcoh_st(td_ind,:,:,:,:);
        asd_st=tt.allcoh_st(asd_ind,:,:,:,:);
        
        td_dev=tt.allcoh_dev(td_ind,:,:,:,:);
        asd_dev=tt.allcoh_dev(asd_ind,:,:,:,:);
        
        
        for iLabel1=1:9
            
            
            for iLabel2=1:length(frontal_labels)
                
                [iprot ihem iLabel1 iLabel2]
                
                nperm=250;
                statsmethod='ttest';
                ALPHA=0.05;
                
                
                % Alpha
            %    allfre=find(freq>7,1,'first'):find(freq>59,1,'first');
                G1=squeeze(td_st(:,iLabel1,iLabel2,:,indt));
                
                
                G2=squeeze(td_dev(:,iLabel1,iLabel2,:,indt));
                
                
                
                tic
                STATSAllfreq=do_stats2D(G2,G1,nperm,statsmethod,ALPHA);
                toc
                
                
                
                info='time is correct';
                
                
                
                save([cfg1.save_sim_dir 'Stats_coh_StvsDev_' cfg1.protocol '_' temporal_labels{iLabel1} '_' frontal_labels{iLabel2} '_' Hem '_250nperm_450ms_allfreq_coh_allsubj.mat'], ...
                    'STATSAllfreq','temporal_labels','frontal_labels','Times','freq','indt','nperm','info')
                
            end
            
        end
        
        
    end
    
end

delete(POOL)

