classdef DataManager<handle
    %manage data loading/mapping/partitioning
    
    properties (Access = private)
        SLrange;
        SLmin;
        SWrange;
        SWmin;
        PLrange;
        PLmin;
        PWrange;
        PWmin;
        
        setosa_data;
        versicolor_data;
        virginica_data;
        
        setosa_discrete;
        versicolor_discrete;
        virginica_discrete;
    end
    
    methods
        %constructor
        function obj = DataManager()
            SLrange = 0;
            SLmin = 0;
            SWrange = 0;
            SWmin = 0;
            PLrange = 0;
            PLmin = 0;
            PWrange = 0;
            PWmin = 0;
        end
       
        %function to load the data
        function LoadData(obj)
            
            load fisheriris;
            
            %replace species names with numerical values
            for i = 1:length(species)
                if strcmp(species(i,1),'setosa')
                    species(i,1) = num2cell(Constants.SETOSA);
                elseif strcmp(species(i,1),'versicolor')
                    species(i,1) = num2cell(Constants.VERSICOLOR);
                elseif strcmp(species(i,1),'virginica')
                    species(i,1) = num2cell(Constants.VIRGINICA);
                end
            end
                        
            %convert species values from cells to numerical data
            numerical_species = cell2mat(species);

            %combine into one matrix
            merged_data = horzcat(meas, numerical_species);   
            clear meas;                 %delete meas
            clear species;              %delete species
            clear numerical_species;    %delete numerical_species

            %Split data into seperate sets according to species type to select training
            %data later from each species seperately
            obj.setosa_data = merged_data(1:50,:);
            obj.versicolor_data = merged_data(51:100,:);
            obj.virginica_data = merged_data(101:150,:);
            
            
            %get range/min/max for the attributes to map them into discrete values
            obj.SLrange = range(merged_data(:,Constants.SEPAL_LENGTH));
            obj.SLmin = min(merged_data(:,Constants.SEPAL_LENGTH));

            obj.SWrange = range(merged_data(:,Constants.SEPAL_WIDTH));
            obj.SWmin = min(merged_data(:,Constants.SEPAL_WIDTH));

            obj.PLrange = range(merged_data(:,Constants.PETAL_LENGTH));
            obj.PLmin = min(merged_data(:,Constants.PETAL_LENGTH));

            obj.PWrange = range(merged_data(:,Constants.PETAL_WIDTH));
            obj.PWmin = min(merged_data(:,Constants.PETAL_WIDTH));
        end     %end of LoadData function
     
        %this function uses less loops
        function Data = readyDataEnhanced(obj, k_value)
            
            if nargin < 2
                k_value = 3;
            end
            
            %split the data into training and testing sets
            setosa_r = randperm(50);
            versicolor_r = randperm(50);
            virginica_r = randperm(50);
            
            training_data = vertcat(obj.setosa_data(setosa_r(1:25),:), ...
                obj.versicolor_data(versicolor_r(1:25),:), ...
                obj.virginica_data(virginica_r(1:25),:));
            
            testing_data = vertcat(obj.setosa_data(setosa_r(26:50),:), ...
                obj.versicolor_data(versicolor_r(26:50),:), ...
                obj.virginica_data(virginica_r(26:50),:));

            %shuffle the testing data
            shuffled_testing_data = testing_data(randperm(75), :);
            testing_data = shuffled_testing_data;
            shuffled_training_data = training_data(randperm(75), :);
            training_data = shuffled_training_data;
            
            %calculate increment to define edges of categories
            SLincrement = obj.SLrange/k_value;
            SWincrement = obj.SWrange/k_value;
            PLincrement = obj.PLrange/k_value;
            PWincrement = obj.PWrange/k_value;
            
            %convert the continous data to discrete values
            for i=1:k_value
                SLI = shuffled_training_data(:,Constants.SEPAL_LENGTH)>=(obj.SLmin+(i-1)*SLincrement) & ...
                    shuffled_training_data(:,Constants.SEPAL_LENGTH)<=(obj.SLmin+i*SLincrement);
                training_data(SLI, Constants.SEPAL_LENGTH) = i;
                SWI = shuffled_training_data(:,Constants.SEPAL_WIDTH)>=(obj.SWmin+(i-1)*SWincrement) & ...
                    shuffled_training_data(:,Constants.SEPAL_WIDTH)<=(obj.SWmin+i*SWincrement);
                training_data(SWI, Constants.SEPAL_WIDTH) = i;
                PLI = shuffled_training_data(:,Constants.PETAL_LENGTH)>=(obj.PLmin+(i-1)*PLincrement) & ...
                    shuffled_training_data(:,Constants.PETAL_LENGTH)<=(obj.PLmin+i*PLincrement);
                training_data(PLI, Constants.PETAL_LENGTH) = i;
                PWI = shuffled_training_data(:,Constants.PETAL_WIDTH)>=(obj.PWmin+(i-1)*PWincrement) & ...
                    shuffled_training_data(:,Constants.PETAL_WIDTH)<=(obj.PWmin+i*PWincrement);
                training_data(PWI, Constants.PETAL_WIDTH) = i;
                
                SLI = shuffled_testing_data(:,Constants.SEPAL_LENGTH)>=(obj.SLmin+(i-1)*SLincrement) & ...
                    shuffled_testing_data(:,Constants.SEPAL_LENGTH)<=(obj.SLmin+i*SLincrement);
                testing_data(SLI, Constants.SEPAL_LENGTH) = i;
                SWI = shuffled_testing_data(:,Constants.SEPAL_WIDTH)>=(obj.SWmin+(i-1)*SWincrement) & ...
                    shuffled_testing_data(:,Constants.SEPAL_WIDTH)<=(obj.SWmin+i*SWincrement);
                testing_data(SWI, Constants.SEPAL_WIDTH) = i;
                PLI = shuffled_testing_data(:,Constants.PETAL_LENGTH)>=(obj.PLmin+(i-1)*PLincrement) & ...
                    shuffled_testing_data(:,Constants.PETAL_LENGTH)<=(obj.PLmin+i*PLincrement);
                testing_data(PLI, Constants.PETAL_LENGTH) = i;
                PWI = shuffled_testing_data(:,Constants.PETAL_WIDTH)>=(obj.PWmin+(i-1)*PWincrement) & ...
                    shuffled_testing_data(:,Constants.PETAL_WIDTH)<=(obj.PWmin+i*PWincrement);
                testing_data(PWI, Constants.PETAL_WIDTH) = i;
            end
            
            Data = DataHolder();
            Data.Data_Training = training_data;
            Data.Data_Testing = testing_data;
        end
        
    end     %end of methods
end     %end of class

