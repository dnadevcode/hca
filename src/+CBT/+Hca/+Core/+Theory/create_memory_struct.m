function [chr1,header] = create_memory_struct(file)
    %   create_memory_struct - memory structure to fix the issues when a
    %   very large theory is loaded to matlab
    %   https://se.mathworks.com/help/bioinfo/examples/working-with-whole-genome-data.html
    %
    %   Args:
    %       file : filename of the file to be loaded
    %
    %   Returns:
    %       chr1,header: memory mapped sequence and header
    
    % open the file
    fidIn = fopen(file,'r');
    header = fgetl(fidIn);
    
    % get the file parts of the theory
    [fullPath, filename, extension] = fileparts(file);
    
    % save it temporarily in the working directory
    mmFilename = [filename '.mm'];
    fidOut = fopen(mmFilename,'w');
    newLine = sprintf('\n');

    blockSize = 2^20;
    while ~feof(fidIn)
        % Read in the data
        charData = fread(fidIn,blockSize,'*char')';
        % Remove new lines
        charData = strrep(charData,newLine,'');
        charData = erase(charData,char(13));

        % Convert to integers
        intData = nt2int(charData);
        % Write to the new file
        fwrite(fidOut,intData,'uint8');
    end
    fclose(fidIn);
    fclose(fidOut);
    
    % memory mapped file
    chr1 = memmapfile(mmFilename, 'format', 'uint8');        

        
end

