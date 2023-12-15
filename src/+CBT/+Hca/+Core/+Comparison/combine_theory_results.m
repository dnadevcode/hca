function [ rezMaxC ] = combine_theory_results(theoryStruct, rezMax,bestBarStretch,bestLength)
% combine_chromosome_results
%
% This function stores the top placement for each experiment
%
%     Args:
%         theoryStruct, comparisonStruct
% 
%     Returns:
%         combinedStruct: Return structure


    indx = zeros(1,length(rezMax{1}));
    rezMaxC = cell(1, length(rezMax{1}));

    for i=1:length(rezMax{1})
        try
            maxCoefs = cellfun(@(x) x{i}.maxcoef(1),rezMax);
            [~,indx(i)] = max(maxCoefs);
            rezMaxC{i} = rezMax{indx(i)}{i};
            rezMaxC{i}.idx = indx(i);
            if iscell(theoryStruct)
                rezMaxC{i}.name = theoryStruct{indx(i)}.name;
            else
                rezMaxC{i}.name = theoryStruct(indx(i)).name;
            end
            if nargin >2
                 % previously beststretch and length was not in rezMax struct
                rezMaxC{i}.bestBarStretch = bestBarStretch{indx(i)}(i);
                rezMaxC{i}.bestLength = bestLength{indx(i)}(i);
            end
        catch
            disp(strcat(['No placement found for barcode ' num2str(i)]));
        end
        
    end

end

