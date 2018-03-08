function Stats=do_stats2D(G1,G2,nperm,statsmethod,alpha)

addpath /autofs/cluster/transcend/fahimeh/fm_functions/Mines/

cfg=[];
cfg.numperm=nperm;
cfg.statmethod=statsmethod;
cfg.alpha=alpha;
%cfg.conn=3;

Stats=clustterstat2D(G1,G2,cfg);
