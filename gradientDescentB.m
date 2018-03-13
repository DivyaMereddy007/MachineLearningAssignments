function [W, J_history] = gradientDescentB(X, y, W, alpha, num_iters)

%GRADIENTDESCENT Performs gradient descent to learn W
%   W = GRADIENTDESCENT(X, y, W, alpha, num_iters) updates 
%by 
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1); % declare J_history and initialize to 0

for iter = 1:num_iters

% Perform a single gradient step on the parameter vector W
   h = X*W ;
 error = h - y; % m x 1 vector: unsquared difference hypothesis - y
   
 % X is m x n matrix, so to multiply by errors we need to transpose it
 % that is, X'*error
 % then scale / multiply by alpha and (1/m)
 % the sum from the formula for updating W 
 % is autmatically taken care by the matrix multplication X'*error 
    change_W = X'*error*alpha*(1/m);
   
 % update W
  W = W - change_W;
   

% compute cost for the new W
J = computeCostB(X, y, W);

    % ============================================================
    
    % Save the cost J in every iteration    
    
    J_history(iter) = J; %save current iteration cost

end %iter

end % function
