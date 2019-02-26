function [ sets ] = sets_theory_sets( )
    
    % theories are saved here
    sets.promptfortheory = 1; % ask user for theories
	sets.theoryFold{1} = '/home/albyback/rawData/dnaData/humanData/exp/2330P18/';
    sets.theoryNames{1} = '2330P18.fa';
	sets.theoryFold{2} = '/media/albyback/125EE6685EE643D7/DATA/HC/Human DNA Project/BACs/Sequences/';
    sets.theoryNames{2} = 'P13.fa';
	sets.theoryFold{3} = '/media/albyback/125EE6685EE643D7/DATA/HC/Human DNA Project/BACs/Sequences/';
    sets.theoryNames{3} = 'J19 (with additional sequence one side).fasta';
    sets.theoryFold{4} = '/media/albyback/125EE6685EE643D7/DATA/HC/Human DNA Project/BACs/Sequences/';
    sets.theoryNames{4} = 'J21.fasta';
    sets.theoryFold{5} = '/media/albyback/125EE6685EE643D7/DATA/HC/Human DNA Project/BACs/Sequences/';
    sets.theoryNames{5} = 'C17 (with surrounding sequence).txt';
    sets.theoryFold{6} = '/media/albyback/125EE6685EE643D7/DATA/HC/Human DNA Project/BACs/Sequences/';
    sets.theoryNames{6} = 'H8 (with surrounding sequence).fa';
    
    % lambda folder
    sets.lambda.fold ='';
    sets.lambda.name = 'sequence.fasta';
    
    % Theory generation
    sets.skipBarcodeGenSettings = 0;
    sets.skipChangeBpNmRatio = 0;
    
    % parameters
    sets.theoryGen.meanBpExt_nm = 0.3;
    sets.theoryGen.pixelWidth_nm= 130;
    sets.theoryGen.psfSigmaWidth_nm = 300;
    sets.theoryGen.concN=6;
    sets.theoryGen.concY=0.02;
    sets.theoryGen.concDNA = 0.2;
    sets.theoryGen.isLinearTF = 1;
    sets.theoryGen.deltaCut = 3;
    sets.theoryGen.widthSigmasFromMean = 4;
    sets.theoryGen.yoyo1BindingConstant = 26; % yoyo binding constant
    sets.theoryGen.computeFreeConcentrations = 1;
	sets.theoryGen.model = 'literature';
    import CBT.Hca.Core.Theory.cb_model;
    sets.model = cb_model();
    
end

