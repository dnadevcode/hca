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


    timePassed = toc;
    display(strcat(['All consensuses generated in ' num2str(timePassed) ' seconds']));

end

