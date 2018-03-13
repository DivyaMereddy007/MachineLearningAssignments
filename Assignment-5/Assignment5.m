clear;
clear all;
clc;

load fisheriris;

%replace species names with numerical values
for i = 1:length(species)
    if strcmp(species(i,1),'setosa')
        species(i,1) = num2cell(1);
    else 
        species(i,1) = num2cell(-1);
    end

end
C = 0.5;
numerical_species = cell2mat(species);
merged_data = horzcat(meas, numerical_species);   
clear meas;                 %delete meas
clear species;              %delete species
clear numerical_species;    %delete numerical_species
rowSize = length(merged_data(1,:));
Xi = merged_data(:,1:rowSize - 1);
Xi= zscore(Xi);
yi = merged_data(:,rowSize) ;


figure
hold on
scatter(Xi(yi==1,1),Xi(yi==1,2),'.b')
scatter(Xi(yi==-1,1),Xi(yi==-1,2),'.r')
title('Linearly seperable data')
xlabel('{x_1}'),ylabel('{x_2}')
legend('Positive class','Negative class')
hold off

len = length(yi);
alpha=rand(1,len-1);
alpha = alpha';
prdctSum = sum(yi(1:len-1).*alpha);
alpha(len)=(-prdctSum)/yi(len);
syms b;
b = 0;
for j = 1:250    
w=[];
for i = 1:rowSize-1
    w=[w,alpha.*yi.*Xi(:,i)];
end
w = sum(w);
KKT = getKKT(alpha,w,Xi,yi,b)
[argvalue, i1] = max(KKT);
x1 = Xi(i1,:);
E1 = getE(1,alpha,Xi,yi,b);
E2 = getE(2,alpha,Xi,yi,b);
alpha2_old = alpha(2);
alpha1_old = alpha(1);
if yi(1) ~= yi(2)
    L = max([0 , alpha2_old - alpha1_old]);
    H = min([C, C - alpha1_old + alpha2_old]);
else
    L = max([0 , alpha1_old + alpha2_old - C]);
    H = min([C,  alpha1_old + alpha2_old]);
end
for i = 1:len
    e(i) = E1 - getE(i,alpha,Xi,yi,b);
end
[argvalue, i2] = max(e);
x2 = Xi(i2,:);
K11 = Xi(1,:)*Xi(1,:)';
K22= Xi(2,:)*Xi(2,:)';
K12 = Xi(1,:)*Xi(2,:)';
k = K11 + K22 - 2*K12;
alpha(2) = alpha(2)+(yi(2)*E2/k);
alpha(1) = alpha(1)+yi(1)*yi(2)*(alpha2_old - alpha(2));    
epsilon = 1/1000;

b1 = b - (E1 + yi(1) * (alpha(1) - alpha1_old) * K11 + yi(2) * (alpha(2) - alpha2_old) * K12);
b2 = b - (E2 + yi(1) * (alpha(1) - alpha1_old) * K12 + yi(2) * (alpha(2) - alpha2_old) * K22);

if b1 == b2
    b = b1;
else
    b = mean([b1 b2]);
end
b;
end
y=sign(w*Xi'+b);
confusionmat(yi,y);



