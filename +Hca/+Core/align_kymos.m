function [ kymoStructs ] = align_kymos( sets, kymoStructs )
    % align_kymos
    % Runs alignment of kymographs. Currently two choices of
    % methods - ssdalign and nralign. Add possibility of more methods in  
    %
    %     Args:
    %         sets: settings structure
    %         unalignedKymos: unaligned kymographs
    % 
    %     Returns:
    %         alignedKymo: aligned kymographs
    %         leftEdgeIdxs: left edge indices of the molecule
    %         rightEdgeIdxs: left edge indices of the molecule
   
    disp('Starting kymo alignment...')
    
    % the two methods that could be used
    import OptMap.KymoAlignment.SSDAlign.ssd_align;
    import OptMap.KymoAlignment.NRAlign.nralign;
    tic %
    % based on an alignment method choice
    if sets.alignMethod==2 
        ssdCoef = cell(1,length(kymoStructs));
        for i=1:length(kymoStructs)
            [kymoStructs{i}.alignedKymo,  ssdCoef{i}] = ssd_align(double(kymoStructs{i}.unalignedKymo),sets);
            import OptMap.MoleculeDetection.EdgeDetection.approx_main_kymo_molecule_edges;
            [ kymoStructs{i}.leftEdgeIdxs,kymoStructs{i}.rightEdgeIdxs,~] = approx_main_kymo_molecule_edges(kymoStructs{i}.alignedKymo, sets.edgeDetectionSettings);
        end   
    else

        for i=1:length(kymoStructs)
            kymoStructs{i}.alignedKymo = nralign(double(kymoStructs{i}.unalignedKymo));
            % nralign doesn't compute the left and right edge idx, so we
            % compute them here
            import OptMap.MoleculeDetection.EdgeDetection.approx_main_kymo_molecule_edges;
            [ kymoStructs{i}.leftEdgeIdxs,kymoStructs{i}.rightEdgeIdxs,~] = approx_main_kymo_molecule_edges(kymoStructs{i}.alignedKymo, sets.edgeDetectionSettings);
        end       
    end

    timePassed = toc;
    disp(strcat(['All kymos were aligned in ' num2str(timePassed) ' seconds']));

	%assignin('base','hcaSessionStruct',hcaSessionStruct)

end

