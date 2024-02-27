function [ rezMaxM ] = on_compare_sf(barGen,theoryStruct,comparisonMethod,w,numPixelsAroundBestTheoryMask)
    % on_compare_theory_to_exp
    % Compares experiments to single theory
    %     Args:
    %         sets: settings structure
    %         barcodeGen: barcode structure
    %         theoryStruct: theory structure
    % 
    %     Returns:
    %         comparisonStructure: comparison structure

    import mp.mp_profile_stomp_nan_dna;
    switch comparisonMethod
        case 'mass_pcc'
            % choose k just higher than the length of small sequence for
            % best precision. (larger k though could increase speed)
            comparisonFun = @(x,y,z,w,u) unmasked_MASS_PCC(y,x,z,w,2^(4+nextpow2(length(x))),theoryStruct.isLinearTF,numPixelsAroundBestTheoryMask);
        case 'mpnan'
            % todo: this function itself does not include possibility of
            % being circular, so inputed X1, X2 should include extra
            % values..
            comparisonFun = @(X1,X2, bitX1, bitX2, w, kk) mp_profile_stomp_nan_dna(X1',X2', bitX1', bitX2', w,2^(4+nextpow2(length(X1))),numPixelsAroundBestTheoryMask);
        otherwise
            error('undefined method');
    end
            
    theorBar = theoryStruct.rawBarcode;
    if ~isempty(theoryStruct.rawBitmask)
        theorBit = theoryStruct.rawBitmask;
    else
        theorBit = ones(1,length(theorBar));
    end
        
%     theorBar = filter_barcode(theorBar,sets);
    
    rezMaxM = cell(1,length(barGen));
    % for all the barcodes run
    % parfor
    for idx=1:length(barGen)
        for idy=1:length(barGen{idx}.rescaled) % loop over stretch factors
            [rezMaxM{idx}{idy}.maxcoef,rezMaxM{idx}{idy}.pos,rezMaxM{idx}{idy}.or,rezMaxM{idx}{idy}.secondPos,rezMaxM{idx}{idy}.lengthMatch,~] =...
                comparisonFun(barGen{idx}.rescaled{idy}.rawBarcode, theorBar, barGen{idx}.rescaled{idy}.rawBitmask,theorBit,w);
        end
    end

end