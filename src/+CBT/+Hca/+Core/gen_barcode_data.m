function [barcodeGenData] = gen_barcode_data(alignedKymo,leftEdgeIdxs, rightEdgeIdxs)
    % gen_barcode_data
    %
    %     Args:
    %         alignedKymo: aligned kymograph
    %         leftEdgeIdxs: left edge indices on the aligned kymograph
    %         rightEdgeIdxs: right edge indices on the aligned kymograph
    % 
    %     Returns:
    %         barcodeGenData: Return structure
    % 

    leftEdgeIdx = round(nanmean(leftEdgeIdxs));
    rightEdgeIdx = round(nanmean(rightEdgeIdxs));
    
    if rightEdgeIdx <= leftEdgeIdx
        disp('ah');
    end
    
    % Determine indices for rotated barcode with background cropped out
    barcodeIdxs = leftEdgeIdx:rightEdgeIdx;
    rawBarcode = nanmean(alignedKymo, 1);
    
    % define background indices
    bgIndices = true(1, size(alignedKymo, 2));
    bgIndices(barcodeIdxs) = 0;

    nonBarcodeVals = alignedKymo(:, bgIndices);
    nonBarcodeVals = nonBarcodeVals(:);
    nonBarcodeDistFit = fitdist(nonBarcodeVals, 'Normal');
    barcodeGenData.bgMeanApprox =  nonBarcodeDistFit.mu;
    barcodeGenData.bgStdApprox = nonBarcodeDistFit.sigma;
    
    rawBg = nanmean(rawBarcode(bgIndices));
  
    barcodeGenData.rawBarcode = rawBarcode(barcodeIdxs);

    barcodeGenData.lE = leftEdgeIdx;
    barcodeGenData.rE = rightEdgeIdx;
    barcodeGenData.rawBg = rawBg;
end
