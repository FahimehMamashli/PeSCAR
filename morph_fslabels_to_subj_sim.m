clear all
clc
close all


%subjects={'042201','AC022','AC070','AC054','AC056','048102','AC058','AC064','038301'};

fid=fopen(['/eris/p41p3/transcend/fahimeh/fmm'  '/doc/txt/list_fmm' '_final.txt']);
C=textscan(fid,'%s%s%s%s%s');

subjects=C{1,1};
visits=C{1,2};
runs=C{1,3};
deviant=C{1,4};
ASD_TD=C{1,5};

%labeldir='/autofs/cluster/transcend/fahimeh/fmm/resources/Simulations2/labels/';
parts=[5 7 9 11 13];

for iparts=3:3
    
    labeldir=['/eris/p41p3/transcend/fahimeh/fmm/resources/Simulations2/labels/stg' num2str(parts(iparts)) 'part/'];
    
    
    for isubj=1:length(subjects)
        
        if str2double(ASD_TD{isubj})==0
            
            isubj
            subj=subjects{isubj};
            
            
            command=['mne_morph_labels --from fsaverage --to ' subj ' --labeldir ' labeldir  ' --smooth  5  --prefix  fsmorphedto_' subj];
            
            [ct,st]=system(command)
            
        end
    end
    
end