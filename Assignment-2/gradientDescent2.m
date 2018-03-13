function [W] = gradientDescent2(X, y, W, alpha, lambda, num_iters)
m = length(y); % number of training examples

for iter = 1:num_iters
W_temp=W.*lambda;
W_temp(1)=0;
W = W - (alpha/m)*((X')*(X*W - y)+W_temp);
end %iter
end % function
