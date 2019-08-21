% This function computes theory barcode for a sequence
% load default settings

import CBT.Hca.Settings.sets_theory_sets;
sets = sets_theory_sets();

sets.promptfortheory = 1;
sets.skipBarcodeGenSettings = 0;


% load default settings
import CBT.Hca.Settings.get_user_theory_sets;
sets = get_user_theory_sets(sets);

if ~sets.skipBarcodeGenSettings
    import CBT.Hca.Settings.get_theory_sets;
    sets.theoryGen = get_theory_sets(); %
end

% compute free concentrations
import CBT.Hca.Core.Theory.compute_free_conc;
sets = compute_free_conc(sets);

theoryGen = struct();

% loop over movie file folder
for idx = 1:length(sets.theoryNames)
    addpath(genpath(sets.theoryFold{idx}))
    theoryData = fastaread(sets.theoryNames{idx});
    seq = theoryData(1).Sequence;
    name = theoryData(1).Header;

    disp(strcat(['loaded theory sequence ' name] ));

    import CBT.Hca.Core.Theory.compute_hca_theory_barcode;
    [theorySeq,bitmask] = compute_hca_theory_barcode(seq,sets);
    theoryGen.theoryBarcodes{idx} = theorySeq;
    theoryGen.theoryNames{idx} = name;
    theoryGen.theoryIdx{idx} = idx;
    theoryGen.bpNm{idx} = sets.theoryGen.meanBpExt_nm/sets.theoryGen.psfSigmaWidth_nm;
end

theoryGen.sets = sets.theoryGen;

hcaSessionStruct = struct();

hcaSessionStruct.theoryGen = theoryGen;



cache = containers.Map();
cache('sets') = sets;

cache('hcaSessionStruct') = hcaSessionStruct;


    % loads figure window
hFig = figure(...
    'Name', 'CB HCA tool', ...
    'Units', 'normalized', ...
    'OuterPosition', [0 0 1 1], ...
    'NumberTitle', 'off', ...
    'MenuBar', 'none' ...
);
hMenuParent = hFig;
hPanel = uipanel('Parent', hFig);
import Fancy.UI.FancyTabs.TabbedScreen;
ts = TabbedScreen(hPanel);
import CBT.Hca.UI.launch_export_ui;
cache = launch_export_ui(ts, cache);


