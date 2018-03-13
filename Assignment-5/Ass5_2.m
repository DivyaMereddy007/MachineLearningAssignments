clear;
clear all;
clc;
load fisheriris;

%Replacing species names
for i = 1:length(species)
    if strcmp(species(i,1),'setosa')
        species(i,1) = num2cell(1);
    else 
        species(i,1) = num2cell(-1);
    end

end
numerical_species = cell2mat(species);
merged_data = horzcat(meas, numerical_species);   
clear meas;                 %delete meas
clear species;              %delete species
clear numerical_species;    %delete numerical_species
rowSize = length(merged_data(1,:));
Xi = merged_data(:,1:rowSize - 1);
Xi= zscore(Xi);
yi = merged_data(:,rowSize) ;
n = length(Xi(:,1));

%Initialize Alpha
alpha=rand(1,n-1);
alpha = alpha';
prdctSum = sum(yi(1:n-1).*alpha);
alpha(n)=(-prdctSum)/yi(n);

%Calculate K
K=Xi*Xi';


b = zeros(n,1);
for zorro = 1:100
%Calculate w
for i = 1:n
    temp(i,:) = alpha(i)*yi(i)*Xi(i,:);
end
w=sum(temp);

%Calculate KKT
for i = 1:n
    KKT1(i) = alpha(i)*(yi(i)*(w*Xi(i,:)'+b(i))-1);
end

%Calculate i1
[val,i1] = max(KKT1);
alpha_old = alpha;
for i = 1:n
    E(i) = sum(alpha.*yi.*K(i,:)')-yi(i);
end
for i = 1:n
    e(i) = E(i1)-E(i);
end

%Calculate i2
[val,i2]=max(e);
k = K(i1,i1)+K(i2,i2)-2*K(i1,i2);
alpha(i2) = alpha_old(i2) +  yi(i2)*E(i2)/k;
if(alpha(i2) < 0.05)
    alpha(i2) = 0;
end
alpha(i1) = alpha_old(i1) + yi(i1)*yi(i2)*(alpha_old(i2)-alpha(i2));
if(alpha(i1) < 0.05)
    alpha(i1) = 0;
end

for i = 1:n
    if alpha(i) > 0
        b(i) = yi(i) - w*Xi(i, :)';
    end
end

bias = mean(b);

w = zeros(1, length(Xi(1,:)));
for i = 1:n
    w = w + alpha(i) * yi(i) * Xi(i, :);
end

truePositiveCount = 0;
falsePositiveCount = 0;
trueNegativeCount = 0;
falseNegativeCount = 0;

for i = 1:n
    output = sign(w*Xi(i, :)' + bias);
    if output == 1
       if output == yi(i)
           truePositiveCount = truePositiveCount + 1;
       else
           falsePositiveCount = falsePositiveCount + 1;
       end
    else
        if output == yi(i)
            trueNegativeCount = trueNegativeCount + 1;
        else
            falseNegativeCount = falseNegativeCount + 1;
        end
    end
end

truePositive = truePositiveCount / (truePositiveCount + falseNegativeCount);
falsePositive = falsePositiveCount / (falsePositiveCount + falseNegativeCount);
accuracy = (truePositiveCount + trueNegativeCount) / (truePositiveCount + trueNegativeCount + falseNegativeCount + falsePositiveCount);
if accuracy > .98
    break
end
end
w
b = bias
accuracy


