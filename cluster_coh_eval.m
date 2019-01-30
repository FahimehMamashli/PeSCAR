function [keep_it,count_box]=cluster_coh_eval(temporal,frontal,X,sim_dir,noiseLevelr,specific_tag,sim_doc,flagrest,SNR,cfg)

pos=zeros(length(temporal),length(frontal));
neg=zeros(length(temporal),length(frontal));

posclus=0;
negclus=0;

if ~exist('SNR','var')
    SNR=1;
end

if flagrest==1
    tag1=[ 'nr_' num2str(noiseLevelr) '_' specific_tag];
    tag2=tag1;
    
elseif flagrest==2
        icond=1;
    jitter_noise=X{icond};
    
        tag1=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
                '_snr_' num2str(SNR) '_' specific_tag];
            
            tag2=tag1;
    
else
    icond=1;
    jitter_noise=X{icond};
    tag1=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
                '_snr_' num2str(SNR) '_' specific_tag];
    
    icond=2;
    jitter_noise=X{icond};
    
    tag2=[num2str(jitter_noise(1,1)) '_' num2str(jitter_noise(1,2)) '_' num2str(jitter_noise(2,1)) '_' num2str(jitter_noise(2,2)) '_nr_' num2str(noiseLevelr) ...
                '_snr_' num2str(SNR) '_' specific_tag];
    
end



for iLabel1=1:length(temporal)
    
    for iLabel2=1:length(frontal)
        
        [iLabel1 iLabel2]
        
        
        load([sim_dir 'coherence/stats/stats_coh_' temporal{iLabel1} '_' frontal{iLabel2}   ...
            '_' tag1 '_' tag2 '.mat']);
        
        
        if ~isempty(STATS)
            
            if ~isempty(STATS.posclus)
                
                
                for iclus=1:length(STATS.posclus)
                    if STATS.posclus(iclus).pvalue<0.05
                        posclus=posclus+STATS.posclus(iclus).mask;
                        pos(iLabel1,iLabel2)=STATS.posclus(iclus).clustermass;
                        
                    end
                end
            end
            
            
            if ~isempty(STATS.negclus)
                
                for iclus=1:length(STATS.negclus)
                    if STATS.negclus(iclus).pvalue<0.05
                        negclus=negclus+STATS.negclus(iclus).mask;
                        neg(iLabel1,iLabel2)=STATS.negclus(iclus).clustermass;
                        
                    end
                end
            end
            
        end
    end
    
end



count_box=sum(sum(pos~=0));
keep_it=0;

doit=0;

if doit==1

if sum(sum(pos~=0))/(size(pos,1)*size(pos,2))<0.2 && sum(sum(pos~=0))/(size(pos,1)*size(pos,2))>0.13 
   
   keep_it=1;
else
    keep_it=0;
end

if cfg.plot==1

 cmap=colormap('jet')
 map2=cmap(32:end,:,:);

figure;
ax1=subplot(2,2,1)

imagesc(time*1000,freq,posclus,[1 20]);axis xy;colorbar
%imagesc(time*1000,freq,posclus);axis xy;colorbar
%;set(gca,'FontSize',18)
% title('cond1>cond2-posclus')
title(['snr:' tag1(18:21) '-' tag1(end-8:end)])
colormap(ax1,map2)

subplot(2,2,2)
imagesc(pos,[-3500 3500]);axis xy;colorbar;title('cond1>cond2-posclus')
%set(gca,'FontSize',18)
%colormap(map2)
colormap('jet')

ax2=subplot(2,2,3)
imagesc(time*1000,freq,negclus,[1 25]);axis xy;colorbar;
%imagesc(time*1000,freq,negclus);axis xy;colorbar;

%colormap(map2)
colormap(ax2,map2)

% title('cond2>cond1-neglcus')
%set(gca,'FontSize',18)
print([sim_doc 'masksum_' tag1 '_' tag2],'-dpdf')

ax3=subplot(2,2,4)
imagesc(neg,[-3500 3500]);axis xy;colorbar;title('cond2>cond1-neglcus')
%colormap(map2)
colormap(ax3,'jet')
%set(gca,'FontSize',18)
print([sim_doc 'Sigclus_' tag1 '_' tag2],'-dpdf')


% fprintf('posclus \n')
% frontal(find(sum(pos~=0)))
% temporal(find(sum(pos,2)))

fprintf('negclus \n')
front_subs=frontal(find(sum(neg~=0)))
temp_subs=temporal(find(sum(neg,2)))

filename=[sim_doc 'sub_labels_' tag1 '_' tag2 '.mat'];
save(filename,'front_subs','temp_subs')
end
end
