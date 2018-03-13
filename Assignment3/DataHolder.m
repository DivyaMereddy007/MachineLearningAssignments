classdef DataHolder<handle
    %class to store the data
    
    properties (Access = public)
        Data_Testing;
        Data_Training;
    end
    
    methods
        function obj = DataHolder()
            obj.Data_Training = [];
            obj.Data_Testing = [];
        end
    end
end

