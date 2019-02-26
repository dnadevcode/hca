function [ combinedStruct ] = combine_chromosome_results(theoryStruct, comparisonStruct )
% combine_chromosome_results
    indx = zeros(1,length(comparisonStruct{1}));
    combinedStruct = cell(1, length(comparisonStruct{1}));

    for i=1:length(comparisonStruct{1})
        maxCoefs = cellfun(@(x) x{i}.maxcoef(1),comparisonStruct);
        [~,indx(i)] = max(maxCoefs);
        combinedStruct{i} = comparisonStruct{indx(i)}{i};
        combinedStruct{i}.idx = indx(i);
        combinedStruct{i}.pos =  comparisonStruct{indx(i)}{i}.pos; %+sum(accuLengths(1:indx(i)-1));
        combinedStruct{i}.name = theoryStruct{indx(i)}.name;
    end

end

