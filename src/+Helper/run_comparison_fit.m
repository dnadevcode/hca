function [compI,rezI,m,st,sS,theoryStr,yoyoBindingProb,netropsinBindingConst] = run_comparison_fit(barGen,fastaFile,gcSF,pxSize,nmpx,isC,sigma,kN,psf,cY, cN,kY,ligandLength,parchangeId,par,sF,sets)

%   run_comparison_fit - optimisation procedure to find best parameter
%   values

import Helper.get_theory_twostate_fit;

parlist = [gcSF,pxSize,nmpx,isC,sigma,kN,psf,cY,cN,kY,ligandLength];
parlistcell = num2cell(parlist) ;

k=1;
pars = [parlistcell(1:parchangeId-1) par(k) parlistcell(parchangeId+1:end)]; 


% generate initial yoyoBindingProb vector:
[~, theoryStr, yoyoBindingProb,netropsinBindingConst] = get_theory_twostate_fit(fastaFile,pars{:});


% [~,theoryStr] = get_theory_twostate_fit(fastaFile,parlistcell{:},yoyoBindingProb);
% 
% for i=1:length(sortedSubseq)
%     cellInd = num2cell(sortedSubseq{i});
%     yoyoBindingProb(sub2ind(size(yoyoBindingProb), cellInd{:} )) = probYoyo(1+countATs(i));
% end
% 
% [sortOp, sortid] =  sort(yoyoBindingProb,'descend');
% [ids ] = arrayfun(@(x) ind2sub([4 4 4 4],x),sortid);
% 
% % is this sorted correctly? number of ats
% figure,plot(countATs(orderSeq))
% xlabel('4mers sorted by binding constant')
% ylabel('AT content')

k = 1; % just single for testing
% % parlistcell
m = zeros(1,length(par));
st = zeros(1,length(par));
sS = zeros(1,length(par));
compI = cell(1,length(par));
rezI = cell(1,length(par));
theoryStr = cell(1,length(par));

parfor k=1:length(par)
%     k
    pars = [parlistcell(1:parchangeId-1) par(k) parlistcell(parchangeId+1:end)]; 

%     pars = [parlistcell(1:parchangeId-1) par(k) parlistcell(parchangeId+1:end)]; 
    [~,theoryStr{k}] = get_theory_twostate_fit(fastaFile,pars{:});

%     [~,theoryStr] = get_theory_twostate(fastaFile,pars{:});

    % todo: change to hca_compare_distance
    [compI{k},rezI{k},~] = compare_to_t(barGen,theoryStr{k},sF,sets);

    m(k) =cellfun(@(y) mean(cellfun(@(x) x.maxcoef(1),y)), rezI{k});
    st(k) = cellfun(@(y) std(cellfun(@(x) x.maxcoef(1),y)), rezI{k});

%     m(k)
    stoufferScoresSimple =cellfun(@(x) double(norminv(1-x.pval)),compI{k},'un',true);
    sS(k ) = mean(stoufferScoresSimple);%(stoufferScoresSimple>1.6))
end
% 
% end

