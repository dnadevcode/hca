function [ maxcoef,pos,or ] = get_best_parameters( xcorrs, numBestPar)
    % get_best_parameters
    
    % input xcorrs - cross correlation coefficients
    % numBestPar - number of coefficients to output
    % output rezMax
    
    if nargin < 2
        numBestPar = 3; % default is 3
    end

    % f gives the max over the two rows, s gives the indice of
    % which row has the max (1 or 2)
    [f,s] =max(xcorrs);

    % sort the max scores, ix stores the original indices
    [ b, ix ] = sort( f(:), 'descend' );

    % choose the best three scores. (change this in the future?)
    indx = b(1:numBestPar)' ;

    % save the best three max score, and their orientation
    maxcoef = indx;
    or = s(ix(1:numBestPar)');

    % finally, save the position. This can have two cases,
    % depending on the value of s
	pos = ix(1:numBestPar)';

end