classdef Constants
    %a class that holds all constants values

    properties(Constant = true)
        %constants for the species names
        SETOSA = 1;
        VERSICOLOR = 2;
        VIRGINICA = 3;
        
        %constants for the attributes
        SHORT = 1;
        MEDIUM = 2;
        LONG = 3;
        
        %constants for attributes names
        SEPAL_LENGTH = 1;       %first column is for sepals length
        SEPAL_WIDTH = 2;        %second column is for sepals width
        PETAL_LENGTH = 3;       %third column is for petals lenght
        PETAL_WIDTH = 4;        %fourth column is for petals width
    end
end

