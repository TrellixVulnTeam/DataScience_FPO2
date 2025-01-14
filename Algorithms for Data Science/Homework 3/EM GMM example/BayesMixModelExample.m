% This code has been developed for educational and research purposes.
%
% This is a three class example using the Iris data set.

clear;
clc;
close all;

weka_data = arffparser('read', 'iris.arff'); % load data provided by WEKA
X(1,:) = weka_data.sepallength.values;
X(2,:) = weka_data.sepalwidth.values;
X(3,:) = weka_data.petallength.values;
X(4,:) = weka_data.petalwidth.values;
y = [ones(1,50) ones(1,50).*2 ones(1,50).*3];

Data.X = X';
Data.Y = y';
model =  fishersMultiClassFeatureRanking(Data,1);
numFeatures = model.featureIndex(1:2);
X = Data.X(:,numFeatures)';

inx1 = find(y==1);
inx2 = find(y==2);
inx3 = find(y==3);
model.Pclass{1} = gaussianMixtureModel(X(:,inx1),'full');
model.Pclass{2} = gaussianMixtureModel(X(:,inx2),'full');
model.Pclass{3} = gaussianMixtureModel(X(:,inx3),'full');
% model.Pclass{1} = gaussianMixtureModel(X(:,inx1),'diag');
% model.Pclass{2} = gaussianMixtureModel(X(:,inx2),'diag');
% model.Pclass{3} = gaussianMixtureModel(X(:,inx3),'diag');
% model.Pclass{1} = gaussianMixtureModel(X(:,inx1),'spherical');
% model.Pclass{2} = gaussianMixtureModel(X(:,inx2),'spherical');
% model.Pclass{3} = gaussianMixtureModel(X(:,inx3),'spherical');
model.Prior = [0.33 0.34 0.33];
ypred = bayesClassifier(X,model);
CA = length(find(y==ypred))/length(y);

ax=-1:0.04:3;
ay=0:0.07:7;
[Ax,Ay] = meshgrid(linspace(-1,3,101), linspace(0,7,101));
Ax = Ax(:)';
Ay = Ay(:)';
ypred = bayesClassifier([Ax; Ay],model);

indx1 = find(ypred==1);
indx2 = find(ypred==2);
indx3 = find(ypred==3);

Mean  = model.Pclass{1,1}.Mean;
Cov  = model.Pclass{1,1}.Cov;
Prior  = 0.33;
y1 = Prior(:)'*multivariateGaussianDistribution([Ax(:)';Ay(:)'],Mean,Cov);

Mean  = model.Pclass{1,2}.Mean;
Cov  = model.Pclass{1,2}.Cov;
Prior  = 0.34;
y2 = Prior(:)'*multivariateGaussianDistribution([Ax(:)';Ay(:)'],Mean,Cov);

Mean  = model.Pclass{1,3}.Mean;
Cov  = model.Pclass{1,3}.Cov;
Prior  = 0.33;
y3 = Prior(:)'*multivariateGaussianDistribution([Ax(:)';Ay(:)'],Mean,Cov);

figure,plot(Ax(indx1),Ay(indx1),'.','Color',[204/255 204/255 1],'LineWidth',6,'MarkerSize',20)
hold on;plot(Ax(indx2),Ay(indx2),'.','Color',[249/255 219/255 219/255],'LineWidth',6,'MarkerSize',20)
hold on;plot(Ax(indx3),Ay(indx3),'.','Color',[219/255 249/255 219/255],'LineWidth',6,'MarkerSize',20)
hold on;plot(X(1,inx1),X(2,inx1),'x','Color',[0 0 1],'LineWidth',2,'MarkerSize',8)
hold on;plot(X(1,inx2),X(2,inx2),'ro','LineWidth',2,'MarkerSize',7)
hold on;plot(X(1,inx3),X(2,inx3),'g^','LineWidth',2,'MarkerSize',7)
hold on;contour(reshape(Ax,101,101), reshape(Ay,101,101),reshape(ypred,101,101),'LineColor','k');
hold on;contour(reshape(Ax,101,101), reshape(Ay,101,101),reshape(y1,101,101),'LineColor','b','LineWidth',1.5);
hold on;contour(reshape(Ax,101,101), reshape(Ay,101,101), reshape(y2,101,101),'LineColor','r','LineWidth',1.5);
hold on;contour(reshape(Ax,101,101), reshape(Ay,101,101), reshape(y3,101,101),'LineColor','g','LineWidth',1.5);

axis([0 3 0.5 7])