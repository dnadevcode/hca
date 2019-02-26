function [] = additional_computations( barcodeGenC, consensusStruct, comparisonStruct, theoryStruct,comparisonStructAll,sets )
    % additional_computations

    if sets.random.generate
        sets.output.matDirpath = strcat([sets.output.matDirpath num2str(sets.random.cutoutSize)]);
    else
        sets.output.matDirpath = strcat([sets.output.matDirpath 'all_molecules']);
    end
            
    try
        mkdir(sets.output.matDirpath);
    catch
        disp('Output falder already exists, continuing');
    end
    
    if ispc
        sampleName = 'sample1_';
    else
        sampleName = '/sample1_';
    end
    matDirpath = strcat([sets.output.matDirpath sampleName]);

    % export_cc_results
    import CBT.Hca.Export.export_cc_vals_table;
    [T] = export_cc_vals_table( theoryStruct, comparisonStructAll, barcodeGenC,matDirpath);

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

