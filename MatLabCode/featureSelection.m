%Feature Selection on drug consumption dataset using all attributes
%----------------By Sarika Kshatriya-------------------------------
%---------------IE6318:003-----------------------------------------

clear all; clc; close all; 

%-----1.Load Raw Data----------%
% Load feat and label from drug_consumption.txt in to the workspace
%get all the features
drugUserData = load(['drug_consumption.txt']);

%ID is not useful as its just counting of numbers 

age = drugUserData(:, 2);
gender = drugUserData(:, 3);
education = drugUserData(:, 4);

%--------------features not selected----------------------------%
country = drugUserData(:, 5);%feature not selected for analysis
ethnicity = drugUserData(:, 6);%feature not selected for analysis
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

%-----------All drug Names-----------------------%
drugNames={'alcohol','amphet','amyl','benzos','caffine','cannabis','chocolate','coke','crack','ecstacy','heroin','ketamine','legalh','LSD','meth','mushroom','nicotine','VSA'};

features=table;
drugNumber=13;

for j=1:18
    if (j==18)
        drugNumber=drugNumber+2;
    else
        drugNumber=drugNumber+1;
    end
      
    X = table(age,gender,education,country,ethnicity,Nscore,Escore,Oscore,Ascore,Cscore,Impulsive,SS);

    %Grow Robust Random Forest
    t = templateTree('NumVariablesToSample','all', 'PredictorSelection','interaction-curvature');
    rng(1); % For reproducibility
    Mdl = fitrensemble(X,drugUserData(:,drugNumber),'Method','bag','NumLearningCycles',200,'Learners',t);

    %-------------------------------------------------------------------------%
    %Predictor Importance Estimation---------------
    impOOB = oobPermutedPredictorImportance(Mdl);
    
     %-------------------------------------------------------------------------%
     %Save the results in a table
    result=table(drugNames(j),impOOB(1),impOOB(2),impOOB(3),impOOB(4),impOOB(5),impOOB(6),impOOB(7),impOOB(8),impOOB(9),impOOB(10),impOOB(11),impOOB(12));
    features=[features;result];
    
    %-------------------------------------------------------------------------%
    %Plot the results in a single graph
    hold on;
    %display lines in different color for each drug
    plot(impOOB,'Color',[rand rand rand],'LineWidth',2);
    title('Selected Features for all drugs');
    xlabel('Predictor variables');
    ylabel('Importance');
    h = gca;
    h.XTickLabel = Mdl.PredictorNames;
    h.XTickLabelRotation = 45;
    h.TickLabelInterpreter = 'none';
    xticks([1 2 3 4 5 6 7 8 9 10 11 12 ]);
    legend('alcohol','amphet','amyl','benzos','caffine','cannabis','chocolate','coke','crack','ecstacy','heroin','ketamine','legalh','LSD','meth','mushroom','nicotine','VSA');
end

%-------------------------------------------------------------------------%
%Save the results in a file
filename='FeatureSelection';
writetable( features, [ filename '.csv'], 'Delimiter', ',', 'WriteRowNames', true);

