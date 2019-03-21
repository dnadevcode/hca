function [ theoryStruct ] = load_theory( sets )
    % load_theory
    % Loads theory names from path
    %     Args:
    %         barcodeGen: barcode structure
    %         sets: Input settings to the method
    % 
    %     Returns:
    %         consensusStructs: Consensus tree structure
    % 
    %     Example:
    %          
    
    % In case theory is in a single file, read of it's contents into a
    % folder and then save the names of the theories
    
   % theoryStruct = cell(1,length(barcodeData.hcaSessionStruct.theoryBarcodes));
    jj = 1;

    for idx=1:length(sets.theoryFileFold)
        addpath(genpath(sets.theoryFileFold{idx}));
        barcodeData = load(sets.theoryFile{idx});
        
        try % there can be different kind of input data, so use the appropriate one
            bars = barcodeData.hcaSessionStruct.theoryGen.theoryBarcodes;
            names = barcodeData.hcaSessionStruct.theoryGen.theoryNames;
            setsB = barcodeData.hcaSessionStruct.theoryGen.sets;
        catch
            try
                bars = barcodeData.hcaSessionStruct.theoryBarcodes;
                names = barcodeData.hcaSessionStruct.theoryNames;
                setsB = barcodeData.hcaSessionStruct.sets;
            catch
                bars = barcodeData.theoryBarcodes;
                names = barcodeData.theoryNames;
                setsB = barcodeData.sets; 
            end 
        end
            
        for i=1:length(bars)
            fname = strcat([sets.theoryFileFold{idx} num2str(jj)  '.txt']);
            fileID = fopen(fname,'w');
            fprintf(fileID,'%2.5f ',bars{i});
            fclose(fileID);
            theoryStruct{jj}.filename = fname;
            theoryStruct{jj}.name = names{i};
            theoryStruct{jj}.length =  length(bars{i});
            theoryStruct{jj}.meanBpExt_nm = setsB.meanBpExt_nm;
            theoryStruct{jj}.pixelWidth_nm = setsB.pixelWidth_nm;
            theoryStruct{jj}.psfSigmaWidth_nm = setsB.psfSigmaWidth_nm;
            jj = jj+1;
        end
    end
    %

end

