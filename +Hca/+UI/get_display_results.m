function [] = get_display_results(barcodeGen, consensusStruct,comparisonStruct,theoryStruct, sets)
    % get_display_results 
    % Display results from the comparison of experiments vs theory
    %     Args:
    %         barcodeGen: Input 
    %         consensusStruct: 
    %         comparisonStruct: 
    %         theoryStruct:
    %         sets:

    % if it was chosen to display results
    if sets.displayResults ==1

        % choose markers for everything
        markers = ['o';'s';'x';'+';'d';'v'];

        % compute cummulative sum of lengths of barcodes
        lengthBorders = cumsum(cellfun(@(x) x.length,theoryStruct));

        % how many barcodes were compared to
        numBar = length(comparisonStruct);

        % If consensus was generate, then actual number of barcodes is one less
        if sets.genConsensus == 1
            numBar = numBar-1;
        end

        % plot max corr coefs
        fig1 = figure;
        subplot(2,2,1);hold on;
        import CBT.Hca.UI.Helper.plot_max_coef;
        [fig1,maxcoef] = plot_max_coef(fig1,comparisonStruct, numBar, sets, markers);

        % plot best positions
        subplot(2,2,2);hold on;
        import CBT.Hca.UI.Helper.plot_best_pos;
        plot_best_pos(fig1,comparisonStruct, numBar, sets, markers,lengthBorders);
    
        subplot(2,2,3), hold on
        import CBT.Hca.UI.Helper.plot_best_bar;
        plot_best_bar(fig1,barcodeGen,consensusStruct,comparisonStruct, theoryStruct, maxcoef);
    
        disp( strcat(['Number of timeframes for the unfiltered barcodes were = ' num2str(sets.timeFramesNr)]));
%    assignin('base','hcaSessionStruct',hcaSessionStruct)
    
  %  cache('hcaSessionStruct') = hcaSessionStruct ;
    end
end