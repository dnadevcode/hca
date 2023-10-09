function [] = run_hca_theory(hcaSets)
    %   run_hca_theory - calculates HCA theory

    %   Args: hcaSets
    
    % timestamp to add to theories name
    timestamp = datestr(clock(), 'yyyy-mm-dd_HH_MM_SS');


    import CBT.Hca.Core.Theory.choose_cb_model;
    [hcaSets.model ] = choose_cb_model(hcaSets.theoryGen.method,hcaSets.pattern);

    % theories names
    theories = hcaSets.folder;

    hcaSets.resultsDir = fullfile(fileparts(theories{1}),'theoryOutput'); % we always save theories output in the same folder as provided data
    
    
    % make theoryData folder
    [~,~] = mkdir(hcaSets.resultsDir);

    % compute free concentrations
    import CBT.Hca.Core.Theory.compute_free_conc;
    hcaSets = compute_free_conc(hcaSets);
    
    theoryGen = struct();

    % save sets
    theoryGen.sets = hcaSets.theoryGen;
    % sets.theoryGen.meanBpExt_nm = meanBpExt_nm;
    meanBpExt_nm = hcaSets.theoryGen.meanBpExt_nm;
    pixelWidth_nm = hcaSets.theoryGen.pixelWidth_nm;
    psfSigmaWidth_nm = hcaSets.theoryGen.psfSigmaWidth_nm;
    linear = hcaSets.theoryGen.isLinearTF;

    theoryBarcodes = cell(1,length(theories));
    theoryBitmasks = cell(1,length(theories));
    theoryNames = cell(1,length(theories));
    theoryIdx = cell(1,length(theories));
    bpNm = cell(1,length(theories));

    import CBT.Hca.Core.Theory.compute_theory_barcode;

    % loop over theory file folder
    parfor idx = 1:length(theories)
    
        addpath(genpath(theories{idx}))
        disp(strcat(['loaded theory sequence ' theories{idx}] ));
    
        % new way to generate theory, check theory_test.m to check how it works
        [theorySeq, header,bitmask] = compute_theory_barcode(theories{idx},hcaSets);
    
	    theoryBarcodes{idx} = theorySeq;
        theoryBitmasks{idx} = bitmask;
    
        theoryNames{idx} = header;
        theoryIdx{idx} = idx;
        bpNm{idx} = meanBpExt_nm/psfSigmaWidth_nm;         
    end
    
    theoryGen.theoryBarcodes = theoryBarcodes;
    theoryGen.theoryBitmasks = theoryBitmasks;
    theoryGen.theoryNames = theoryNames;
    theoryGen.theoryIdx = theoryIdx;
    theoryGen.bpNm = bpNm;
    
    matFilename = strcat(['theoryGen_', num2str(meanBpExt_nm) '_' num2str(pixelWidth_nm) '_' num2str(psfSigmaWidth_nm) '_' num2str(linear) '_' sprintf('%s_%s', timestamp) 'session.mat']);
    matFilepath = fullfile(hcaSets.resultsDir, matFilename);
    
    save(matFilepath, 'theoryGen');
    fprintf('Saved theory mat filename ''%s'' to ''%s''\n', matFilename, matFilepath);

end

