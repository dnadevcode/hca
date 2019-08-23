function [] = hca_theory_script( fastas,settings )
  % hca_theory_script
  % This script generates the theory of selected fasta files
  % mimicing the hca theory gui, and runnable from the terminal
    
    % settings - name of the settings file
    % tif - name of the tif file
    
    % no output displayed apart from messages to the terminal, the 
    % output saved in the output folder
    
    % In case input files are not provided, set them automatically
    if nargin < 2
        settings = 'runsettings.txt';
        fastas = 'fastatorun.txt';
    end
    

    import CBT.Hca.Settings.sets_theory_sets;
    sets = sets_theory_sets();

    
    % load settings to a structure
    try fid=fopen(settings); C2 = textscan(fid, '%s %s'); fclose(fid);
        sets.theoryGen = cell2struct(C2{2},C2{1},1);
    catch
        error('No valid settings file provided');
    end
    
    
    % convert names to numerical values, apart from the values which should
    % be strings
    fn = fieldnames(sets.theoryGen);
    for k=1:numel(fn)
        if( ~isequal(fn{k},'literature'))
            sets.theoryGen.(fn{k}) = str2num(sets.theoryGen.(fn{k}));            
        end
    end

    % compute free concentrations
    import CBT.Hca.Core.Theory.compute_free_conc;
    sets = compute_free_conc(sets);

    theoryGen = struct();

   try 
        fid = fopen(fastas); 
        fastaNames = textscan(fid,'%s','delimiter','\n'); fclose(fid);
   catch
        error('No valid fasta provided, please check the provided file');
   end
    
 
    % loop over movie file folder
    for idx = 1:length(fastaNames{1})
        %addpath(genpath(fastaNames{idx}))
        
        theoryData = fastaread(fastaNames{1}{idx});

        disp(strcat(['loaded theory sequence ' theoryData(1).Header] ));

        import CBT.Hca.Core.Theory.compute_hca_theory_barcode;
        [theorySeq,bitmask] = compute_hca_theory_barcode(theoryData(1).Sequence,sets);
        
        theoryGen.theoryBarcodes{idx} = theorySeq;
        theoryGen.theoryNames{idx} = theoryData(1).Header;
        theoryGen.theoryIdx{idx} = idx;
        theoryGen.bpNm{idx} = sets.theoryGen.meanBpExt_nm/sets.theoryGen.psfSigmaWidth_nm;
    end

    theoryGen.sets = sets.theoryGen;
    
 	timestamp = datestr(clock(), 'yyyy-mm-dd_HH_MM_SS');
	matFilename = strcat(['theoryStruct_' sprintf('%s_%s', timestamp) 'session.mat']);
    matFilepath = fullfile('resultData', matFilename);

    save(matFilepath, 'theoryGen');
    
    fprintf('Saved theory struct data ''%s'' to ''%s''\n', matFilename, matFilepath);


end

