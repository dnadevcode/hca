function [T] = export_infoscore_vals_table( barcodeGenC,matDirpath )
    % export_infoscore_vals_table

    % Input:
       % barcodeGenC,matDirpath
    % Output:
    
    % barcode names
    T = table(cellfun(@(x) x.name ,barcodeGenC,'UniformOutput',false)','VariableNames',{'experiment'});

	T2 = table(cellfun(@(x) x.infoscore.mean,barcodeGenC)',cellfun(@(x) x.infoscore.std,barcodeGenC)' ,'VariableNames',{'mean','std'});

    
    % score1: mean+3std
    TS1 =  table(cellfun(@(x) x.infoscore.mean,barcodeGenC)'+3*cellfun(@(x) x.infoscore.std,barcodeGenC)' ,'VariableNames',{'score1'});

    
    % score2: mean/std
    TS2 =  table(cellfun(@(x) x.infoscore.mean,barcodeGenC)'./cellfun(@(x) x.infoscore.std,barcodeGenC)' ,'VariableNames',{'score2'});

    is3 = zeros(1,length(barcodeGenC));
    for i=1:length(barcodeGenC);
        vals =barcodeGenC{i}.rawBarcode(barcodeGenC{i}.rawBitmask);
        is3(i) = sum(abs(zscore(vals)) > 3)/length(vals);
    end
    % score3: proportion of values outside mean+3std
    TS3 =  table(is3' ,'VariableNames',{'score3'});

    T = [T T2 TS1 TS2 TS3];

    disp('Saving infoscore table');
    disp('Score1: mean+3std');
    disp('Score2: mean/std');
    disp('Score3: proportion of values outside mean+3std');
    import CBT.Hca.Export.export_cc;
    export_cc(T, matDirpath);      


end

