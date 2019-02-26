function [ comparisonStructure ] = on_compare_theory_to_exp( barcodeGen,theoryStruct, sets)
    % on_compare_theory_to_exp
    % Compares experiments to single theory
    %     Args:
    %         sets: settings structure
    %         barcodeGen: barcode structure
    %         theoryStruct: theory structure
    % 
    %     Returns:
    %         comparisonStructure: comparison structure

    % create the rezult structure
    comparisonStructure = cell(1, length(barcodeGen));
    %ccM = cell(length(rawBarcodes),1);

    % stretch factors
    stretchFactors = sets.theory.stretchFactors;

    fileID = fopen(theoryStruct.filename,'r');
    formatSpec = '%f';
    theorBar = transpose(fscanf(fileID,formatSpec));
    fclose(fileID);
    theorBit = ones(1,length(theorBar));

   	import CBT.Hca.Core.filter_barcode; % in case we need to filter barcode
	import SignalRegistration.unmasked_pcc_corr;
	import SignalRegistration.masked_pcc_corr;
    import CBT.Hca.UI.Helper.get_best_parameters;
    
    % for all the barcodes run
    for idx=1:length(barcodeGen)

        % xcorrMax stores the  maximum coefficients
        xcorrMax = zeros(1,length(stretchFactors));
        
        % rezMaz stores the results for one barcode
        rezMax = cell(1,length(stretchFactors));
       
        % barTested barcode to be tested
        barTested = barcodeGen{idx}.rawBarcode;
        
        % in case barcode should be filtered
        barTested = filter_barcode(barTested, sets.filterSettings);

        % length of this barcode
        lenBarTested = length(barTested);
        
        % barBitmask - bitmask of this barcode
        barBitmask = barcodeGen{idx}.rawBitmask;

        % run the loop for the stretch factors
        for j=1:length(stretchFactors)
            % here interpolate both barcode and bitmask 
            barC = interp1(barTested, linspace(1,lenBarTested,lenBarTested*stretchFactors(j)));
            barB = barBitmask(round(linspace(1,lenBarTested,lenBarTested*stretchFactors(j))));

            % compute the scores.
            % here separate which barcode is the longer and which is the
            % shorter (todo: check how this works when we compare fragment
            % to fragment theory)
            if length(barC) > length(theorBar) % in case exp larger than theory
                xcorrs = masked_pcc_corr(theorBar, barC, theorBit,barB);
            else % faster function, only when barC has bitmask only on left and right
                xcorrs = unmasked_pcc_corr(barC, theorBar, barB);
            end 
            
            % now find the maximum score for this stretching parameter
            xcorrMax(j) = max(xcorrs(:));
            [rezMax{j}.maxcoef,rezMax{j}.pos,rezMax{j}.or] = get_best_parameters(xcorrs,length(barC) );
        end       
        
        % find which stretching parameter had the best score
        [~,b] = max(xcorrMax);
        
        % select the results for this best stretching parameter and output
        % them.
        comparisonStructure{idx} = rezMax{b};
        comparisonStructure{idx}.bestBarStretch = stretchFactors(b);
        comparisonStructure{idx}.length = round(lenBarTested*stretchFactors(b));

    end 

end

