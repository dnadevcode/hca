function [cellStruct] = read_default_sets(setstxt)
    % Puts data from setstxt directly to structure

    cellStruct = struct();

    mFilePath = mfilename('fullpath');
    [threeLevelsUpDir, ~] = fileparts(fileparts(fileparts(fileparts(mFilePath))));

    setsTable  = readtable(fullfile(threeLevelsUpDir,'files',setstxt),'Format','%s%s%s');
    
    % Assigning values to the fields
    for i = 1:size(setsTable,1)
        fieldName = genvarname(setsTable.Var3{i});
        cellStruct.(fieldName) = str2double(setsTable.Var1{i}); % Example value assignment
    end
end

