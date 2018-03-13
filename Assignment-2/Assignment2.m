clear all;
clear;
clc;

%--------------------  Loading the input matrix---------------------------
load('hm2data2.mat')
X = data;
Y = X(:,4);

%----------------------Normalizing the dataset--------------------------
muX = mean(X);
stdX = std(X);
m=length(X);
repstd=repmat(stdX,m,1);
repmu=repmat(muX, m, 1);
standardizedX = (X-repmu)./repstd;
[mean(standardizedX) ; std(standardizedX)];
X = standardizedX(:,1:3);
m = length(X);
eX = [ones(m,1) X];
alpha = 0.01;
iterations = 1500;
W = zeros(4,1);
halfSize = ceil(m/2);
trDataX = eX(1:halfSize,:);
trDataY = Y(1:halfSize,:);
tsDataX = eX(halfSize+1:m,:);
tsDataY = Y(halfSize+1:m,:);

%--------------------------Regularization----------------------------------
WList= [];
i = 0.01;
lambda =logspace(-2,1,25);
for i= 1 : length(lambda)
 WList = [WList,gradientDescent2(trDataX, trDataY, W, alpha, lambda(i), iterations)];
end
WList = WList';

%----------------------------------Get lambda-------------------
costList = [];
minCost = computeCost2(trDataX, trDataY,WList(1,:)',lambda(1));
for i = 1:length(lambda)
    costList = [costList, computeCost2(trDataX, trDataY,WList(i,:)',lambda(i))];
end
[minValue,minIndex] = min(costList);
lambdaVal = lambda(minIndex)


%---------------Eliminating the least relevant column------------------
[Min,Index]=min(mean(WList));
trDataX;
trDataX(:,Index)=[];
eX(:,Index)=[];
trainLength = ceil(m/2);
testLength = m - trainLength;

%--------------------------Cross Validation ------------------------------
W = zeros(length(eX(1,:)),1);
deg1Cost = crossValidation3Fold(eX, Y, W, alpha, iterations)
deg2Polynomial = [eX,eX(:,2).*eX(:,3),eX(:,2:end).^2];
W=zeros(length(deg2Polynomial(1,:)),1);
deg2Cost = crossValidation3Fold(deg2Polynomial, Y, W, alpha, iterations)
if(deg1Cost > deg2Cost)
    eX = deg2Polynomial;
else
    W = zeros(length(eX(1,:)),1);
end

%--------------Plotting the errors through 100 iterations-----------------
modelingError=[];
genError = [];
for i = 1:100
    currentX = [];
    currentY = [];
    randList = randperm(m);
    for j = 1:m
        currentX = [currentX;eX(randList(j),:)];
        currentY = [currentY;Y(randList(j),:)];
    end

    trSetX = currentX(1:halfSize,:);
    trSetY = currentY(1:halfSize,:);
    tstSetX = currentX(halfSize:end,:);
    tstSetY = currentY(halfSize:end,:);
    currentW = gradientDescentB(trSetX,trSetY,W,alpha,iterations);
    x1Deg1 = linspace(-1,5,100);
    x2Deg1 = linspace(-1,5,100);
    modelingError = [modelingError,computeCostB(trSetX,trSetY,currentW)];
    genError = [genError,computeCostB(tstSetX,tstSetY,currentW)];
end

figure
plot(modelingError);
hold on;
plot(genError)
title('Error vs iterations')
xlabel('Iterations')
ylabel('Error')
hold off;

%Min-Max Calculations
MinModError = min(modelingError)
MaxModError = max(modelingError)
AvgModError = mean(modelingError)
MinGenError = min(genError)
MaxGenError = max(genError)
AvgGenError = mean(genError)

%-------------------------------Contour----------------------------------
W0_vals = linspace(-10, 30, 100);
W1_vals = linspace(-10, 20, 100);
    
%initialize J_vals to a matrix of 0's
J_vals = zeros(length(W0_vals), length(W1_vals));    

% Fill out J_vals
for i = 1:length(W0_vals)
    for j = 1:length(W1_vals)
	  t = [currentW(1); W0_vals(i);  W1_vals(j);currentW(4);currentW(5);currentW(6)];    
	  J_vals(i,j) = computeCostB(eX,Y, t);
    end
end

J_vals = J_vals';
figure;
subplot(1,2,1)
surf(W0_vals, W1_vals, J_vals)
xlabel('w_1'); ylabel('w_2');
title('Surface')

% Contour plot
subplot(1,2,2)

% Plot J_vals as 15 contours spaced logarithmically between 0.01 and 100
contour(W0_vals, W1_vals, J_vals, logspace(-5, 30, 150))
xlabel('W_1'); ylabel('W_2');
hold on;
plot(currentW(2), currentW(3), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title('Contour')

figure
plot(eX(:,2), eX*currentW,'o')
legend('X1 Feature', 'Linear Regression')
title('Linear Regression for X1, Degree=2')

hold on;
xi=-1:0.01:4;
yi=interp1(eX(:,2), eX*currentW,xi,'spline');
plot(xi,yi)
hold off;

figure
plot(eX(:,3), eX*currentW,'o')
legend('X2 Feature', 'Linear Regression')
title('Linear Regression for X2, Degree=2')
hold on;
xi=-1:0.01:5;
yi=interp1(eX(:,3), eX*currentW,xi,'spline');
plot(xi,yi)
hold off;



