function [] = additional_computations( barcodeGenC, consensusStruct, comparisonStruct, theoryStruct,comparisonStructAll,sets )
    % additional_computations

    if sets.random.generate
        sets.output.matDirpath = fullfile(sets.output.matDirpath, num2str(sets.random.cutoutSize));
    else
        sets.output.matDirpath = fullfile(sets.output.matDirpath, 'all_molecules');
    end
            
    try
        [~,~] = mkdir(sets.output.matDirpath);
    catch
        disp('Output folder already exists, continuing');
    end
    
%     if ispc
        sampleName = 'sample1_';
%     else
%         sampleName = '/sample1_';
%     end

    timestamp = datestr(clock(), 'yyyy-mm-dd_HH_MM_SS');

    
    matDirpath = fullfile(sets.output.matDirpath,sampleName);

    % export_cc_results
    import CBT.Hca.Export.export_cc_vals_table;
    [T,timestamp] = export_cc_vals_table( theoryStruct, comparisonStructAll, barcodeGenC,matDirpath);

    % export settings
    save(fullfile(sets.output.matDirpath,['run_settings',timestamp, '.mat']),'sets');

    try
    if sets.saveinfoscores
        % export_infoscore_results. Temporary moved
        import CBT.Hca.Export.export_infoscore_vals_table;
        [T] = export_infoscore_vals_table( barcodeGenC,fullfile(sets.output.matDirpath,'infoscore'));
    end
    catch
    end
    
    % todo: include additional plots in a later version
    
%     import CBT.Hca.Export.plot_comparison_vs_theory;
%     plot_comparison_vs_theory(comparisonStruct,theoryStruct,barcodeGenC,1,sets.export.savetxt);
% 
%     % plot barcodes on selected theory
%     import CBT.Hca.Export.plot_comparison_exp_vs_exp;
%     plot_comparison_exp_vs_exp([1:10],comparisonStruct,theoryStruct,barcodeGenC)
% 
%     import CBT.Hca.Export.plot_kymograph;
%     plot_kymograph(1, kymoStructs,barcodeGen );
% 
%     import CBT.Hca.Export.plot_infoscore;
%     plot_infoscore(barcodeGen );


         

end

