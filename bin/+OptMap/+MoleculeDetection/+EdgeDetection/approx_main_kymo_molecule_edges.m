function [moleculeStartEdgeIdxs, moleculeEndEdgeIdxs, mainKymoMoleculeMask] = approx_main_kymo_molecule_edges(kymo, edgeDetectionSettings)
    % APPROX_MAIN_KYMO_MOLECULE_EDGES - Attempts to find the start and
    %  end indices for the main molecule in the kymograph
    %
    % For more details see:
    %  See basic_otsu_approx_main_kymo_molecule_edges
    %  See adjust_kymo_edge_detection
    %
    % Inputs:
    %   kymo
    %   kymoEdgeDetectionSettings
    %   
    % Outputs:
    %   moleculeStartEdgeIdxsApprox
    %   moleculeEndEdgeIdxsApprox
    %   mainKymoMoleculeMaskApprox
    %
    % Authors:
    %   Saair Quaderi
    %     (refactoring)
    %   Charleston Noble
    %     (original version, algorithm)
    
    if ~edgeDetectionSettings.skipDoubleTanhAdjustment
        moleculeStartEdgeIdxsFirstApprox = ones(size(kymo,1),1);
        moleculeEndEdgeIdxsFirstApprox = size(kymo,2)*ones(size(kymo,1),1);
        import OptMap.MoleculeDetection.EdgeDetection.DoubleTanh.adjust_kymo_edge_detection;
        tanhSettings = edgeDetectionSettings.tanhSettings;
        [moleculeStartEdgeIdxs, moleculeEndEdgeIdxs, mainKymoMoleculeMask] = adjust_kymo_edge_detection(...
            kymo, ...
            moleculeStartEdgeIdxsFirstApprox, ...
            moleculeEndEdgeIdxsFirstApprox, ...
            tanhSettings ...
        );

    else
        
        otsuApproxSettings = edgeDetectionSettings.otsuApproxSettings;
        import OptMap.MoleculeDetection.EdgeDetection.basic_otsu_approx_main_kymo_molecule_edges;
        [moleculeStartEdgeIdxs, moleculeEndEdgeIdxs, mainKymoMoleculeMask] = basic_otsu_approx_main_kymo_molecule_edges(...
            kymo, ...
            otsuApproxSettings.globalThreshTF, ...
            otsuApproxSettings.smoothingWindowLen, ...
            otsuApproxSettings.imcloseHalfGapLen, ...
            otsuApproxSettings.numThresholds, ...
            otsuApproxSettings.minNumThresholdsFgShouldPass ...
        );
    end
    
	if (all(isnan(moleculeStartEdgeIdxs)) || all(isnan(moleculeEndEdgeIdxs)))
        error('Edge detections missing');
    end
    
end