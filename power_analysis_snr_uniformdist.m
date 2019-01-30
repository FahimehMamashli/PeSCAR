clear all
clc
close all


sim_dir='/autofs/space/meghnn_001/users/fahimeh/simulations/';
sim_doc='/autofs/cluster/transcend/fahimeh/fmm/doc/method_paper/Simulation/Simulation2/SNR_var/';


jitter_noise(1,:)=[0 0];
jitter_noise(2,:)=[0 0];



parts=[5 7 9 11 13];
subs=[1 2 3 3 4];
S={'blue','red','green','cyan'};

iparts=3;
sub_num=subs(iparts);
P=parts(iparts);

%%

specific_tag=['templ_tempr_' num2str(sub_num) 'sub_norand_15to20f_8subj_stg' num2str(parts(iparts)) 'parts_Restvar_' num2str(100)];

load([sim_dir 'snr_' specific_tag '.mat'])

load([sim_dir 'power_estimate_pvalues_' specific_tag '.mat'])

snr=mean(snr_subj);

Ppsrc(counter<10)=0.1;

% range 1
R1=[sum(PValue(snr<2.5 & snr~=0)<0.05)/sum(snr<2.5 & snr~=0); sum(Ppsrc(snr<2.5 & snr~=0)<0.05)/sum(snr<2.5 & snr~=0)];


% range 2
R2=[sum(PValue(snr>2.5 & snr<3.5)<0.05)/sum(snr>2.5 & snr<3.5);sum(Ppsrc(snr>2.5 & snr<3.5)<0.05)/sum(snr>2.5 & snr<3.5)];

% range 3
R3=[sum(PValue(snr>3.5 & snr<6)<0.05)/sum(snr>3.5 & snr<6);sum(Ppsrc(snr>3.5 & snr<6)<0.05)/sum(snr>3.5 & snr<6)];

R4=[sum(PValue(snr>6)<0.05)/sum(snr>6);sum(Ppsrc(snr>6)<0.05)/sum(snr>6)];

x=[mean(snr(snr<2.5 & snr~=0)) mean(snr(snr>2.5 & snr<3.5)) mean(snr(snr>3.5 & snr<6)) mean(snr(snr>6))];

figure;
plot(x,[R1(1) R2(1) R3(1) R4(1)],'LineWidth',2)
hold on
plot(x,[R1(2) R2(2) R3(2) R4(2)],'LineWidth',2)
ylim([0 1])
title('continous')
set(gca,'FontSize',12)

print([sim_doc 'power_results_' specific_tag],'-dpdf')

%figure;hist(snr(30:100),15)

%%
clear Ppsrc PValue

specific_tag=['per3_' num2str(sub_num) 'sub' num2str(parts(iparts)) 'Restvar_' num2str(100)];

%  specific_tag=['varsubj_' num2str(sub_num) 'sub_stg' num2str(parts(iparts)) 'Restvar_' num2str(i_power)];

load([sim_dir 'snr_' specific_tag '.mat'])

load([sim_dir 'power_estimate_pvalues_' specific_tag '.mat'])

snr=mean(snr_subj);

Ppsrc(counter<17)=0.1;

A=4;
% range 1
R1=[sum(PValue(snr<A & snr~=0)<0.05)/sum(snr<A & snr~=0); sum(Ppsrc(snr<A & snr~=0)<0.05)/sum(snr<A & snr~=0)]

x(1)=mean(snr(snr<A & snr~=0));
% range 2
A=4;
B=5;
R2=[sum(PValue(snr>A & snr<B)<0.05)/sum(snr>A & snr<B);sum(Ppsrc(snr>A & snr<B)<0.05)/sum(snr>A & snr<B)]

x(2)=mean(snr(snr>A & snr<B));

% range 3
A=5;
B=7;

R3=[sum(PValue(snr>A & snr<B)<0.05)/sum(snr>A & snr<B);sum(Ppsrc(snr>A & snr<B)<0.05)/sum(snr>A & snr<B)]

x(3)=mean(snr(snr>A & snr<B));

A=7;
R4=[sum(PValue(snr>A)<0.05)/sum(snr>A);sum(Ppsrc(snr>A)<0.05)/sum(snr>A)]

x(4)=mean(snr(snr>A));


figure;
plot(x,[R1(1) R2(1) R3(1) R4(1)],'LineWidth',2)
hold on
plot(x,[R1(2) R2(2) R3(2) R4(2)],'LineWidth',2)
ylim([0 1])
set(gca,'FontSize',12)

title('discontinous')

print([sim_doc 'power_results_' specific_tag],'-dpdf')

%figure;hist(snr,15)

%%
clear Ppsrc PValue counter

specific_tag=['varsubj_' num2str(sub_num) 'sub_stg' num2str(parts(iparts)) 'Restvar_' num2str(100)];

load([sim_dir 'snr_' specific_tag '.mat'])

load([sim_dir 'power_estimate_pvalues_' specific_tag '.mat'])

snr=mean(snr_subj);

Ppsrc(counter<17)=0.1;

A=4.5;
% range 1
R1=[sum(PValue(snr<A & snr~=0)<0.05)/sum(snr<A & snr~=0); sum(Ppsrc(snr<A & snr~=0)<0.05)/sum(snr<A & snr~=0)]

x(1)=mean(snr(snr<A & snr~=0));

% range 2
A=4.5;
B=5.5;
R2=[sum(PValue(snr>A & snr<B)<0.05)/sum(snr>A & snr<B);sum(Ppsrc(snr>A & snr<B)<0.05)/sum(snr>A & snr<B)]

x(2)=mean(snr(snr>A & snr<B));

% range 3
A=5.5;
B=6.5;

R3=[sum(PValue(snr>A & snr<B)<0.05)/sum(snr>A & snr<B);sum(Ppsrc(snr>A & snr<B)<0.05)/sum(snr>A & snr<B)]

x(3)=mean(snr(snr>A & snr<B));


A=10;
R4=[sum(PValue(snr>A)<0.05)/sum(snr>A);sum(Ppsrc(snr>A)<0.05)/sum(snr>A)]

x(4)=mean(snr(snr>A));

figure;
plot(x,[R1(1) R2(1) R3(1) R4(1)],'LineWidth',2)
hold on
plot(x,[R1(2) R2(2) R3(2) R4(2)],'LineWidth',2)
ylim([0 1])
set(gca,'FontSize',12)
title('var subject')

print([sim_doc 'power_results_' specific_tag],'-dpdf')

%figure;hist(snr,15)

D1=[100 100 100];
D2=[100 0.78 .66];


figure;bar([100 100;100 78;100 66])

