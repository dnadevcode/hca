function [rezMax] = hca_compare_distance(barcodeGen,theoryStruct, sets )
    % hca_compare_distance
    % Compares experiments to theory. Helping function with the parfor
    %     Args:
    %         sets: settings structure
    %         barcodeGen: barcode structure
    %         theoryStruct: theory structure
    % 
    %     Returns:
    %         comparisonStruct: comparison structure
        
    disp('Starting comparing exp to theory...')
    tic
    
    comparisonMethod = sets.comparisonMethod;
    w = sets.w;
    numPixelsAroundBestTheoryMask = 20;% hardcoded
            
    rezMax = cell(1,length(theoryStruct));

    import CBT.Hca.Core.Comparison.on_compare_sf;

    % Computing distances for each theory against all experiments. This
    % loop can be parallelized (parfor)
   	parfor barNr = 1:length(theoryStruct)
%         barNr
        try
            [rezMax{barNr}] = ...
                on_compare_sf(barcodeGen,theoryStruct(barNr),comparisonMethod,w,numPixelsAroundBestTheoryMask);
        catch
            disp(['error with ',num2str(barNr)]);
        end
    end

    timePassed = toc;
    disp(strcat(['Experiments were compared to theory in ' num2str(timePassed) ' seconds']));
end

