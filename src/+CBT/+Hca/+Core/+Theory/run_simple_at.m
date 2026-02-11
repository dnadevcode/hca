function [x] = run_simple_at(ts)
    % run ismple theory
    %   Args:
    %       ts
    %   Returns:
    %       x
    %
    
    
    % cummulative sum of GC's. 
    numWsCumSum = cumsum((ts == 2)  | (ts == 3) );

    %  Find all ligands without any A's or T's, i.e. i and i+4 should
    %  have the same value. We start at the left of the first possible
    %  ligand
    binsize=4;
    x = [numWsCumSum(binsize+1:end) == numWsCumSum(1:end-binsize)];
    for i =1:binsize
    x=[x;0];
    end

   
end