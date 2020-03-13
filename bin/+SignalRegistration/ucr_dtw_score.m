function [rezMax] = ucr_dtw_score(theory, experiment, expBit, sets)
    %   ucr_dtw_score - computes dtw score using "trillion" code from UCR
    %
    %
    %   Args:
    %       shortVec, longVec, shortVecBit
    %   returns:
    %       rezMax - which stores maxcoef,pos, and or
    %


%     % mex the c function. This Should be mexed before    
%     mex 'bin/OVERLAPPING_DTW_MEX.cpp';
    
	% Instead of saving these every time, just have them saved as txt's and
	% pass them to ucr function. Should be a more clever way to do this
	% though.
    fname = strcat(['experiment.txt']); fileID = fopen(fname,'w');
    fprintf(fileID,'%2.5f ',experiment(expBit)); fclose(fileID);
    % reversed
    fname = strcat(['experimentrev.txt']); fileID = fopen(fname,'w');
    fprintf(fileID,'%2.5f ',fliplr(experiment(expBit))); fclose(fileID);
    
    
    % subsequence length.
    N = sum(expBit);

        % these first two are just to see how the query places as a
    % subsequence, they're not comparable to the rest of the scores because
    % they are for different length.
    [pos(1,1), scores(1,1)] = OVERLAPPING_DTW_MEX(theory,'experiment.txt', N, sets.comparison.R);
    [pos(1,2), scores(1,2)] = OVERLAPPING_DTW_MEX(theory,'experimentrev.txt', N, sets.comparison.R);

    % then we have one of the two choices for position
    if scores(1)< scores(2)
        rezMax.maxcoef = scores(1);
        rezMax.pos = pos(1);
        rezMax.or = 1;
    else
        rezMax.maxcoef = scores(2);
        rezMax.pos = pos(2);
        rezMax.or = 2;   
    end
    % faster function, only when barC has bitmask only on left and right
    %     xcorrs = unmasked_pcc_corr(barC, theorBar, barB);
    %     [rezMax.maxcoef,rezMax.pos,rezMax.or] = get_best_parameters(xcorrs, 3 );
    %     % now find the maximum score for this stretching parameter
    %     xcorrMax(j) = rezMax{j}.maxcoef(1);
                    
end

