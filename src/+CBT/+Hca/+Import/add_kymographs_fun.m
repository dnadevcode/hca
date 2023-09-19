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
        
        

    
    try 
        if sets.whichtokeep
            keep = sets.whichtokeep;
        end
    catch
        keep = 1:length(sets.kymosets.filenames);
    end
    
    
    % predefine structure
    kymoStructs = cell(1,length(keep));
    
    
    for i=1:length(keep)
        [~,~,fl] = fileparts(fullfile(sets.kymosets.kymofilefold{keep(i)},sets.kymosets.filenames{keep(i)}));
        if ~isequal(fl,'.mat')
            kymoStructs{i}.name = sets.kymosets.filenames{keep(i)};
        % TODO: preferably extract position in the original movie as well
        % from the name

    
            % save unaligned kymograph
            if length(imfinfo(fullfile(sets.kymosets.kymofilefold{keep(i)},kymoStructs{i}.name))) == 3
                % 1 is enhanced, 2 is kymo, 3 is bitmask
                kymoStructs{i}.unalignedKymo = imread(fullfile(sets.kymosets.kymofilefold{keep(i)},kymoStructs{i}.name),2);
                kymoStructs{i}.unalignedBitmask = logical(imread(fullfile(sets.kymosets.kymofilefold{keep(i)},kymoStructs{i}.name),3));
                
            else
                kymoStructs{i}.unalignedKymo = imread(fullfile(sets.kymosets.kymofilefold{keep(i)},kymoStructs{i}.name));
                try
                kymoStructs{i}.unalignedBitmask = imread(fullfile(sets.kymosets.kymofilefold{keep(i)},strrep(kymoStructs{i}.name,'kymograph','bitmask')));
                catch
                end
            end
            fd = fopen(matKymopathShort,'a'); fprintf(fd, '%s \n',fullfile(sets.kymosets.kymofilefold{keep(i)},kymoStructs{i}.name)); fclose(fd);
        end
    end
end

