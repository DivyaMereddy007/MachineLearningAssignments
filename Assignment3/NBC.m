classdef NBC<handle
    %NBC (Naïve Bayes classifier)
    %   Detailed explanation goes here
    
    properties(Access = public)
        %probabilities of attributes values given the species is setosa
        Probabilities_Given_S;
        %probabilities of attributes values given the species is not setosa
        Probabilities_Given_NS;
        %if we select a random sample from the original data what is the
        %probability that it is from the target species
        Probability_species;
        %same as above but the probability that the sample is not target
        %species
        Probability_Not_species;
        %the species we want to test for
        species;
        %number of possible values for each attribute
        Discretization_K;
        %vector storing the attributes
        Attributes;
    end
    
    methods
        %constructor
        function obj = NBC(k, Species)
            if nargin < 1
               error('can not instantiate NBC object, number of possible values for each attribute must be specified'); 
            end
            obj.Probabilities_Given_S = zeros(length(obj.Attributes), k);
            obj.Probabilities_Given_NS = zeros(length(obj.Attributes), k);
            obj.Discretization_K = k;
            
            obj.Attributes = [Constants.SEPAL_LENGTH,  Constants.SEPAL_WIDTH, Constants.PETAL_LENGTH, Constants.PETAL_WIDTH];
            
            if nargin < 2
                Species = Constants.SETOSA;
            end
            switch Species
                case {Constants.SETOSA,  Constants.VERSICOLOR, Constants.VIRGINICA}
                    obj.species = Species;
                otherwise
                    error('unkown species, can not assign NBC to that species');
            end
        end
        
        %calculate the P(ai|vi) and P(vi), in general this function prepare
        %the values that we will use to find argmax for each sample in the
        %testing data
        function PrepareProbabilities(obj, Data)
            
            %----------------------------------------------------------
            %  #fill_in: seperate samples from Data into two groups using logical indices
            %first group : samples with a label equal to obj.species
            RowsSpecies = Data(Data(:,5)==obj.species,:);
            
            %second group : other samples
            RowsNotSpecies = Data(Data(:,5)~=obj.species,:);
            
            %#fill_in: count the number of all samples
            NumOfAllSamples = length(Data);
            
            %#fill_in: count the number of samples that have a label = obj.species (number of raws in "RowsSpecies")
            NumSpecies = length(RowsSpecies);
            
            %#fill_in: count the number of samples that have a label other than obj.species (number of raws in "RowsNotSpecies")
            NumNotSpecies = length(RowsNotSpecies);
            %----------------------------------------------------------
            
            %----------------------------------------------------------
            %#fill_in: calculate the probability that a randomly
            %selected sample will have a label = to obj.species
            %(by using the values you got above)
            obj.Probability_species = NumSpecies / NumOfAllSamples;
            
            %#fill_in: calculate the probability that a randomly
            %selected sample will have any label other than a label =
            %obj.species
            %(by using the values you got above)
            obj.Probability_Not_species = NumNotSpecies / NumOfAllSamples;
            %----------------------------------------------------------
            
            
            %computing the conditional probabilities of the different
            %values for each attribute (feature)
            %(conditions are: 1> given the sample is from the selected species. 2> given the sample is not from the selected species)
            for i=1:length(obj.Attributes)
                for j=1:obj.Discretization_K
                    FreqOfAttValue_In_SpeciesRows = size(RowsSpecies(RowsSpecies(:,obj.Attributes(i))==j, :), 1);
                    FreqOfAttValue_In_NotSpeciesRows = size(RowsNotSpecies(RowsNotSpecies(:,obj.Attributes(i))==j, :), 1);
                    
                    obj.Probabilities_Given_S(obj.Attributes(i), j) = FreqOfAttValue_In_SpeciesRows/NumSpecies;
                    obj.Probabilities_Given_NS(obj.Attributes(i), j) = FreqOfAttValue_In_NotSpeciesRows/NumNotSpecies;
                end
            end
        end
        
        %Testing function
        function Results = Identify(obj, Data)
            TestResults = {};
            
            %a loop that goes through all samples that we wish to 
            %classify one by one
            for i=1:size(Data, 1)
                %----------------------------------------------------------
                %#fill_in: calculate the probability that the sample belongs
                %to the selected species given all the features values (posterior probability)
                %use obj.Probability_species value and obj.MultipliedLikelyHoods function
                %
                %to use the function pass the columns 1 to 4 as first
                %parameter and the value true as second parameter
                NB_Species_positive = obj.Probability_species*obj.MultipliedLikelyHoods(Data(i,1:4),true);
                %----------------------------------------------------------
                
                %----------------------------------------------------------
                %#fill_in: calculate the probability that the sample does not belong
                %to the selected species given all the features values (posterior probability)
                %use obj.Probability_Not_species value and obj.MultipliedLikelyHoods function
                %
                %to use the function pass the columns 1 to 4 as first
                %parameter and the value false as second parameter
                NB_Species_Negative = obj.Probability_Not_species*obj.MultipliedLikelyHoods(Data(i,1:4),false);
                %----------------------------------------------------------
                
                %classify based on which probability is higher
                if NB_Species_positive > NB_Species_Negative
                    TestResults(i, 1) = {obj.species};
                else
                    TestResults(i, 1) = {0};
                end
            end
            cellData = num2cell(Data);
            Results = horzcat(cellData, TestResults);
        end
        
        %this function calculate the product of P(ai|vi) for all the
        %attributes'values for the examples being tested
        %parameters are:
        %----------------
        %1) "AttributesValues" store the values for the attributes
        %2) "GivenSpecies" is a boolean variable, represent which probability we
        %want to calculate, is it P(ai|vi) or P(ai|not vi)
        function Product = MultipliedLikelyHoods(obj, AttributesValues, GivenSpecies)
            if GivenSpecies
                Product = obj.Probabilities_Given_S(1, AttributesValues(1, 1)) * ...
                            obj.Probabilities_Given_S(2, AttributesValues(1, 2)) * ...
                            obj.Probabilities_Given_S(3, AttributesValues(1, 3)) * ...
                            obj.Probabilities_Given_S(4, AttributesValues(1, 4));
            else
                Product = obj.Probabilities_Given_NS(1, AttributesValues(1, 1)) * ...
                            obj.Probabilities_Given_NS(2, AttributesValues(1, 2)) * ...
                            obj.Probabilities_Given_NS(3, AttributesValues(1, 3)) * ...
                            obj.Probabilities_Given_NS(4, AttributesValues(1, 4));
            end
        end
    end
end

