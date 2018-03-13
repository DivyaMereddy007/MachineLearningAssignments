classdef ID3<handle
    %ID3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        Head@node;
        Current;
        species;
        bins;
    end
    
    methods
        %constructor
        function obj = ID3(SpeciesValue, NumBins)
            if nargin < 1
                SpeciesValue = Constants.SETOSA;
            end
            obj.species = SpeciesValue;
            if nargin < 2
                NumBins = 5;
            end
            obj.bins = NumBins;
        end
        
        %set species that we want to recognise
        function set.species(obj, SpcVal)
            switch SpcVal
                case {Constants.SETOSA, Constants.VERSICOLOR, Constants.VIRGINICA}
                    obj.species = SpcVal;
                otherwise
                    error('ERROR: unkown species value');
            end
        end
        
        %start constructing the tree
        function constructTree(obj, Data)
            if nargin < 2
               error('cant construct a decision tree without data'); 
            end
            
            Attributes = [Constants.SEPAL_LENGTH Constants.SEPAL_WIDTH Constants.PETAL_LENGTH Constants.PETAL_WIDTH];
            
            obj.Head = obj.ConstructNextNode(Data, Attributes);
            
        end
        
        %test
        function FinalResult = Identify(obj, Data)
            results = {};
            for i=1:size(Data, 1)
                results(i, 1) = {obj.Head.IsItSpeciesPositive(Data(i, 1:4))};
            end
            CellData = num2cell(Data(:, 1:5));
            FinalResult  = horzcat(CellData, results);
        end
        
        %function to construct a new node
        function Node = ConstructNextNode(obj, Data, Attributes)
            %number of positive examples in data
            P_ve = Data(Data(:,5)==obj.species, :);
            
            if size(P_ve, 1) == size(Data, 1)
                %if all samples are positive
                Node = node(Constants2.NODE_RESULT, 1);
            elseif size(P_ve, 1) == 0
                %if all samples are negative
                Node = node(Constants2.NODE_RESULT, 0);
            elseif isempty(Attributes)
                %if there is no more attributes to choose from, mode +10 to
                %differentiate 1 as positive from 11 as most common
                %species at this node
                Node = node(Constants2.NODE_MOSTCOMMON, mode(Data(:,5))+10);
            else
                %in this case we select best next attribute to choose using
                %information gain
                
                %use max instead of length so that the index of
                %InfoGainValuesForAllAttributes can be the Attribute identifier too
                InfoGainValuesForAllAttributes = zeros(1, max(Attributes));
                for i=1:length(Attributes)
                    InfoGainValuesForAllAttributes(Attributes(i)) = obj.CalculateInformationGain(Data, Attributes(i));
                    %we used Attributes(i) as an index so that when we
                    %search for the max info gain, the index will be the
                    %attribute identifier
                end
                
                %with the next statement we will have "Index" storing the
                %attribute that we want to choose as next classifier based
                %on information gain
                [~, Index] = max(InfoGainValuesForAllAttributes);
                possibleValuesForSelectedAtt = unique(Data(:,Index));
                Node = node(Constants2.NODE_ATTRIBUTE, max(max(possibleValuesForSelectedAtt), obj.bins), Index);
                for i=1:length(possibleValuesForSelectedAtt)    %for each branch
                    %isolate the data that apply for that branch
                    SubData = Data(Data(:,Index)==possibleValuesForSelectedAtt(i), :);
                    Node.branches(possibleValuesForSelectedAtt(i)) = obj.ConstructNextNode(SubData, Attributes(Attributes~=Index));
                end
            end
        end
        
        %function to calculate entropy from number of +ve values and number of all
        %examples
        function Entropy = CalculateEntropy(~, P_ve, All)
            %----------------------------------------------------------
            %#fill_in: calculate positive samples proportion
            P_ratio = P_ve/All;
            %#fill_in: calculate negative samples proportion
            N_ratio = 1-P_ratio;
            %----------------------------------------------------------
            
            %----------------------------------------------------------
            %#fill_in: calculate the positive part of the entropy
            PositivePart = -(P_ratio)*log(P_ratio);
            %----------------------------------------------------------
            
            %set to zero if we get NAN or Inf
            if isnan(PositivePart)
                PositivePart = 0;
            end
            
            %----------------------------------------------------------
            %#fill_in: calculate the negative part of the entropy
            NegativePart = -(N_ratio)*log(N_ratio);
            %----------------------------------------------------------
            
            %set to zero if we get NAN or Inf
            if isnan(NegativePart)
                NegativePart = 0;
            end
            
            %----------------------------------------------------------
            %#fill_in: calculate entropy
            Entropy = PositivePart + NegativePart;
            %----------------------------------------------------------
        end
        
        %a function to calculate the the sum of (Sv/S)*Entropy(Sv)
        function Sum = SumForInfoGain(obj, Data, Attribute)
            %get all possible values for the attribute
            values = unique(Data(:, Attribute));
            %number of samples (S)
            NumOfAllSamples = size(Data, 1);
            Sum = 0;
            for i = 1:length(values)
                SubData = Data(Data(:,Attribute)==values(i), :);
                %the positive in the sub data(Sv)
                Num_P_ve_SubData = size(SubData(SubData(:,5)==obj.species, :), 1);
                %number of all samples +ve and -ve in the subdata
                NumAll_SubData = size(SubData, 1);
                Sum = Sum + (size(SubData, 1)/NumOfAllSamples)*obj.CalculateEntropy(Num_P_ve_SubData, NumAll_SubData);
            end
        end
        
        %function to calculate info gain
        function InfoGain = CalculateInformationGain(obj, Data, Attribute)
            P_ve_Rows = Data((Data(:,5) == obj.species), :);
            %number of positive
            Num_P_ve = size(P_ve_Rows , 1);
            %total number
            SizeAll = size(Data, 1);
            %calculate entropy
            entropy = obj.CalculateEntropy(Num_P_ve, SizeAll)
            
            %----------------------------------------------------------
            %#fill_in: calculate the information gain (using the value of entropy and the function obj.SumForInfoGain)
            InfoGain = entropy - SumForInfoGain(obj, Data, Attribute);
            %----------------------------------------------------------
        end
    end
    
end

