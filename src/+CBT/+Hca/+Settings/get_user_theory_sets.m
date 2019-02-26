function [ sets ] = get_user_theory_sets( sets )
    
    if sets.promptfortheory    
        % loads figure window
        import Fancy.UI.Templates.create_figure_window;
        [hMenuParent, tsHCA] = create_figure_window('Theory fasta(s) import tool','HCA');

        import Fancy.UI.Templates.create_import_tab;
        cache = create_import_tab(hMenuParent,tsHCA,'theory fasta(s)');
        uiwait(gcf);  
        
        dd = cache('selectedItems');
        sets.theoryNames = dd(1:end/2);
        sets.theoryFold = dd((end/2+1):end);
    end
    

end

