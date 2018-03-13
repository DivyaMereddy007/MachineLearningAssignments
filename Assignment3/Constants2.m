classdef Constants2
    %a class that holds all constants values that are used in ID3 and Bayes
    %classifier

    properties(Constant = true)
        %constants for the type of the node, each node can be either a leaf
        %or a normal attribute node
        NODE_EMPTY = 0;
        NODE_RESULT = 1;
        NODE_ATTRIBUTE = 2;
        NODE_MOSTCOMMON = 3;
        
        
        
    end
end

