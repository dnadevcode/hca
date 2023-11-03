function [barcodeGenC,consensusStruct, comparisonStruct, theoryStruct, hcaSets] = run_hca_alignment(hcaSets)
    %   run_hca_theory - calculates HCA theory

    %   Args: hcaSets

    %   Returns:
    %
    %
    %
%     [,hcaSets.kymosets.filenames,hcaSets.kymosets.fileext] = cellfun(@(x) fileparts(x),hcaSets.kymofolder,'un',false);
    hcaSets.kymosets.filenames = hcaSets.kymofolder;
    hcaSets.kymosets.kymofilefold = cell(1,length(   hcaSets.kymosets.filenames));
    hcaSets.output.matDirpath = hcaSets.kymofolder{1};
    % timestamp for the results
    hcaSets.timestamp = datestr(clock(), 'yyyy-mm-dd_HH_MM_SS');

    % add kymographs
    import CBT.Hca.Import.add_kymographs_fun;
    [kymoStructs] = add_kymographs_fun(hcaSets);

    %  put the kymographs into the structure
    import CBT.Hca.Core.edit_kymographs_fun;
    kymoStructs = edit_kymographs_fun(kymoStructs,hcaSets.timeFramesNr);

    % align kymos
    import CBT.Hca.Core.align_kymos;
    [kymoStructs] = align_kymos(hcaSets,kymoStructs);
    
    % generate barcodes
    import CBT.Hca.Core.gen_barcodes;
    barcodeGen =  CBT.Hca.Core.gen_barcodes(kymoStructs, hcaSets);

    % shrink find
%     import Core.shrink_finder_fun;
%     shrink_finder_fun(kymoStructs, hcaSets)


    
    % generate consensus
    import CBT.Hca.Core.gen_consensus;
    consensusStructs = CBT.Hca.Core.gen_consensus(barcodeGen,hcaSets);
    %
    % Alternative:
    %         import CBT.Hca.UI.Helper.select_all_consensus;
    %         [consensusStruct,sets] = select_all_consensus(consensusStructs,sets);
    
    % select consensus
    import CBT.Hca.UI.Helper.select_consensus
    [consensusStruct,hcaSets] = select_consensus(consensusStructs,hcaSets);


  % generate random cut-outs
    if hcaSets.random.generate
        % % Here generate cutouts using M_files_HCA_exp_cutouts:
        import CBT.Hca.Core.Random.cutout_barcodes;
        barcodeGenRandom = cutout_barcodes(barcodeGen,hcaSets);
        barcodeGenC = barcodeGenRandom;
    else
        barcodeGenC = barcodeGen;
    end

    if  hcaSets.subfragment.generate
        import CBT.Hca.Core.Subfragment.gen_subfragments;
        barcodeGenC = gen_subfragments(barcodeGen,hcaSets.subfragment.numberFragments); 
    else
        barcodeGenC = barcodeGen;
    end


    
    % load(thryFile);
    [hcaSets.theoryFile{1},hcaSets.theoryFileFold{1}] = uigetfile(pwd,strcat(['Select theory .mat file to process']));
    % hcaSets.theoryFileFold{1} = '';
    hcaSets.theory.precision = 5;
    hcaSets.theory.theoryDontSaveTxts = 1;
    import CBT.Hca.UI.Helper.load_theory;
    theoryStruct = load_theory(hcaSets);

    
    % extract from name
    hcaSets.theory.nmbp = hcaSets.nmbp;
    
    import CBT.Hca.Core.Analysis.convert_nm_ratio;
    theoryStruct = convert_nm_ratio(hcaSets.theory.nmbp, theoryStruct,hcaSets );
    
    
    hcaSets.theoryFile=[];
    hcaSets.theoryFileFold = [];
    
    % compare theory to experiment
    import CBT.Hca.Core.Comparison.compare_distance;
    [rezMax,bestBarStretch,bestLength] = compare_distance(barcodeGenC,theoryStruct, hcaSets, consensusStruct );

    comparisonStructAll = rezMax;
    for i=1:length(comparisonStructAll)
        for j=1:length(bestBarStretch{i})
            comparisonStructAll{i}{j}.bestBarStretch = bestBarStretch{i}(j);
            comparisonStructAll{i}{j}.length = bestLength{i}(j);
        end
    end
    import CBT.Hca.Core.Comparison.combine_theory_results;
    [comparisonStruct] = combine_theory_results(theoryStruct, rezMax,bestBarStretch,bestLength);
    % 
    % 
    % 
    %    % assign all to base
    if hcaSets.saveOutput
            assignin('base','barcodeGenC', barcodeGenC)
            assignin('base','theoryStruct', theoryStruct)
            assignin('base','hcaSets', hcaSets)
            assignin('base','rezMax', rezMax)
    end
        
%             import CBT.Hca.UI.Helper.plot_any_bar;
%             plot_any_bar(1,barcodeGenC,rezMax,theoryStruct,1);

        import CBT.Hca.Core.additional_computations
        additional_computations(barcodeGenC,consensusStruct, comparisonStruct, theoryStruct,comparisonStructAll,hcaSets );

        if hcaSets.identifyDisc
            import Core.identify_discriminative;
            identify_discriminative(hcaSets,barcodeGenC,rezMax, {theoryStruct.name});

        end

%               import CBT.Hca.UI.get_display_results;
%         get_display_results(barcodeGenC,consensusStruct, comparisonStruct, theoryStruct, sets);

end

