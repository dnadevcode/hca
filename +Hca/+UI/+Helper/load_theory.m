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

        for i=1:length(barcodeData.hcaSessionStruct.theoryGen.theoryBarcodes)
            fname = strcat([sets.theoryFileFold{idx} 'theory_' matlab.lang.makeValidName(barcodeData.hcaSessionStruct.theoryGen.theoryNames{i}) '.txt']);
            fileID = fopen(fname,'w');
            fprintf(fileID,'%2.5f ',barcodeData.hcaSessionStruct.theoryGen.theoryBarcodes{i});
            fclose(fileID);
            theoryStruct{jj}.filename = fname;
            theoryStruct{jj}.meanBpExt_nm = barcodeData.hcaSessionStruct.theoryGen.sets.meanBpExt_nm;
            theoryStruct{jj}.pixelWidth_nm = barcodeData.hcaSessionStruct.theoryGen.sets.pixelWidth_nm;
            theoryStruct{jj}.psfSigmaWidth_nm = barcodeData.hcaSessionStruct.theoryGen.sets.psfSigmaWidth_nm;
            jj = jj+1;
        end
    end
    %%
%     
%     numFiles = length(barcodeData.hcaSessionStruct.theoryBarcodes);
% 
%     theoryBarcodes = cell(1,length(barcodeData.hcaSessionStruct.theoryBarcodes));
%     nameSequence = cell(1,length(barcodeData.hcaSessionStruct.theoryBarcodes));
%     bitmask = cell(1,length(barcodeData.hcaSessionStruct.theoryBarcodes));
%     bpNm =  cell(1,length(barcodeData.hcaSessionStruct.theoryBarcodes));
%     
%     for i=1:numFiles
%         theoryBarcodes{i} = barcodeData.hcaSessionStruct.theoryBarcodes{i};
%         nameSequence{i} = barcodeData.hcaSessionStruct.theoryNames{i};
%         bpNm{i} =barcodeData.hcaSessionStruct.bpNm{i} ;
%         bitmask{i} =barcodeData.hcaSessionStruct.bitmask{i};
%         sets = barcodeData.hcaSessionStruct.sets;
%     end
% 
%     hcaSessionStruct.theoryGen.theoryBarcodes = theoryBarcodes;
%     hcaSessionStruct.theoryGen.theoryNames = nameSequence;
%     hcaSessionStruct.theoryGen.bpNm = bpNm{1};
%     hcaSessionStruct.theoryGen.sets = sets;
% 
%     hcaSessionStruct.theoryGen.bitmask = bitmask;


end

