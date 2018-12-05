function [ consensus,sets] = select_consensus( consensusStructs, sets )
    % gen_consensus - generates consensus
    
    % input consensusStructs, sets
    
    % output consensusStructs
    
    
    if (sets.genConsensus==0) || isempty(consensusStructs)
        consensus = [];
        return;
    end
    consensus = struct();

    if sets.consensus.promptForBarcodeClusterLimit == 1
        figure,
        subplot(1,2,1)
        plot(consensusStructs.treeStruct.maxCorCoef)
        title('Consensus comparison score plot','Interpreter','latex');
        xlabel('Number of averaged barcodes ', 'Interpreter','latex')
        ylabel('Maximal experiment vs experiment score', 'Interpreter','latex')
        
        
      % here we add settings for this 
        prompt = {'Select consensus cluster threshold'};
        titlet = 'Consensus cluster settings';
        dims = [1 35];
        definput = {'0.75'};
        answer = inputdlg(prompt,titlet,dims,definput);

        sets.consensus.threshold  = str2double(answer{1});  
  
       
    end

    consensusIndex = find(consensusStructs.treeStruct.maxCorCoef>sets.consensus.threshold,1,'last');
    
    if isempty(consensusIndex)
        disp('All comparisons are below barcode cluster limit');
        return;
    end
    [~,row]=max(sum(consensusStructs.treeStruct.barMatrix{consensusIndex},2));
    
    % extract barcode
    consensus.rawBarcode = consensusStructs.treeStruct.treeBarcodes{consensusIndex}(row,:);
	% barcode indices
    consensus.indices = find(consensusStructs.treeStruct.barMatrix{consensusIndex}(row,:));
    % bitmasks
    bitm = consensusStructs.treeStruct.bitMat{consensusIndex}(consensus.indices,:);
    % nonzero are only those indices that have been included significant
    % amount of times
    consensus.rawBitmask = sum(bitm)> 3*std(sum(bitm));
    %consensus.rawBitmask = consensusStructs.treeStruct.treeBitmasks{consensusIndex}(row,:);
    consensus.time = consensusStructs.time;
    % we have to retrace the name of this barcode
    %
    %consensus.name =  consensusStructs.treeStruct.clusteredBar{row};
    disp('Barcodes that are included in the consensus are')
    disp(num2str(consensus.indices))
    sets.consensus.barcodesInConsensus = consensus.indices;

    timePassed = toc;
    display(strcat(['All consensuses generated in ' num2str(timePassed) ' seconds']));

end

