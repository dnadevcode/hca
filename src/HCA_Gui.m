function [hcaStruct] = HCA_Gui(sets, hcaStruct)
    % HCA_Gui
    % Used for comparing fagments of human chromosome to chromosomes using CB (competitive binding) theory   
    %
    %     Args:
    %         sets (struct): Input settings to the method
    %         hcaStruct (struct): Input structure, if non-empty, load
    %         result structure instead of computing everything
    % 
    %     Returns:
    %         hcaStruct: Return structure
    % 
    %     Example:
    %         This is an example: run [hcaStruct] = HCA_Gui(sets) 
    %
    
    % TODO: return warnings to the places where it is important to know
    % what is being done and to check for consistency
    
    if nargin < 1 % if settings were not provided
        import CBT.Hca.Settings.set_fast_sets;
        sets = set_fast_sets();
        
%         sets.kymosets.askforkymos = 1; % sould we ask for kymos
%         sets.kymosets.askforsets = 0;
%         sets.consensus.promptForBarcodeClusterLimit = 0;
%         sets.theory.askfortheory = 1;
%         sets.genConsensus = 1;
    end
    
    if nargin < 2 

        import CBT.Hca.Settings.get_user_settings;
        % load all user selected settings
        sets = get_user_settings(sets);
        
        % add kymographs
        import CBT.Hca.Import.add_kymographs_fun;
        [kymoStructs] = add_kymographs_fun(sets);

        %  put the kymographs into the structure
        import CBT.Hca.Core.edit_kymographs_fun;
        kymoStructs = edit_kymographs_fun(kymoStructs,sets.timeFramesNr);

        % align kymos
        import CBT.Hca.Core.align_kymos;
        [kymoStructs] = align_kymos(sets,kymoStructs);
        
        % generate barcodes
        import CBT.Hca.Core.gen_barcodes;
        barcodeGen =  CBT.Hca.Core.gen_barcodes(kymoStructs, sets);
 
        % generate consensus
        import CBT.Hca.Core.gen_consensus;
        consensusStructs = CBT.Hca.Core.gen_consensus(barcodeGen,sets);
        %

        % select consensus
        import CBT.Hca.UI.Helper.select_consensus
        consensusStruct = select_consensus(consensusStructs,sets);
        
        % TODO : add consensus plot
%         % recreate consensus result from cbc_gui? 
%         import CBT.Hca.Core.gen_consensus_plot;
%         gen_consensus_plot(consensusStructs,sets);
        
        % generate random cut-outs
        if sets.random.generate
            % % Here generate cutouts using M_files_HCA_exp_cutouts:
            import CBT.Hca.Core.Random.cutout_barcodes;
            barcodeGenRandom = cutout_barcodes(barcodeGen,sets);
            barcodeGenC = barcodeGenRandom;
        else
            barcodeGenC = barcodeGen;
        end

        sets.theoryFile=[];
        sets.theoryFileFold = [];
%         sets.theoryFile{1} = 'allbarcodes_2018-09-05_11_31_46_session.mat';
%         sets.theoryFileFold{1} ='/home/albyback/rawData/dnaData/humanData/human_genome/file/';
%          
        % get user theory
        import CBT.Hca.Settings.get_user_theory;
        theoryStruct = get_user_theory(sets);
       % load('/home/albyback/rawData/dnaData/humanData/human_genome/file/theoryStruct_17-Dec-201814:05:43.mat');

        % compare theory to experiment
        import CBT.Hca.Core.Comparison.compare_theory_to_exp;
        comparisonStructAll = compare_theory_to_exp(barcodeGenC, theoryStruct, sets, consensusStruct);


        % bugcheck: if only one theory
        import CBT.Hca.UI.combine_chromosome_results;
        comparisonStruct = combine_chromosome_results(theoryStruct,comparisonStructAll);


   % assign all to base
        assignin('base','barcodeGenC', barcodeGenC)
        assignin('base','theoryStruct', theoryStruct)
        assignin('base','comparisonStructAll', comparisonStructAll)
        assignin('base','sets', sets)
        assignin('base','comparisonStruct', comparisonStruct)
        assignin('base','consensusStruct', consensusStruct)

        %
      %  sets.displayResults = 1;
        import CBT.Hca.UI.get_display_results;
        get_display_results(barcodeGenC,consensusStruct, comparisonStruct, theoryStruct, sets);


        import CBT.Hca.Core.additional_computations
        additional_computations(barcodeGenC,consensusStruct, comparisonStruct, theoryStruct,comparisonStructAll,sets );
        

      
      %  sets.output.matDirpath = '/home/albyback/rawData/dnaData/humanData/output/';
  
    else
        % run load results function or something similar..
    end
    
end