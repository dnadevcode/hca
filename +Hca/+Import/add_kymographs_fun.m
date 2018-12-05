function [kymoStructs] = add_kymographs_fun(sets)
    % add_kymographs_fun
    % Used for reading kymographs from input structure   
    %
    %     Args:
    %         sets (struct): Input settings
    % 
    %     Returns:
    %         kymoStructs: Kymograph structure
    %
    %   Example: 
    %       sets.kymoFold has to be a folder with kymograph .tif files

    
    % predefine structure
    kymoStructs = cell(1,length(sets.kymosets.filenames));
    
    
    for i=1:length(sets.kymosets.filenames)
        kymoStructs{i}.name = sets.kymosets.filenames{i};
        % TODO: preferably extract position in the original movie as well
        % from the name
        % save unaligned kymograph
        kymoStructs{i}.unalignedKymo = imread(strcat([sets.kymosets.kymofilefold{i} kymoStructs{i}.name ]));
    end
end

