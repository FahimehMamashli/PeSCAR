clear all
clc
close all

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/
sim_dir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/';

sub_num=2;
specific_tag=['templ_tempr_' num2str(sub_num) 'sub_first2_norandomness_15to20freq'];

noiseLevelr=1;

X{1} =[0     0;0    0];
X{2} =[0     0;0    0];

nsubj=8;

icond=1;
jitter_noise=X{icond};

tag=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
        '_' specific_tag];
    
fcond1=[sim_dir 'coherence/stats/data_allsubj_coh_cond' num2str(icond) '_' tag '.mat'];

cond1=load(fcond1);


icond=2;
fcond2=[sim_dir 'coherence/stats/data_allsubj_coh_cond' num2str(icond) '_' tag '.mat'];

cond2=load(fcond2);

time=cond1.time;
freq=cond1.freq;
temporallh=cond1.temporal;
temporalrh=cond1.frontal;

nperm=250;
statsmethod='pairedttest';
ALPHA=0.05;

nPerm_s=250;

Thresh=0.05;

%%

POOL=parpool('local',30);

sig_matrix_cond1_Allfreq=zeros(length(temporallh),length(temporalrh));
sig_matrix_cond2_Allfreq=zeros(length(temporallh),length(temporalrh));


for iLabel1=1:length(temporallh)
    
    
    for iLabel2=1:length(temporalrh)
        
        
        G1=squeeze(cond1.data_subj(:,iLabel1,iLabel2,:,:));
        G2=squeeze(cond2.data_subj(:,iLabel1,iLabel2,:,:));
        
        STATS=do_stats2D(G1,G2,nperm,statsmethod,ALPHA);
        
        
        if ~isempty(STATS.posclus) && STATS.posclus(1).pvalue <Thresh
            
            clussum=0;
            for iclus=1:length(STATS.posclus)
                
                if STATS.posclus(iclus).pvalue<Thresh
                    clussum=clussum+STATS.posclus(iclus).clustermass;
                end
            end
            
            sig_matrix_cond1_Allfreq(iLabel1,iLabel2)=clussum;
            
            
        end
        
        if ~isempty(STATS.negclus) && STATS.negclus(1).pvalue <Thresh
            
            clussum=0;
            for iclus=1:length(STATS.negclus)
                
                if STATS.negclus(iclus).pvalue<Thresh
                    clussum=clussum+STATS.negclus(iclus).clustermass;
                end
            end
            
            sig_matrix_cond2_Allfreq(iLabel1,iLabel2)=clussum;
            
        end
        
        clear STATS
        
    end
    
end

%%


cond1cond2=[cond1.data_subj;cond2.data_subj];

sig_matrix_cond1_Allfreq_p=zeros(nPerm_s,length(temporallh),length(temporalrh));
sig_matrix_cond2_Allfreq_p=zeros(nPerm_s,length(temporallh),length(temporalrh));

L=size(cond1.data_subj,1);


for iPerm_s=138:nPerm_s
    
    ind_perm=randperm(size(cond1cond2,1));
    
    cond1=cond1cond2(ind_perm(1:L),:,:,:,:);
    cond2=cond1cond2(ind_perm(L+1:end),:,:,:,:);
    
        
    for iLabel1=1:length(temporallh)
        
        
        for iLabel2=1:length(temporalrh)
            
            [ iPerm_s]
            
            tic
            
            cond1D=squeeze(cond1(:,iLabel1,iLabel2,:,:));
            cond2D=squeeze(cond2(:,iLabel1,iLabel2,:,:));
            
            
            STATSAllFre=do_stats2D(cond1D,cond2D,nperm,statsmethod,ALPHA);
            
                        
            if ~isempty(STATSAllFre)
                
            if ~isempty(STATSAllFre.posclus) && STATSAllFre.posclus(1).pvalue <Thresh
                
                clussum=0;
                for iclus=1:length(STATSAllFre.posclus)
                    
                    if STATSAllFre.posclus(iclus).pvalue<Thresh
                        clussum=clussum+STATSAllFre.posclus(iclus).clustermass;
                    end
                end
                
                
                sig_matrix_cond1_Allfreq_p(iPerm_s,iLabel1,iLabel2)=clussum;
                
            end
            
            if ~isempty(STATSAllFre.negclus) && STATSAllFre.negclus(1).pvalue <Thresh
                
                clussum=0;
                for iclus=1:length(STATSAllFre.negclus)
                    
                    if STATSAllFre.negclus(iclus).pvalue<Thresh
                        clussum=clussum+STATSAllFre.negclus(iclus).clustermass;
                    end
                end
                
                sig_matrix_cond2_Allfreq_p(iPerm_s,iLabel1,iLabel2)=clussum;
                
            end
            
            end
            
            toc
            
            clear STATSAllFre
            
        end
        
    end
end


save([sim_dir 'permutations/permutation_temporallh_temporalrh_thresh' num2str(Thresh) '_nPerm_s' num2str(nPerm_s) '_' num2str(nsubj) 'subj_' tag ...
    '_NoiseR' num2str(noiseLevelr)  '.mat'], ...
    'sig_matrix_cond1_Allfreq','sig_matrix_cond1_Allfreq_p','sig_matrix_cond2_Allfreq','sig_matrix_cond2_Allfreq_p', ...
    'temporallh','temporalrh','Thresh','nPerm_s','ALPHA','time','freq')



delete(POOL)

