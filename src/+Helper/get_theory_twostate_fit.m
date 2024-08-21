function [theorySeq, theoryStr,yoyoBindingProb,netropsinBindingConst] = get_theory_twostate_fit(fastaName,gcSF,pxSize,nmpx,isC,sigma,kN,psf,cY, cN,kY,ligandLength,yoyoBindingProb)

    % todo: load this to speed things up
    [~,mid,~] = fileparts(fastaName);

    saveforspeed = 0;

    try
        data = load(['seq_example',mid,'_',num2str(ligandLength) ,'.mat']);
    catch
        fasta = fastaread(fastaName);
        ntSeq = nt2int(fasta.Sequence);

        sz = ones(1,ligandLength)*4;
        I = arrayfun(@(x) ntSeq(x+(1:length(ntSeq)-ligandLength+1)),0:ligandLength-1,'un',false);
        data.idsElt = sub2ind(sz, I{:} );
    
        data.atsum = cumsum((ntSeq == 1)  | (ntSeq == 4) );
        data.name = fasta.Header;
%         idsElt = zeros(1,length(ntSeq)-ligandLength+1);
%         sz = ones(1,ligandLength)*4;
%         for i=1:length(ntSeq)-ligandLength+1
%             cellInd = num2cell(ntSeq(i:i+ligandLength-1));
%             idsElt(i) = sub2ind(sz, cellInd{:} );
%         end

        if saveforspeed == 1;
            save(['seq_example',mid,'_',num2str(ligandLength) ,'.mat'],"-fromstruct",data);
        end

    end

    if nargin < 13 || isempty(yoyoBindingProb)
        constFun = arrayfun(@(x) kN*exp(-x/sigma),(0:ligandLength));
        probYoyo = cY*kY./(1+cY*kY+cN.*constFun);
        [sortedSubseq, sortv, countATs, orderSeq] = sorted_NT(ligandLength);
        yoyoBindingProb = ones(1,4^ligandLength);
        yoyoBindingProb(orderSeq) =  probYoyo(ligandLength+1-countATs);
        netropsinBindingConst = constFun(ligandLength+1-countATs);
    end

    % cummulative sum of AT's. 
%     numWsCumSum = cumsum((ntSeq == 1)  | (ntSeq == 4) );

    import CBT.SimpleTwoState.gen_simple_theory_px_fit;
    [theorySeq] = gen_simple_theory_px_fit(data.atsum,gcSF,pxSize,nmpx,isC,sigma,kN,psf,cY, cN,kY,ligandLength,yoyoBindingProb,data.idsElt);

    if nargout >=2
        theoryStr{1}.rawBarcode = theorySeq;
        theoryStr{1}.rawBitmask =[];
        theoryStr{1}.length = length(theorySeq);
        theoryStr{1}.name = data.name;
        theoryStr{1}.isLinearTF = ~isC;
    end
end

