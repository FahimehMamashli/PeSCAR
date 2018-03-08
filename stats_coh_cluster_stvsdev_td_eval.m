%clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/

dir1={'/autofs/cluster/transcend/fmm','/autofs/space/calvin_002/users/meg/fmmn'};
dir2={'/autofs/cluster/transcend/fmm','/autofs/cluster/transcend/fmmn'};

protocols={'fmm','fmmn'};

hemisphere={'lh','rh'};

cfg1.save_sim_dir=['/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations/coherence/td_coh/'];

Thresh=0.05;

for iprot=1:1
    
    cfg1.protocol=protocols{iprot};
    
    cfg1.data_rootdir=dir1{iprot};
    
    cfg1.data_rootdir2=dir2{iprot};
    
    cfg1.save_dir=['/autofs/cluster/transcend/fahimeh/' cfg1.protocol '/resources/coh_stats/between_labels/temporal_frontal/'];
    
    %  cfg1.save_figdir=['/autofs/cluster/transcend/fahimeh/' cfg1.protocol '/doc/figures/coherence/between_labels/temp_front/August2015/allfreq/within_stORdev/'];
    
    
    for ihem=1:1
        
        Hem=hemisphere{ihem};
        
        
        mask_St=0;
        mask1_St=0;
        mask_Dev=0;
        mask1_Dev=0;
        
        sig_matrix_TD_Allfreq_St=zeros(9,9);
        sig_matrix_ASD_Allfreq_St=zeros(9,9);
        
        %
        %        tt=load([cfg1.save_dir cfg1.protocol '_temporal_frontal_' Hem '_coh_st_dev_allsubj.mat']);
        
        
        %         temporal_labels=tt.temporal_names;
        %         frontal_labels=tt.frontal_names;
        
        for iLabel1=1:9
            
            
            for iLabel2=1:9
                
                [iprot ihem]
                
                load([cfg1.save_sim_dir 'Stats_coh_StvsDev_' cfg1.protocol '_' temporal_labels{iLabel1} '_' frontal_labels{iLabel2} '_' Hem '_250nperm_450ms_allfreq_coh_allsubj.mat']);
                
                
                [clussum_pos,clussum_neg,mask_St,mask1_St]=stats_eval_cluster(STATSAllfreq,mask_St,mask1_St,Thresh);
                
                sig_matrix_TD_Allfreq_St(iLabel1,iLabel2)=clussum_pos;
                
                sig_matrix_ASD_Allfreq_St(iLabel1,iLabel2)=clussum_neg;
                
                clear clussum_pos clussum_neg
                
                
                
            end
            
        end
        
        figure;
        imagesc(Times,freq,mask_St);colorbar;title([cfg1.protocol ' St dev>st ' Hem ],'fontsize',18,'fontweight','bold');axis xy;colormap('jet')
        set(gca,'fontsize',18,'fontweight','bold')
        
        %         saveas(gcf,[cfg1.save_figdir cfg1.protocol 'Allfreq_St-TD>ASD_' Hem '_mask'],'png')
        %         print([cfg1.save_figdir cfg1.protocol 'Allfreq_St-TD>ASD_' Hem '_mask'],'-dpdf')
        
        
        figure;
        imagesc(Times,freq,mask1_St);colorbar;title([cfg1.protocol ' St st>dev ' Hem ],'fontsize',18,'fontweight','bold');axis xy;colormap('jet')
        set(gca,'fontsize',18,'fontweight','bold')
        
        figure;
        imagesc(sig_matrix_TD_Allfreq_St);axis xy;colormap('jet');title('deviant vs standard')
        set(gca,'fontsize',18,'fontweight','bold')
        
        %         saveas(gcf,[cfg1.save_figdir cfg1.protocol 'Allfreq_St-ASD>TD_' Hem '_mask'],'png')
        %         print([cfg1.save_figdir cfg1.protocol 'Allfreq_St-ASD>TD_' Hem '_mask'],'-dpdf')
        
        %         figure;
        %         imagesc(Times,freq,mask_Dev,[3 9]);axis xy;colorbar;title([cfg1.protocol ' Dev TD>ASD ' Hem ],'fontsize',18,'fontweight','bold');colormap('jet')
        %         set(gca,'fontsize',18,'fontweight','bold')
        %
        %         saveas(gcf,[cfg1.save_figdir cfg1.protocol 'Allfreq_Dev-TD>ASD_' Hem '_mask'],'png')
        %         print([cfg1.save_figdir cfg1.protocol 'Allfreq_Dev-TD>ASD_' Hem '_mask'],'-dpdf')
        %
        %
        %         figure;
        %         imagesc(Times,freq,mask1_Dev,[3 9]);axis xy;colorbar;title([cfg1.protocol ' Dev ASD>TD ' Hem ],'fontsize',18,'fontweight','bold');colormap('jet')
        %         set(gca,'fontsize',18,'fontweight','bold')
        %
        %         saveas(gcf,[cfg1.save_figdir cfg1.protocol 'Allfreq_Dev-ASD>TD_' Hem '_mask'],'png')
        %         print([cfg1.save_figdir cfg1.protocol 'Allfreq_Dev-ASD>TD_' Hem '_mask'],'-dpdf')
        
    end
    
    
end

temporal=temporal_labels(1:9);
frontal_labels(find(sum(sig_matrix_TD_Allfreq_St~=0)))
temporal(find(sum(sig_matrix_TD_Allfreq_St,2)))





