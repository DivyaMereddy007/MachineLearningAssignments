
classdef node<handle
    %NODE class for each node in the tree
    %   Detailed explanation goes here
    
    properties (Access = public)
        %either a result node (leaf) or another attribute based node
        type;
        %this variable store which attribute is this node for? is it
        %sepal length? sepal width? etc
        attribute;
        %if type is "RESULT node" then this property will be boolean +ve/-ve 
        %if type is "ATTRIBUTE node" then it will an array of another nodes 
        branches@node;
        label;
    end
    
    methods
        %constructor
        function obj = node(NodeType, TheValue, AttributeIdentifier)
            %default value for NodeType is attribute classification node
            %not a leaf
            if nargin < 1
                NodeType = Constants2.NODE_EMPTY;
            end
            
            %default values for MaxNumOfAttrValues. If node is result just
            %place a string in the MaxNumOfAttrValues indicating values is
            %boolean
            switch NodeType
                case Constants2.NODE_ATTRIBUTE
                    if nargin < 2
                        TheValue = 1;
                    end
                case {Constants2.NODE_MOSTCOMMON, Constants2.NODE_EMPTY, Constants2.NODE_RESULT}
                    if nargin < 2
                        TheValue = 0;
                    end
                otherwise
                    error('can not construct a new node: unkown type');
            end
            
            if nargin < 3 
                if NodeType == Constants2.NODE_ATTRIBUTE
                    AttributeIdentifier = Constants.SEPAL_LENGTH;
                else
                    AttributeIdentifier = 0;
                end 
            end

            obj.type = NodeType;
            obj.attribute = AttributeIdentifier;
            switch NodeType
                case {Constants2.NODE_RESULT, Constants2.NODE_MOSTCOMMON}
                    obj.label = TheValue;
                case Constants2.NODE_ATTRIBUTE
                    %if the node type is attribute value checker then the
                    %passed "TheValue" is the maximum number of values this
                    %atribute can take
                    %initialize the branches to be default node objects
                    %just to allocate memory to be used later for
                    %contructing these branches
                    obj.branches(1:TheValue) = node(Constants2.NODE_EMPTY);
                    %obj.branches(1:TheValue) = Node()
            end
        end
        
        %function to return result
        function result = IsItSpeciesPositive(obj, Instance)
            switch obj.type
                case {Constants2.NODE_RESULT, Constants2.NODE_MOSTCOMMON}
                    %is this node a "result node"/"mostcommon node" return its label
                    result = obj.label;
                case Constants2.NODE_EMPTY
                    %random value to indicate unkown example, never seen it before.
                    result = 99;
                case Constants2.NODE_ATTRIBUTE
                    %if not then pass the "example/instance" to the child node that
                    %is stored in an index equal to the value of the attribute of the child node
                    %for example if the the example being tested has sepal length
                    %of 3 and this node was for attribute sepal length then call
                    %the function "IsItSetosaPositive" from the node that is stored
                    %in obj.value under index = 3
                    result = obj.branches(Instance(obj.attribute)).IsItSpeciesPositive(Instance);
                otherwise
                    error('unkown node type while testing for a result');
            end
        end
        
    end
    
end

