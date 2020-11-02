function [ consensusStr,sets] = select_same_cut_consensus( consensusStructs, sets )
    % Tries to select consensus from a subset of kymographs that are cut at
    % the same place. Stores resulting plots in an output folder
    
    if (sets.genConsensus==0) || isempty(consensusStructs)
        consensusStr = [];
        return;
    end
%     consensus = struct();
       
    try
        mkdir(sets.output.matDirpath,sets.timestamp);
    end
%     out =

    

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
        sets.genConsensus = 0;
        consensus = [];
        disp('All comparisons are below barcode cluster limit, no consensus is being selected');
        return;
    end
    
    % alternative to this: allow only linear matches..
    
    % here can be a few clusters... We find all independent cluster for 
    % index less or equal to consensusIndex
    % cdix stores the indexes of these different clusters. All these
    % clusters should be outputed in the end
    cdix = consensusIndex;
    barsInCons = consensusStructs.treeStruct.barMatrix{consensusIndex};
    for j=consensusIndex-1:-1:1
        barsInConsTemp = consensusStructs.treeStruct.barMatrix{j};
        if sum(barsInConsTemp.*barsInCons) == 0
            cdix = [cdix j];
            barsInCons = barsInCons+barsInConsTemp;
        end
    end
    
    for i=1:length(cdix)
%     cons1 = consensusStructs.treeStruct.barMatrix(consensusIndex)
        idx = cdix(i);
        maxcoef = consensusStructs.treeStruct.maxCorCoef(idx);

        f = figure('Visible','off');imagesc(consensusStructs.treeStruct.barcodes{idx});colorbar;
        saveas(f, fullfile(sets.output.matDirpath, sets.timestamp,strcat(['consensus_cluster' num2str(i) '_pcc=' num2str(maxcoef) '.jpg'])))


        consB = consensusStructs.treeStruct.barcodes{idx};
        nanvals = isnan(consB);
        f = figure('Visible','off');imagesc(nanvals)
        saveas(f,fullfile(sets.output.matDirpath, sets.timestamp,strcat(['masks_cluster_' num2str(i) '.jpg'])))

        pos = arrayfun(@(x) find(~isnan(consensusStructs.treeStruct.barcodes{idx}(x,:)),1,'last'),1:size(consensusStructs.treeStruct.barcodes{idx},1))
     
%      
%      find(~isnan(consensusStructs.treeStruct.barcodes{idx}),1,'last')
%      [~, pos] = max(isnan(consensusStructs.treeStruct.barcodes{idx}),[],2); 
     
     lenb =size(consensusStructs.treeStruct.barcodes{idx},2);
    
     % make sure we don't have values that skew this..
%      pos(pos >lenb-20) =  pos(pos >lenb-20)-lenb;
     
      f = figure('Visible','off');histogram(pos)
     saveas(f,fullfile(sets.output.matDirpath, sets.timestamp,strcat(['position_histogram_' num2str(i) '.jpg'])))


    % maybe check that those close to the end and beginning give same
    % contribution! sometimes this would give error otherwise
    medianV = mode(pos);
    barswithcloseStarts = find(abs(pos -medianV) <=5);

    % std(pos(:,1))
    % barswithcloseStarts = indexing(barswithcloseStarts);
    f = figure('Visible','off'); imagesc(consensusStructs.treeStruct.barcodes{idx}(barswithcloseStarts,:));
    saveas(f,fullfile(sets.output.matDirpath, sets.timestamp,strcat(['filtered_cluster_' num2str(i) '.jpg'])))

    shifted = circshift(consensusStructs.treeStruct.barcodes{idx}(barswithcloseStarts,:),[0,-medianV-6]);
    f = figure('Visible','off'); imagesc(shifted);
    saveas(f,fullfile(sets.output.matDirpath, sets.timestamp,strcat(['shifted_filtered_cluster_' num2str(i) '.jpg'])))


        consensus = nanmean(shifted);
        % numExL = 15;
        % numExR = 10;
        % 
        bars = find(consensusStructs.treeStruct.barMatrix{idx});
        % consensus(1:numExL) = nan;
        % consensus(end-numExR+1:end) = nan;
        clust{i}.clusterConsensusData.maxcoef = maxcoef;
        clust{i}.clusterConsensusData.timestamp = sets.timestamp;
        clust{i}.clusterConsensusData.barcodesInConsensus = bars(barswithcloseStarts);
        clust{i}.clusterConsensusData.barcode = consensus;
        clust{i}.clusterConsensusData.bitmask = ~isnan(consensus);
        clust{i}.clusterConsensusData.indexWeights = sum(~isnan(shifted));
        clust{i}.clusterConsensusData.stdErrOfTheMean = nanstd(shifted)./sqrt(clust{i}.clusterConsensusData.indexWeights);

        clusterConsensusData = clust{i}.clusterConsensusData;
        save(fullfile(sets.output.matDirpath, sets.timestamp,strcat(['filtered_clusterdata_' num2str(i) '.mat'])), 'clusterConsensusData','-v7.3') ;

    % amount of times
%     consensus.indexWeights = sum(~bitm);
%     consensus.rawBitmask = sum(~bitm)> 3*std(sum(bitm));
%     consensus.rawBarcode(~consensus.rawBitmask) = nan;
    

    %consensus.rawBitmask = consensusStructs.treeStruct.treeBitmasks{consensusIndex}(row,:);
%     consensus.time = consensusStructs.time;
    % we have to retrace the name of this barcode
    %
    %consensus.name =  consensusStructs.treeStruct.clusteredBar{row};
        disp('Barcodes that are included in the consensus are')
        disp(num2str(clust{i}.clusterConsensusData.barcodesInConsensus))
%     sets.consensus.barcodesInConsensus = consensus.indices;
    end
    
    for i=1:length(clust)
        consensusStr{i} = clust{i}.clusterConsensusData;
    end
    timePassed = toc;
    display(strcat(['All consensuses generated in ' num2str(timePassed) ' seconds']));

end

