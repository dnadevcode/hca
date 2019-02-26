function [  ] = plot_consensus_concentrically(ts, consensusStructs,consensusStruct,barcodeGen )
    % plot_consensus_concentrically
    
  
    num2str(cell2mat(consensusStructs.treeStruct.clusteredBar{end}))
    
    vec = cell2mat(consensusStructs.treeStruct.clusteredBar{end});
    clK{1} = strjoin(arrayfun(@(x) num2str(x),vec,'UniformOutput',false),',');
    
  
    
    import Fancy.UI.FancyTabs.TabbedScreen;

    hTabConcentric = ts.create_tab('Concentric Plots');
    hPanelConcentric = uipanel('Parent', hTabConcentric);
    tsConcentric = TabbedScreen(hPanelConcentric);

    
    numBarcodesInClusters = cellfun(@(clK) sum(clK == ','), clK) + 1;
    [~, sortOrder] = sort(numBarcodesInClusters, 'descend');
    numClusters = length(clK);
    
    %import CBT.Consensus.UI.plot_cluster_concentrically;
    %for clusterNum = 1:numClusters
    clusterNum = 1;
        clusterIdx = sortOrder(clusterNum);
        ck = clK{clusterIdx};
      %  clusterConsensusData = clusterConsensusDataStructs{clusterIdx};
        hTabCluster = tsConcentric.create_tab(sprintf('%s', ck));
        hPanelCluster = uipanel('Parent', hTabCluster);
        tsCluster = TabbedScreen(hPanelCluster);
  
        alignedBarcodes = consensusStructs.treeStruct.barcodes{end};
        %alignedBitmasks = isnan(consensusStructs.treeStruct.barcodes{end});
        clusterBarcodeKeys = find(consensusStructs.treeStruct.barMatrix{end});
        clusterBarcodeNames = cellfun(@(x) x.name, barcodeGen,'UniformOutput',false);
        clusterBarcodeAliases = clusterBarcodeNames(clusterBarcodeKeys);
        
        sanitizedBarcodesAligned = num2cell(alignedBarcodes,2);
        
        clusterBarcodeNamesAligned = strcat({'Aligned Barcode '}, cellfun(@(x) num2str(x),num2cell(clusterBarcodeKeys),'UniformOutput',false), {' ('}, clusterBarcodeAliases, {')'});

        tabTitleAligned = 'Aligned';
        titleAligned = {'Aligned Barcodes in Consensus Cluster (Concentric Plot)','1'};



        hTabAligned = ts.create_tab(tabTitleAligned);
        ts.select_tab(hTabAligned);
        hPanelAligned = uipanel('Parent', hTabAligned);
        hAxisAligned = axes(...
            'Units', 'normal', ...
            'Position', [0, 0.1, 0.6, 0.8], ...
            'Parent', hPanelAligned ...
            );

        uitable(hPanelAligned,...
            'Data', clusterBarcodeNamesAligned',...
            'ColumnName', {'Barcode Names (Numbered from center outwards)'},...
            'ColumnWidth', {400},...
            'Units', 'normal', 'Position', [0.6, 0, 0.4, 1]);
        

        sanitizedBarcodes = [sanitizedBarcodesAligned; {consensusStruct.rawBarcode}];
        sanitizedBarcodes = cellfun(@(v) (v - nanmean(v(:)))./nanstd(v(:)), sanitizedBarcodes, 'UniformOutput', false);
        import Barcoding.Visualizing.plot_circular_barcodes_concentrically;
        plot_circular_barcodes_concentrically(hAxisAligned,sanitizedBarcodes);
        title(hAxisAligned, titleAligned);

end

