%----------Program to use Classification Model on all drugs----------%
%-----------by Sarika Kshatriya-----------------------------------------%
%-----------IE 6318:003-------------------------------------------------%

%binary classification on drug consumption dataset for all drugs using 
%random forest
% User=1 and Non-User=0
clear all; clc; close all; 

%------------------Load the Dataset------------------------------------%
drugUserData = load(['drug_consumption.txt']);

%select all features for classification
X=drugUserData(:, 2:13);

%-----------All drug Names-----------------------%
drugNames={'alcohol','amphet','amyl','benzos','caff','cannabis','choc','coke','crack','ecstacy','heroin','ketamine','legalh','LSD','meth','mushroom','nicotine','VSA'};

%-----declare tables,variables-------------------%
sensitivity=0;specificity=0;
RFTable=table;RandomForest=table;

%we need to start with the 14th attribute in a dataset where drug data
%starts
drugNumber=13;


for j=1:18
    if (j==18)
        drugNumber=drugNumber+2;
    else
        drugNumber=drugNumber+1;
    end
    Y=drugUserData(:,drugNumber);
%---------------------K fold Cross validation------------------------%
% used 2 folds 5 and 10
for foldSize= 5:5:10
c = cvpartition(Y,'KFold',foldSize);
%--------------------------------------------------------------------%
%for both the folds divide the dataset into training and testing set
for i=1:foldSize
    %train data
    Dtrain = X(training(c,i),:);
    %train labels
    Ltrain = Y(training(c,i));
    %tset data
    Dtest=X(test(c,i),:);
    %test labels
    Ltest=Y(test(c,i));
    
    %--------------------------------------------------------------------%
    nTrees=200;
    %Number of variables to select at random for each decision split.
    %Default is the square root of the number of variables for classification and
    %one third of the number of variables for regression. Valid values are 'all' or a positive integer.
    %Setting this argument to any valid value but 'all' invokes Breiman's random forest algorithm [1].
    Md = TreeBagger(nTrees,Dtrain,Ltrain,'Method', 'classification','NumPredictorsToSample','all');
    pred = Md.predict(Dtest);%returns character set
    %convert char to double
    Lpred = str2double(pred);
    [accuracy,sensitivity,specificity]= ModelStats(Ltest,Lpred);
    RFTableData = table(drugNames(j),foldSize,accuracy,sensitivity,specificity);
    RFTable=[RFTable;RFTableData];
    
end
   RFData = table(drugNames(j),foldSize,mean(accuracy),mean(sensitivity),mean(specificity));
   RandomForest=[RandomForest;RFData];
   RFTable=table;
   
end

end

%--------------------------------------------------------------------%
%Change table variable name to understand it better
%RandomForest.Properties.VariableNames ={'Classifier Name','Fold Size','Accuracy','Sensitivity','Sensitivity'};
%RandomForest.Properties.VariableNames{'Var1'} = 'Drug Name';
RandomForest.Properties.VariableNames{'Var3'} = 'accuracy';
RandomForest.Properties.VariableNames{'Var4'} = 'sensitivity';
RandomForest.Properties.VariableNames{'Var5'} = 'specificity';
disp('Random Forest on all drugs');
disp(RandomForest);

%-------------------------------------------------------------------------%
%Save the results in a file
filename='ResultsRandomForest';
writetable( RandomForest, [ filename '.csv'], 'Delimiter', ',', 'WriteRowNames', true);


%-------------------------------------------------------------------------%
%-----Find the drug with maximum accuracy---------------------------------%
[~,maxDrugAccuracy]=max(RandomForest.accuracy);
r=RandomForest(maxDrugAccuracy,:);
disp("Random Classifier gives Maximum Accuracy for: ");
disp(r);

%-------------------------------------------------------------------------%
%-------plot the results-------------------------
plot(RandomForest.accuracy,'r--o');
title('Random Forest Classification');
ylabel('Accuracy');
xlabel({'Drugs'});
xlim=([0 16]);
xticks([1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35] );
xtickangle(45);
xticklabels({'alcohol','amphet','amyl','benzos','caff','cannabis','choc','coke','crack','ecstacy','heroin','ketamine','legalh','LSD','meth','mushroom','nicotine','VSA'});
savefig('RandomForest.fig');

%------------------------------------------------------------------------%
%----------Function to Calculate
%accuracy,sensitivity,specificity------------------------%
function [accuracy,sensitivity,specificity]=ModelStats(Ltest,Lpred)
[conf] = confusionmat(Ltest,Lpred);
accuracy=trace(conf)/sum(conf(:));
idx1 = find(Ltest==0); 
pred1 = Lpred(idx1); 
sensitivity = length(find(pred1==0))/length(idx1); 
idx2 = find(Ltest==1); 
pred2 = Lpred(idx2); 
specificity = length(find(pred2==1))/length(idx2);
end
%--------------------------------------------------------------------%
