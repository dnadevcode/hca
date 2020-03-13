function [moleculeStartEdgeIdxs, moleculeEndEdgeIdxs, mainKymoMoleculeMask] = approx_main_kymo_molecule_edges(kymo, edgeDetectionSettings)
    % APPROX_MAIN_KYMO_MOLECULE_EDGES - Attempts to find the start and
    %  end indices for the main molecule in the kymograph
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
    %   Albertas Dvirnas
    %   new algorithm, fix bugs
    %   Saair Quaderi
    %     (refactoring)
    %   Charleston Noble
    %     (original version, algorithm)
    
    method=  edgeDetectionSettings.method;
    
    import OptMap.MoleculeDetection.EdgeDetection.get_default_edge_detection_settings;
    edgeDetectionSettings = get_default_edge_detection_settings(1);

            
    switch method
        case 'Otsu'
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
        case 'Double tanh'
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
        case 'Error function'
            import OptMap.MoleculeDetection.EdgeDetection.Fit.fit_sigmoid_on_kymo;
            [fitsLeft, fitsRight,confLeft,confRight] = fit_sigmoid_on_kymo(kymo);  
            
            moleculeStartEdgeIdxs = fitsLeft(:,3);
            moleculeEndEdgeIdxs = fitsRight(:,3);
            
            mainKymoMoleculeMask = false(size(kymo));
            for i=1:size(kymo,1)
                mainKymoMoleculeMask(i,max(1,round(moleculeStartEdgeIdxs(i))):min(size(kymo,2),round(moleculeEndEdgeIdxs(i)))) = 1;
            end

%             figure,imagesc(kymo)
%             hold on,plot(fitsLeft(:,3)',1:size(kymo,1),'.r','linewidth',3)
%             plot(confLeft,1:size(kymo,1),'-black','linewidth',3)
%             plot(fitsRight(:,3)',1:size(kymo,1),'.r','linewidth',3)
%             plot(confRight,1:size(kymo,1),'-black','linewidth',3)


    end


    
	if (all(isnan(moleculeStartEdgeIdxs)) || all(isnan(moleculeEndEdgeIdxs)))
        error('Edge detections missing');
    end
    
end