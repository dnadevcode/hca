function [theory] = AG_TC_mirror(ts,sets)
    % run literature theory

    ts(ts==1)=5;   % A to placeholder
    ts(ts==4)=6;   % T to placeholder 
    ts(ts==2)=4;   % C to T (because, pyrimidines)
    ts(ts==3)=1;   % G to A (because, purines)
    ts(ts==5)=3;   % A_placeholder to G
    ts(ts==6)=2;   % T_placeholder to C

    import CBT.Hca.Core.Theory.cb_theory;



    % free concentrations of yoyo and netropsin
    cN = sets.theoryGen.concN;
    cY = sets.theoryGen.concY;
    yoyoBindingConstant = sets.model.yoyoBindingConstant;
    values = sets.model.netropsinBindingConstant;



    theory = cb_theory(ts, cN,  cY, yoyoBindingConstant, values, 0);

end

