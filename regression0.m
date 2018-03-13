clear all;
close all;

% %% Dataset 1
% % X is the data set : 3 x 1 column vector
% % each row in the data set is a traning instance
% X=[1; 2; 3];
% 
% % y is the output variable: each row is the output for the corresponding
% % training instance;
% % y is a 3 x 1 vector
% y=[2;1;3];

%% Dataset 2
% Another dataset
 X=[0.86; 0.09; -0.85; 0.87; -0.44; -0.43; -1.10; 0.40; -0.96; 0.17];
 y=[2.49; 0.83; -0.25; 3.10; 0.87; 0.02; -0.12; 1.81; -0.83; 0.43];

% m: the size, i.e., the number of training samples
m = length(X(:,1)); % the length of the first column of X

%% Start regression here
% extend the data set by the bias column: 
%       Each row receives a 1 in front
% use matlab function 'ones'

eX=[ones(m,1) X]

% size of a data instance in the extended data set: 
%       length of the first row of eX, which is 1 + length of 1st row of X

nPlusOne = length(eX(1,:));  % we really do not need this explicitely...

% Now set up the weight vector w:
%   Use Matlab function 'syms' to declare symbolic variables

syms w0 w1 % we would have to use a more complicated mechanism here to set up 
            % nPlusOne symbolic variables

% Put them in a column vector
w=[w0; w1];

% inspect sizes of eX(1,:) and w
size(eX(1,:))
size(w)

% Define now the linear hypothesis
for l=1:m, hX(l) = eX(l,:)*w; end
    % Note: A better Matlab code would make a a weight matrix with rows
    % identical to w
    
% Define now the cost function / error function

Jw = sum((hX - y').^2); % dot notation means elementwise operation for vectors

% use matlab function 'gradient' 
grad=gradient(Jw)

%Inspect S
size(grad)

% Use Matlab function 'solve' to solve the equationa obtained by setting 
% gradient = 0 
[w0, w1]=solve(grad(1), grad(2));

% Inspect the solutions
w0
w1

% Now plug the solutions into hX: use Matlab function 'eval'
eval(hX)

%% PLOT RESULTS
%   1) Plot the data: (X, y)
%   2) Plot the data instances X with the hypothesis (X, hX)
%   3) Plot the line passing through (X, hX)

figure; % sets up a figure

hold on; % holds the figure in order to be able to plot on it successively

% 1)
plot(X, y, '*');

% OPTIONAL: Two plot commands will "push" our data plot away from the axes
%plot(min(X)+1,min(X)+1); 
%plot(max(X), max(X)); 

% 2)
plot(X, eval(hX), 'ro');

% 3)
plot(X', eval(hX), 'r-');

% plot(X', X', 'b--'); % plot the first bisector:uncomment for dataset 1

%%  NOW THE MATRIX BASED SOLUTION: page 37 of  my_chapter1.pdf

% Set up quantities

jTemp = eX*w - y;

J2 = 1/2*jTemp'*jTemp;
grad2 = gradient(J2);


% check:
grad22=eX'*eX*w - eX'*y

[w0, w1]=solve(grad2)

w=inv(eX'*eX)*eX'*y;
