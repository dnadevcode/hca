function [ sets ] = set_fast_sets()
    % set_fast_sets 
    % Set quick pre-defined settings for HCA.
    % If we want, we can run the program
    % without any prompts, good if we want to run multiple things.
    %
    %     Returns:
    %         sets (struct): pre-defined settings structure
    % 
    %     Example:
    %         This is an example: run sets = set_fast_sets()
    
    %
    sets.kymosets.askforkymos = 0; % sould we ask for kymos
    
    % sample filename, comment out for the release version
    sets.kymosets.kymofilefold{1} = '/home/albyback/rawData/dnaData/humanData/exp/963J21/Raw Kymos/';
    sets.kymosets.filenames{1} = 'J21_170609_OD4_100msExp_11_molecule_12_kymograph.tif';

    % all the different setting choices
    sets.kymosets.askforsets = 0; % should we ask for settings
	sets.timeFramesNr = 0; % 0 - take all timeframes
    sets.alignMethod = 1; % 1 - nralign, 2 - ssdalign
   	sets.filterSettings.filter = 0; % filter
    sets.genConsensus = 1; % generate consensus
    sets.random.generate = 1; % generate random

    
    % filter settings. For one timeframe, refer to P.Torche paper for best
    % parameters
	sets.filterSettings.filterMethod = 0; % 0 - filter after stretching, 1 - before
    sets.filterSettings.filterSize = 2.3;
    
    % edge detection  settings
    sets.skipDoubleTanhAdjustment = 1;
    import OptMap.MoleculeDetection.EdgeDetection.get_default_edge_detection_settings;
    sets.edgeDetectionSettings = get_default_edge_detection_settings(sets.skipDoubleTanhAdjustment);
    
    % bitmask settings
    sets.bitmasking.prestretchPixelWidth_nm = 130; % camera nm/px
	sets.bitmasking.psfSigmaWidth_nm = 300; % psf in nanometers
	sets.bitmasking.deltaCut = 3; % how many delta's should we take
    sets.bitmasking.untrustedPx = sets.bitmasking.deltaCut*sets.bitmasking.psfSigmaWidth_nm/sets.bitmasking.prestretchPixelWidth_nm;

    % consensus settings
    sets.consensus.barcodeNormalization = 'bgmean';
    sets.consensus.promptForBarcodeClusterLimit = 1;
    sets.consensus.threshold = 0.75;

    
    % Random cutouts
    sets.random.noOfCutouts = 10; % number of random cutouts from the input set
    sets.random.cutoutSize = 100; % size of region to be cut out (units: pixels)

    %
    sets.theory.askfortheory = 0;
	sets.theoryFileFold{1} = '/home/albyback/rawData/dnaData/humanData/';
    sets.theoryFile{1}= 'ncbi_chromosomes_181022_130nmPixel_0.3nmPERbp.mat';
    sets.theory.askfornmbp = 1;
    sets.theory.nmbp = 0.224;
	%sets.theory.skipStretch = 1; %0 - do not stretch,  1 - stretch
	sets.theory.stretchFactors = [0.95 0.96 0.9700    0.9800    0.9900    1.0000    1.0100    1.0200    1.0300 1.04 1.05];
%         % 
    
   % sets.export.savetxt = 1;
%     sets.displayResults = 1;
%     
% 
% 
% 
%  
%     % stretching
%     sets.skipPrechoice = 1;
%     sets.prestretchMethod = 0; % 0 - do not prestretch % 1 - prestretch to common length

%     % filter settings
%     sets.skipFilterSettings = 1;
%     
%    
%     % Theory generation
%     sets.skipBarcodeGenSettings = 1;
%     sets.skipChangeBpNmRatio = 1;
% 
%     % all file folders should be possibly removed in the release

% 
%     % barcode theory generation settings
%     sets.barcodeGenSettings.meanBpExt_nm = 0.225;
%     sets.barcodeGenSettings.pixelWidth_nm = 130;
%     sets.barcodeGenSettings.concNetropsin_molar = 6;
%     sets.barcodeGenSettings.concYOYO1_molar = 0.02;
%     sets.barcodeGenSettings.isLinearTF = 0;
%     sets.barcodeGenSettings.psfSigmaWidth_nm = 300;
%     sets.barcodeGenSettings.deltaCut = 3;
%     sets.barcodeGenSettings.widthSigmasFromMean = 4;
%     sets.barcodeGenSettings.yoyo1BindingConstant = 26;
%     
%     sets.skipNullModelChoice = 1;
%     sets.nullModelPath = '/home/albyback/git/WORKSHOP/HCA_v1.6/nullmodel';
%     sets.askForPvalueSettings = 0;
%     sets.pvaluethresh = 0.01;
%     sets.contigSettings.numRandBarcodes = 1000;

end

