%data exploration on drug consumption dataset
%-----------by Sarika Kshatriya
%----------IE 6318:003

% User=1 and Non-User=0
clear all; clc; close all; 

%-----1.Load Raw Data----------%
% Load feat and label from drug_consumption.txt in to the workspace
%get all the features
drugUserData = load(['drug_consumption.txt']);

%ID is not useful as its just counting of numbers 
ID = drugUserData(:, 1);%feature not selected for analysis
age = drugUserData(:, 2);
gender = drugUserData(:, 3);
education = drugUserData(:, 4);

%--------------features ----------------------------%
country = drugUserData(:, 5);
ethnicity = drugUserData(:, 6);

%--------------remaining features selected----------------------------%
Nscore = drugUserData(:, 7);%NEO-FFI-R Neuroticism
Escore = drugUserData(:, 8);%NEO-FFI-R Extraversion
Oscore = drugUserData(:, 9);%NEO-FFI-R Openness to experience
Ascore = drugUserData(:, 10);%NEO-FFI-R Agreeableness.
Cscore = drugUserData(:,11);%NEO-FFI-R Conscientiousness
Impulsive=drugUserData(:,12);%impulsiveness measured by BIS-11
SS=drugUserData(:,13);%sensation seeing measured by ImpSS

%------------------drugs list----------------------------------------%
alcohol=drugUserData(:,14);
amphet=drugUserData(:,15);%amphetamines consumption
amyl=drugUserData(:,16);%amyl nitrite consumption
benzos=drugUserData(:,17);%benzodiazepine consumption
caff=drugUserData(:,18);%caffeine consumption
cannabis=drugUserData(:,19);
choc=drugUserData(:,20);%chocolate consumption
coke=drugUserData(:,21);%cocaine consumption
crack=drugUserData(:,22);
ecstacy=drugUserData(:,23);
heroin=drugUserData(:,24);
ketamine=drugUserData(:,25);
legalh=drugUserData(:,26);
LSD=drugUserData(:,27);
meth=drugUserData(:,28);%methadone consumption
mushroom=drugUserData(:,29);%magic mushrooms consumption    
nicotine=drugUserData(:,30);
semer=drugUserData(:,31);%Semeron consumption
VSA=drugUserData(:,32);%volatile substance abuse consumption

%--------------all legal and illegal drugs-------------------------%
allDrugs=drugUserData(:,14:end);
allPersonalInfo=drugUserData(:,2:6);

%-----------------------------------------------------------------------%
%check is there any missing data
data=readtable('drug_consumption.txt');
summary(data);
save('DataSummary.txt','data');

%-----------------------------------------------------------------------%
%-----2.Data Exploration ----------%
%plot shows highest teenager percentage 
figure;%fig1
histogram(age);
xticks([18 25 35 45 55 65]);
xticklabels({'18-24','25-34','35-44','45-54','55-64','65+'});
title('Age plot showing highest teenager percentage ');
xlabel('age');
ylabel('No. of users');
savefig('PlotAge.fig');

%-----------------------------------------------------------------------%
%plots shows drug users are highly educated people
%people who are  having Professional certificate/ diploma,University
%degrees are considered as higly educated people
educationData=[];
low=0;high=0;
for i=1:length(education)
if education(i) < -0.05921
   low=low+1;
else
   high=high+1;
end
educationData=[low,high];
end
figure;%fig2
pie(educationData,{'low','high'});
savefig('PlotEducation.fig');
%-----------------------------------------------------------------------%

%plot shows how gender is required feature
figure;%fig3
h=histogram(gender);
xticks([-0.5 0.5]);
xticklabels({'Male','Female'});
title('Gender Plot','fontsize', 15, 'fontweight', 'bold');
xlabel('Gender');
ylabel('users');
h.NumBins=3;
h.FaceColor = 'b';
h.EdgeColor = 'm';
savefig('PlotGender.fig');

%-----------------------------------------------------------------------%
%-----------3D SCATTER PLOT---------------------------------%
%figure;%fig4
scatter3(age,gender,education, [], alcohol);
xlabel('age')
ylabel('gender')
zlabel('education')
title('3D Scatter Plot of 3 Attributes with Classes')
legend('User', 'Non User');
savefig('Scatter3D_alcohol.fig');

%----------------------------------------------------------------------%
%------------check the FFM data----------------------------------------%

figure;%fig5
meanN=mean(Nscore)
meanE=mean(Escore)
meanO=mean(Oscore)
meanA=mean(Ascore)
meanC=mean(Cscore)
mean=[meanN;meanE;meanO;meanA;meanC];
barh(mean,0.4,'FaceColor','cyan');
title('Plots of FFM means');
ylabel('Nscore     Escore     Oscore     Ascore    Cscore ');
xlabel('FFM means');
savefig('FFMMeans.fig');



%----------------------------------------------------------------------%
%-------------Parallel coordinates plot of the 2 attributes------------%
% for impulsiveness measured by BIS-11 and
%sensation seeing measured by ImpSS
figure;%fig6
pnames=char('Impulsive','SS');
parallelcoords(drugUserData(:,12:13),'group',semer,'standardize','on','labels',pnames);
title('Parallel coordinates for semer');
savefig('parallelcoords_semer.fig');

figure;%fig7
parallelcoords(drugUserData(:,12:13),'group',choc,'labels',pnames);
title('Parallel coordinates for choclate');
savefig('parallelcoords_choc.fig');

%----------------------------------------------------------------------%
%divide data into legal and illegal drugs
%legal:alcohol,chocolate,caffeine
%illegal:amphet, amyl, benzos, cannabis,  coke,  crack, ecstasy, heroin,
%ketamine, legalh, LSD, meth, mushrooms, nicotine,semer,VSA
figure;%fig8
legalDrugs=drugUserData(:,14:18:20);
illegalDrugs=drugUserData(:,15:16:17:19:21:22:23:24:25:26:27:28:29:30:31:32);
h1=histogram(legalDrugs);
h1.FaceColor = 'g';
h1.EdgeColor = 'r';
hold on;
h2=histogram(illegalDrugs);
h2.FaceColor = 'c';
h2.EdgeColor = 'r';
title('Drugs consumption of Legal and Illegal drugs');
legend('Legal drugs','Illegal drugs');
xlabel('NonUser:0                      User:1 ');
savefig('Legal_illegal.fig');

%----------------------------------------------------------------------%
%check users for all drugs
figure;%fig9
alldrugUsers=[];
for i=14:1:32
    idx = find(drugUserData(:,i)==1);
    drugCount=length(idx);
    alldrugUsers=[alldrugUsers,drugCount];
end
bar(alldrugUsers);
title('All drugs Plot');
plot(alldrugUsers,'b-o');
xlabel('drugs');
ylabel('users');
title('Plot all drugs consumption');
names = {'alcohol','amphet','amyl','benzos','caff','cannabis','choc','coke','crack','ecstacy','heroin','ketamine','legalh','LSD','meth','mushroom','nicotine','semer','VSA'};
set(gca,'xticklabel',names);
xtickangle(45);
xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19]);
savefig('AllDrugsPlot.fig');


%----------------------------------------------------------------------%
%-----2.Data Exploration for correlation----------%
%check nicotine users by age
figure;%fig10
idx0 = find(nicotine==0); 
X1 = age(idx0,1);
idx1 = find(nicotine==1);
X2 = age(idx1,1);

histogram(X1,'facecolor','c');
hold on;
histogram(X2);
xticks([18 25 35 45 55 65]);
xticklabels({'18-24','25-34','35-44','45-54','55-64','65+'});
title('Nicotine Users by Age ');
xlabel('age');
ylabel('No. of users');
legend('Non-Users','Users');
savefig('agenicotine.fig');

%----------------------------------------------------------------------%
%check ecstacy users by age
figure;%fig11
idx0 = find(ecstacy==0); 
X1 = age(idx0,1);
idx1 = find(ecstacy==1);
X2 = age(idx1,1);

histogram(X1,'facecolor','c');
hold on;
histogram(X2);
xticks([18 25 35 45 55 65]);
xticklabels({'18-24','25-34','35-44','45-54','55-64','65+'});
title('ecstacy Users by Age ');
xlabel('age');
ylabel('No. of users');
legend('Non-Users','Users');
savefig('ageEcstacy.fig');

%----------------------------------------------------------------------%
%consumption of alcohol based on gender
figure;%fig12
histogram2(gender,alcohol,'FaceColor','flat');
colorbar;
xlabel('Female(-o.5)Male(0.5)');
ylabel('NonUser(0)  User(1)');
title('Consumption of alcohol based on gender');
savefig('GenderAlcohol.fig');

%----------------------------------------------------------------------%
%consumption of caffine based on gender
figure;%fig13
histogram2(gender,caff,'FaceColor','flat');
colorbar;
xlabel('Female(-o.5)Male(0.5)');
ylabel('NonUser(0)  User(1)');
title('Consumption of caff based on gender');
savefig('GenderCaff.fig');

%----------------------------------------------------------------------%
%education feture affect on different drugs consumption
figure;%fig14
subplot(2,2,1);
histogram2(education,crack,'facecolor','m');
title('crack users','Color', 'm');

subplot(2,2,2);
histogram2(education,choc,'facecolor','c');
title('choc users','Color', 'c');

subplot(2,2,3);
histogram2(education,heroin,'facecolor','b');
title('heroin users','Color', 'b');

subplot(2,2,4);
histogram2(education,alcohol,'facecolor','g');
title('alcohol users','Color', 'g');
savefig('EducationEffect.fig');

%------------------------------------------------%
%----------------------------------------------------------------------%
%2d scatter plot for the 5 attributes of FFM for alcohol 
figure;%fig15
FFM=[Nscore,Escore,Oscore,Ascore,Cscore];
names = char('Nscore','Escore','Oscore','Ascore','Cscore');
gplotmatrix(FFM,[],alcohol,'','',[],'on','none',names,'');
title('2d scatter plot for the 5 attributes of FFM for alcohol');
savefig('2D_FFM_alcohol.fig');

%----------------------------------------------------------------------%
%Visualization of the feature matrix
%personality traits of the Five Factor Model (FFM) N,E,O,A,C
figure;%fig16
FFM=[Nscore,Escore,Oscore,Ascore,Cscore];
corrplot(FFM);
savefig('FFM_Correlation.fig');

%-------------------correlation pleiades-------------------------------%
%Three correlation pleiades were identifed,
%named by the central drug in the pleiade: ecstasy, heroin, and benzodiazepines pleiades
%The heroin pleiad includes crack, cocaine, methadone, and heroin;
%The ecstasy pleiad consists of amphetamines, cannabis, cocaine, ketamine, LSD,
%magic mushrooms, legal highs, and ecstasy;
% The benzodiazepines pleiad contains methadone, amphetamines, cocaine, and benzodiazepines.
heroin_pleiad=[coke,crack,heroin,meth];
ecstasy_pleiad=[amphet,cannabis,coke,ecstacy,ketamine,legalh,LSD,mushroom];
benzos_pleiad=[amphet,benzos,coke,meth];
figure;%fig17
hp1=histogram(heroin_pleiad);
hp1.FaceColor = 'g';
hp1.EdgeColor = 'r';
hold on;
hp2=histogram(ecstasy_pleiad);
hp2.FaceColor = 'm';
hp2.EdgeColor = 'r';
hold on;
hp3=histogram(benzos_pleiad);
hp3.FaceColor = 'c';
hp3.EdgeColor = 'r';
title('Drugs consumption of three different pleiad');
legend('heroin pleiad','ecstasy pleiad','benzos pleiad');
xlabel('NonUser:0                     User:1 ');
savefig('3Pleiades.fig');

%----------------------------------------------------------------------%
% correlation matrix of the 3 pleiad and visualize the correlation matrix.
figure;%fig18
imagesc(corrcoef(heroin_pleiad));
colorbar;
title('Correlation Matrix for heroin pleiad');
savefig('heroin_pleiad.fig');
%----------------------------------------------------------------------%
figure;%fig19
imagesc(corrcoef(ecstasy_pleiad));
colorbar('southoutside')
title('Correlation Matrix for ecstasy pleiad');
savefig('ecstasy_pleiad.fig');

%----------------------------------------------------------------------%
figure;%fig20
imagesc(corrcoef(benzos_pleiad));
colorbar('Direction','reverse')
title('Correlation Matrix for benzos pleiad');
savefig('benzos_pleiad.fig');
%----------------------------------------------------------------------%

%----------------------------------------------------------------------%
%for each pleiad check the highly used drug
%-----------------heroin pleid---------------------------------%
figure;%fig21
subplot(2,2,1);
histogram(coke,'facecolor','g');
xlabel('NonUser:0                     User:1 ');
title('coke');
subplot(2,2,2);
histogram(crack,'facecolor','m');
xlabel('NonUser:0                     User:1 ');
title('crack');
subplot(2,2,3);
histogram(heroin,'facecolor','c');
xlabel('NonUser:0                     User:1 ');
title('heroin');
subplot(2,2,4);
histogram(meth);
xlabel('NonUser:0                     User:1 ');
title('meth');
savefig('AllHeroinPleiad.fig');

%-----------------ecstasy pleid---------------------------------%
figure;%fig.22
subplot(3,3,1);
histogram(amphet,'facecolor','g');
xlabel('NonUser:0                     User:1 ');
title('amphet');
subplot(3,3,2);
histogram(cannabis,'facecolor','m');
xlabel('NonUser:0                     User:1 ');
title('cannabis');
subplot(3,3,3);
histogram(coke,'facecolor','c');
xlabel('NonUser:0                     User:1 ');
title('coke');
subplot(3,3,4);
histogram(ecstacy);
xlabel('NonUser:0                     User:1 ');
title('ecstacy');
subplot(3,3,5);
histogram(ketamine,'facecolor','g');
xlabel('NonUser:0                     User:1 ');
title('ketamine');
subplot(3,3,6);
histogram(legalh,'facecolor','m');
xlabel('NonUser:0                     User:1 ');
title('legalh');
subplot(3,3,7);
histogram(LSD,'facecolor','c');
xlabel('NonUser:0                     User:1 ');
title('LSD');
subplot(3,3,8);
histogram(mushroom);
xlabel('NonUser:0                     User:1 ');
title('mushroom');
savefig('AllecstacyPleiad.fig');
%----------------------------------------------------------------------%
%-----------------benzos pleid---------------------------------%
figure;%fig.23
subplot(2,2,1);
histogram(amphet,'facecolor','g');
xlabel('NonUser:0                     User:1 ');
title('amphet');
subplot(2,2,2);
histogram(benzos,'facecolor','m');
xlabel('NonUser:0                     User:1 ');
title('benzos');
subplot(2,2,3);
histogram(coke,'facecolor','c');
xlabel('NonUser:0                     User:1 ');
title('coke');
subplot(2,2,4);
histogram(meth);
xlabel('NonUser:0                     User:1 ');
title('meth');
savefig('AllbenzosPleiad.fig');