function [ sets ] = sets_theory_sets( )
    
    % theories are saved here
	sets.theoryFold{1} = '/home/albyback/git/rawData/humanDNA/Files/2330P18/';
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
    % Theory generation
    sets.skipBarcodeGenSettings = 0;
    sets.skipChangeBpNmRatio = 0;
    
    % parameters
    sets.barcodeGenSettings.meanBpExt_nm = 0.3;
    sets.barcodeGenSettings.pixelWidth_nm= 130;
    sets.barcodeGenSettings.psfSigmaWidth_nm = 300;
    sets.barcodeGenSettings.concNetropsin_molar=6;
    sets.barcodeGenSettings.concYOYO1_molar=0.02;
    sets.barcodeGenSettings.concDNA = 0.2;
    sets.barcodeGenSettings.isLinearTF = 1;
    sets.barcodeGenSettings.deltaCut = 3;
    sets.barcodeGenSettings.widthSigmasFromMean = 4;
    sets.barcodeGenSettings.yoyo1BindingConstant = 26; % yoyo binding constant
    sets.barcodeGenSettings.computeFreeConcentrations = 1;
	sets.barcodeGenSettings.model = 'literature';

    
end

