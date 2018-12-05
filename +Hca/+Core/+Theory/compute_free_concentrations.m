function [ sets ] = compute_free_concentrations( sets )
    % compute_free_concentrations
    % Computing free concentrations
    %     Args:
    %         sets (struct): Input settings
    % 
    %     Returns:
    %         sets: Output settings
    %

    if sets.computeFreeConcentrations
        tic
        disp('Computing free concentrations');
        seq = fastaread('sequence.fasta'); % ref sequence - lambda;
        rs = seq.Sequence;
        % put this in a function
        import CBT.BC.Core.choose_model;
        model = choose_model(sets.model);
        probsBinding1 = @(x) CA.CombAuc.Core.Cbt.cb_transfer_matrix_literature(rs, x(2),x(1),model.yoyo1BindingConstant,model.netropsinBindingConstant, 1000);
        probsBinding2 = @(x) CA.CombAuc.Core.Cbt.cb_transfer_matrix_literature_netropsin(rs, x(2),x(1),model.yoyo1BindingConstant,model.netropsinBindingConstant, 1000);

        x0 = [sets.concYOYO1_molar sets.concNetropsin_molar];

        fun = @(x) x0-x-[mean(probsBinding1(x)) mean(probsBinding2(x))]*sets.concDNA*0.25;

        % we minimise the sum square
        fun2 = @(x) sum(fun(x).^2);

        % using fminsearch
        [xNew] = fminsearch(fun2,x0);

        sets.concYOYO1_molar = xNew(1);
        sets.concNetropsin_molar = xNew(2);
        toc
        disp('Finished computing free concentrations');

    end


end

