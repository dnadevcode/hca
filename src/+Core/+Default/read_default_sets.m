function [myStruct] = read_default_sets(setstxt)
    % Puts data from setstxt directly to structure

    if nargin < 2
        default = 1;
    end

    if nargin < 3
        depth = 4;
    end

    myStruct = struct();

    if default
        mFilePath = mfilename('fullpath');

        for i=1:depth
            [mFilePath, ~] = fileparts(mFilePath);
        end
        setstxt  = fullfile(mFilePath,'files',setstxt);
    end

    setsTable  = readtable(setstxt,'Format','%s%s%s','VariableNamingRule','preserve');
    
    cellNames = {};
    for i = 1:size(setsTable,1)
        validFieldName = split(matlab.lang.makeValidName(setsTable.Var3{i}),'.');
        number = str2num(setsTable.Var1{i});
        if ~isnan(number)
            val = number;
        else
            val = strtrim(setsTable.Var1{i});
        end
        if length(validFieldName)>=3
            cellNames = [cellNames, validFieldName{1}];
            myStruct.(validFieldName{1}){str2num(validFieldName{2})} = val; % Example value assignment
        else
            if length(validFieldName)==2
                myStruct.(validFieldName{1}).(validFieldName{2}) = val; % Example value assignment
            else
                myStruct.(validFieldName{1}) = val; % Example value assignment
            end
        end
    end
    uniqueNames = unique(cellNames);
    for i=1:length(uniqueNames)
        myStruct.(uniqueNames{i}) = cell2mat(myStruct.(uniqueNames{i}));
    end

    
end