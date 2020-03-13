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

%     
%     if nargin< 2
%         matKymopathShort ='kymos.txt';
%     end
%     
    timestamp = datestr(clock(), 'yyyy-mm-dd_HH_MM_SS');

    matKymopathShort = fullfile(sets.output.matDirpath, strcat(['kymos_' sprintf('%s_%s', timestamp) '.txt']));
    fd = fopen(matKymopathShort,'w');    fclose(fd);
        
        

    
    % predefine structure
    kymoStructs = cell(1,length(sets.kymosets.filenames));
    
    
    for i=1:length(sets.kymosets.filenames)
        kymoStructs{i}.name = sets.kymosets.filenames{i};
        % TODO: preferably extract position in the original movie as well
        % from the name
        % save unaligned kymograph
        kymoStructs{i}.unalignedKymo = imread(fullfile(sets.kymosets.kymofilefold{i},kymoStructs{i}.name));
        
        fd = fopen(matKymopathShort,'a'); fprintf(fd, '%s \n',fullfile(sets.kymosets.kymofilefold{i},kymoStructs{i}.name)); fclose(fd);

    end
end

