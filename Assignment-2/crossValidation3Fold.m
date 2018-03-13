function meanJ = crossValidation3Fold(eX, Y, W, alpha, iterations)
m = length(eX);
subsetSize = round(m/3);
XSet1 = eX(1:subsetSize,:);
XSet2 = eX(subsetSize+1:subsetSize*2,:);
XSet3 = eX(2*subsetSize+1:m,:);
YSet1 = Y(1:subsetSize,:);
YSet2 = Y(subsetSize+1:subsetSize*2,:);
YSet3 = Y(2*subsetSize+1:m,:);

size([XSet1;XSet2]);
size([YSet1;YSet3]);
Set1W = gradientDescentB([XSet1], [YSet1], W, alpha, iterations);
Set2W = gradientDescentB([XSet2], [YSet2], W, alpha, iterations);
Set3W = gradientDescentB([XSet3], [YSet3], W, alpha, iterations);

costSet1 = [computeCostB(XSet3, YSet3, Set1W);computeCostB(XSet2, YSet2, Set1W)];
costSet2 = [computeCostB(XSet1, YSet1, Set2W);computeCostB(XSet3, YSet3, Set2W)];
costSet3 = [computeCostB(XSet1, YSet1, Set3W);computeCostB(XSet2, YSet2, Set3W)];

meanJ = mean([costSet1;costSet2;costSet3;]);
end