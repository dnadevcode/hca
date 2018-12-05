function [T] = export_cc_vals_table( theoryStruct,comparisonStructAll,comparisonStruct, barcodeGen,matDirpath )
    % export_cc_vals_table
    % only for single barcodes, dont include the consensus here
    
    fasta = cellfun(@(x) strrep(x.filename,'.txt',''), theoryStruct,'UniformOutput',false);
    thrLen = cellfun(@(x) x.length, theoryStruct);

    T = table(fasta');

    for i=1:length(barcodeGen)
        maxccoef = cell2mat(cellfun(@(x) x{i}.maxcoef(1), comparisonStructAll,'UniformOutput',0));
        lengthPx = cell2mat(cellfun(@(x) x{i}.length,comparisonStructAll,'UniformOutput',0));
        pos = cell2mat(cellfun(@(x) x{i}.pos(1), comparisonStructAll,'UniformOutput',0));
        stretch =  cell2mat(cellfun(@(x) x{i}.bestBarStretch,comparisonStructAll,'UniformOutput',0));
        for j=1:length(pos)
           if pos(j)<= 0
               pos(j) = pos(j)+thrLen(j);
           end
        end
        maxcc = maxccoef;

        N = matlab.lang.makeValidName(barcodeGen{i}.name);
        if length(comparisonStruct) == 1

            for j =1:length(maxcc)
                N = strcat([matlab.lang.makeValidName(barcodeGen{j}.name) num2str(i)]);
                T2 = table(maxcc(j),lengthPx(j), pos(j), stretch(j) ,'VariableNames',{N ,strcat(['len_'  num2str(j)]),strcat(['pos_'  num2str(j)])});
                T = [T T2];
            end
        else
            T2 = table(maxcc',lengthPx', pos',stretch' ,'VariableNames',{N,strcat(['len_'  num2str(i)]),strcat(['pos_'  num2str(i)]),strcat(['stretch_'  num2str(i)])});
            T = [T T2];
        end
    end
    CBT.Hca.Export.export_cc(T, matDirpath);      


end

