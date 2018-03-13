function J = computeCost2(X, y, W, lambda)
m = length(y); % extract the number of training examples

% set up a vector of the same length to hold the hypothesis values
hX=zeros(m,1);

% You need to return the following variables correctly 
J = 0;

%hX= ......% evaluate the hypothesis
prediction = X*W;
sqrError = (prediction - y).^2;
J = sum(sqrError);
W=W.^2;
WSum = sum(W);
J=J+(lambda*WSum);
J=J/(2*m);
end
