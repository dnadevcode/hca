function [ consensusStructs] = gen_consensus(barcodeGen, sets )
    % gen_consensus
    % Generates consensus for barcodes of the same length 
    %     Args:
    %         barcodeGen: barcode structure
    %         sets: Input settings to the method
    % 
    %     Returns:
    %         consensusStructs: Consensus tree structure
    % 
    %     Example:
    %          
    tic
    if sets.genConsensus == 0 || length(barcodeGen)<=1
        consensusStructs = [];
        disp('Skipping consensus generation');
        return;
    end
    
    % generate consensus in case it is not aborted
	import CBT.Hca.Core.generate_consensus;
    consensusStructs  = generate_consensus( cellfun(@(x) x.stretchedBarcode,barcodeGen,'UniformOutput',false),...
         cellfun(@(x) x.stretchedrawBitmask,barcodeGen,'UniformOutput',false),...
         cellfun(@(x) x.bgMeanApprox,barcodeGen,'UniformOutput',false), sets );

	%consensusStructs  = generate_consensus(barcodeGen, sets );

    % FAKE set to test consensus?
%     
%     disp('Starting generating consensus...')
%     tic    
% 	sets.barcodeConsensusSettings.commonLength = ceil(mean(hcaSessionStruct.lengths));
%     
%     if sets.prestretchMethod == 0
%         import CBT.Consensus.Core.convert_barcodes_to_common_length;
%         [rawBarcodes] = convert_barcodes_to_common_length(hcaSessionStruct.rawBarcodes, sets.barcodeConsensusSettings.commonLength);
%         import CBT.Consensus.Core.convert_bitmasks_to_common_length;
%         [rawBitmasks] = convert_bitmasks_to_common_length(hcaSessionStruct.rawBitmasks, sets.barcodeConsensusSettings.commonLength);
%     else
%         rawBarcodes = hcaSessionStruct.rawBarcodes;
%         rawBitmasks = hcaSessionStruct.rawBitmasks; 
%     end
    
%     molStruct.rawBarcodes = rawBarcodes;
%     molStruct.rawBitmasks = rawBitmasks;
%     molStruct.barcodeGen = hcaSessionStruct.barcodeGen;

%     if  sets.filterSettings.filter == 1
%         sets.barcodeConsensusSettings.commonLength2 = ceil(mean(hcaSessionStruct.lengthsFiltered));
%          
%         if sets.prestretchMethod == 0   %to do: put this in a wrapper function
%             import CBT.Consensus.Core.convert_barcodes_to_common_length;
%             [rawBarcodes] = convert_barcodes_to_common_length(hcaSessionStruct.rawBarcodesFiltered, sets.barcodeConsensusSettings.commonLength2);
%             import CBT.Consensus.Core.convert_bitmasks_to_common_length;
%             [rawBitmasks] = convert_bitmasks_to_common_length(hcaSessionStruct.rawBitmasksFiltered, sets.barcodeConsensusSettings.commonLength2);
%         else
%             rawBarcodes = hcaSessionStruct.rawBarcodesFiltered;
%             rawBitmasks = hcaSessionStruct.rawBitmasksFiltered; 
%         end
% 
%         molStruct.rawBarcodes = rawBarcodes;
%         molStruct.rawBitmasks = rawBitmasks;
%         molStruct.barcodeGen = hcaSessionStruct.barcodeGenFiltered;
%         import CBT.Hca.Import.generate_consensus;
%         hcaSessionStruct.consensusStructFiltered = generate_consensus( molStruct, sets );
%     end

    timePassed = toc;
    display(strcat(['All consensuses generated in ' num2str(timePassed) ' seconds']));

end

