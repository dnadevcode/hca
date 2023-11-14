function [] = hca_barcode_alignment(useGUI, hcaSets)
    %   Replicates HCA_Gui, nicer graphical user interface
    %   Written by Albertas Dvirnas

    % GUI globals
    duplicates = []; % to store duplicate settings between windows
    shrinksorter = []; % to store shrinksorter
    hcaaligner = [];
    hcatheory = [];

    % Other globals:
    versionHCA = [];
    iL = [];
    t1 =[]; t2 = []; t3 = []; t4 = [];
    tsAlignmentVisual =[];

    if nargin < 2
        import CBT.Hca.Import.import_hca_settings;
        [hcaSets] = import_hca_settings('hca_settings.txt');
    end
        
    if nargin >=1
        hcaSets.useGUI = useGUI;  
    end

    if hcaSets.useGUI
        % generate menu
        % https://se.mathworks.com/help/matlab/ref/uimenu.html
%         [hcaSets,tsHCC,textList,textListT,itemsList,...
%                 hHomeScreen,hPanelRawKymos,hPanelAlignedKymos,hPanelTimeAverages,hAdditional,tshAdd]= generate_gui();
        [hFig,hPanel,h] = generate_gui();     
    else

    end
 
    function [hFig,hPanel,h] = generate_gui()

            mFilePath = mfilename('fullpath');
            mfolders = split(mFilePath, {'\', '/'});
            versionHCA = importdata(fullfile(mfolders{1:end-1},'VERSION'));

            hFig = figure('Name', ['HCA Barcode Alignment v' versionHCA{1}], ...
                'Units', 'normalized', ...
                'OuterPosition', [0.05 0.1 0.8 0.8], ...
                'NumberTitle', 'off', ...     
                'MenuBar', 'none',...
                'ToolBar', 'none' ...
            );
            m = uimenu('Text','HCA');
            cells1 = {'HCA v4.7','Theory','Alignment'};
            mSub = cellfun(@(x) uimenu(m,'Text',x),cells1,'un',false);
            mSub{1}.MenuSelectedFcn = @SelectedOldHCA;

            cellsTheory = {'Generate theory'};

            mSubTheory  = cellfun(@(x) uimenu(mSub{2},'Text',x),cellsTheory,'un',false);

            mSubTheory{1}.MenuSelectedFcn = @SelectedHCAtheory;

            cellsAlignment = {'Run Alignment','Shrink sorter','Duplicates sorter'};
            mSubALignment  = cellfun(@(x) uimenu(mSub{3},'Text',x),cellsAlignment,'un',false);
            mSubALignment{1}.MenuSelectedFcn = @SelectedHCAAlignment;
            mSubALignment{2}.MenuSelectedFcn = @SelectedShrinkSorter;
            mSubALignment{3}.MenuSelectedFcn = @SelectedDuplicatesSorter;

            hPanel = uipanel('Parent', hFig);
            h = uitabgroup('Parent',hPanel);
    end

    function [structFiles] = get_files_function(tsSet,structFiles,run_handle)
        % get_files_function, create a basic UI element with inport,
        % settings, and run button
        % v5.2.0

        structSets = structFiles.sets;
        structNames = structFiles.names;

        fnames = fieldnames(structSets.default);
        tISets = ones(1,length(fnames));
        if isfield(structSets,'clIdx')
            tISets(structSets.clIdx) = 0;
        end

        if isfield(structSets,'testName')
            testName = structSets.testName;
        else
            testName = 'kymo_example.tif';
        end
    
        if isfield(structSets,'fileext')
            fileext = structSets.fileext;
        else
            fileext = '*.tif';
        end

        structFiles.dotImport = uicontrol('Parent', tsSet, 'Style', 'edit','String',{fullfile(fileparts(mfilename('fullpath')),'files',testName)},'Units', 'normal', 'Position', [0 0.9 0.5 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
        set(structFiles.dotImport, 'Min', 0, 'Max', 25);% limit to 10 files via gui;
        structFiles.dotButton = uicontrol('Parent', tsSet, 'Style', 'pushbutton','String',{'Browse folder'},'Callback',@(src, event) selection_folder(structFiles.dotImport,event,fileext),'Units', 'normal', 'Position', [0.6 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
        structFiles.dotButtonFile = uicontrol('Parent', tsSet, 'Style', 'pushbutton','String',{'Browse file'},'Callback',@(src, event) selection_file(structFiles.dotImport,event),'Units', 'normal', 'Position', [0.7 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
        structFiles.dotButtonUI = uicontrol('Parent', tsSet, 'Style', 'pushbutton','String',{'uigetfiles'},'Callback',@(src, event) selection_uipickfiles(structFiles.dotImport,event),'Units', 'normal', 'Position', [0.8 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
        structFiles.runButton = uicontrol('Parent', tsSet, 'Style', 'pushbutton','String',{'Run'},'Callback',run_handle,'Units', 'normal', 'Position', [0.7 0.2 0.2 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]

        checkListIdx = find(~tISets);
        itemListIdx = find(tISets);

        iL = cell(1,length(checkListIdx));
        for i = 1:length(checkListIdx)
            iL{i} = uicontrol('Parent', tsSet, 'Style', 'checkbox','Value', structSets.default.(fnames{checkListIdx(i)}),'String',structNames{checkListIdx(i)},'Units', 'normal', 'Position', [0.45 .83-0.05*i 0.3 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
        end
                
        positionsText = cell(1,length(itemListIdx));
        positionsBox = cell(1,length(itemListIdx));

        for i=1:length(itemListIdx) % these will be in two columns
            positionsText{i} =   [0.2-0.2*mod(i,2) .88-0.1*ceil(i/2) 0.2 0.03];
            positionsBox{i} =   [0.2-0.2*mod(i,2) .83-0.1*ceil(i/2) 0.15 0.05];
        end

        tL = cell(1,length(itemListIdx));

        for i=1:length(itemListIdx)
            tL{i} = uicontrol('Parent', tsSet, 'Style', 'text','String',structNames{itemListIdx(i)},'Units', 'normal', 'Position', positionsText{i},'HorizontalAlignment','Left');
            tL{i} = uicontrol('Parent', tsSet, 'Style', 'edit','String',{num2str(structSets.default.(fnames{itemListIdx(i)}))},'Units', 'normal', 'Position', positionsBox{i});
        end

        % save in duplicates
        structFiles.Item = iL;
        structFiles.Text = tL;
    end

    %% Selected functions
    function SelectedOldHCA(~,~)
            disp('Running HCA_Gui v. 4.7.0')
            delete(hFig);
            HCA_Gui;
    end

    function SelectedDuplicatesSorter(~,~) % duplicates sorter
        disp('Running Duplicates sorting')
        if hcaSets.useGUI
            if isempty(t4)
                t4 = uitab(h, 'title', 'Duplicates sorter');
            end
            h.SelectedTab = t4; 
        end
        tsDuplicates = uitabgroup('Parent',t4);
        tsDuplicatesSettings = uitab(tsDuplicates, 'title', 'Duplicate sorter settings');
        [duplicates.sets,duplicates.names] = Core.Default.read_default_sets('duplicatessets.txt');

        [duplicates] = get_files_function(tsDuplicatesSettings,duplicates, @run_duplicatessorter);
    end


    function SelectedShrinkSorter(~,~) % shrink sorter
        disp('Running shrink sorting')
        if hcaSets.useGUI
            if isempty(t3)
                t3 = uitab(h, 'title', 'Shrink sorter');
            end
            h.SelectedTab = t3; 
        end
        tsShrink = uitabgroup('Parent',t3);
        tsShrinkSettings = uitab(tsShrink, 'title', 'Shrink sorter settings');
        % get default settings
        [shrinksorter.sets,shrinksorter.names] = Core.Default.read_default_sets('shrinksortersets.txt');
        % use get_files_funcion
        [shrinksorter] = get_files_function(tsShrinkSettings, shrinksorter, @run_shrinksorter);
    end

    function SelectedHCAAlignment(~,~)
            disp('Running HCA_alignment')

            if hcaSets.useGUI
                if isempty(t1)
                    t1 = uitab(h, 'title', 'HCA alignment');
                end
                h.SelectedTab = t1; 

                tsAlignment = uitabgroup('Parent',t1);
                tsAlignmentSettings = uitab(tsAlignment, 'title', 'Alignment settings');
                tsAlignmentVisual = uitab(tsAlignment, 'title', 'Visual results');


                [hcaaligner.sets,hcaaligner.names] = Core.Default.read_default_sets('hcaalignmentsets.txt');
                [hcaaligner] = get_files_function(tsAlignmentSettings,hcaaligner, @run_alignment);
            end

    end

    function SelectedHCAtheory(~,~)
            disp('Running HCA_theory')

            if hcaSets.useGUI
                if isempty(t2)
                    t2 = uitab(h, 'title', 'HCA theory');
                end
                h.SelectedTab = t2; 

                tsTheory = uitabgroup('Parent',t2);
                tsTheorySettings = uitab(tsTheory, 'title', 'Theory settings');

                [hcatheory.sets,hcatheory.names] = Core.Default.read_default_sets('hcasets.txt');
                [hcatheory] = get_files_function(tsTheorySettings,hcatheory, @run_theory);
            end
    end

%% run functions
    function run_duplicatessorter(~,~)
            display(['Started shrink sorter hca_alignment v',versionHCA{1}]);

            duplicatesSets = save_settings_hca(duplicates.sets, duplicates.Item,duplicates.Text);

            duplicatesSets.kymofolder = duplicates.dotImport.String;

            import Core.duplicatessorter;
            duplicatessorter(duplicatesSets);

    end


    function run_shrinksorter(~,~)
            display(['Started shrink sorter hca_alignment v',versionHCA{1}]);

            sorterSets = save_settings_hca(shrinksorter.sets, shrinksorter.Item,shrinksorter.Text);

            sorterSets.kymofolder = shrinksorter.dotImport.String;

            import Core.shrink_finder_fun;
            shrink_finder_fun(sorterSets);

    end

    function run_alignment(~,~)
            
            display(['Started analysis hca_alignment v',versionHCA{1}])
            
            hcaSetsDefault.default = hcaSets;

            hcaSetsDefault = save_settings_hca(hcaaligner.sets, hcaaligner.Item,hcaaligner.Text,hcaSetsDefault);

                       % incorporate directly to list!
            if  hcaSetsDefault.default.comparisonMethod==1
                 hcaSetsDefault.default.comparisonMethod  = 'mass_pcc';
            else
                 hcaSetsDefault.default.comparisonMethod  = 'mpnan';
            end
            hcaSets = hcaSetsDefault.default;
            hcaSets.kymofolder = hcaaligner.dotImport.String;

            % run alignment            
            import Core.run_hca_alignment;
            [barcodeGenC,consensusStruct, comparisonStruct, theoryStruct, hcaSets] = run_hca_alignment(hcaSets);

            import Core.run_visual_fun;
            if ~isempty(comparisonStruct)
                run_visual_fun(barcodeGenC,consensusStruct, comparisonStruct, theoryStruct, hcaSets, tsAlignmentVisual);
            end           
    end

        function run_theory(~,~)
            
            display(['Started analysis hca_theory v',versionHCA{1}])

            hcatheorySets = save_settings_hca(hcatheory.sets, hcatheory.Item,hcatheory.Text);
            hcatheorySets = hcatheorySets.default;

            hcatheorySets.folder = hcatheory.dotImport.String;

            disp(['N = ',num2str(length(  hcatheorySets.folder )), ' sequences to run'])

            import Core.run_hca_theory;
            run_hca_theory(hcatheorySets);


        end

    % select tifs in folder
    function selection_folder(src, ~, fileext)
        [rawNames] = uigetdir(pwd,strcat('Select folder with file(s) to process'));
        rawFiles = [dir(fullfile(rawNames,fileext))];
        rawNames = arrayfun(@(x) fullfile(rawFiles(x).folder,rawFiles(x).name),1:length(rawFiles),'UniformOutput',false);
        set(src, 'String', rawNames);
    end   

    function selection_file(src, ~) % {'*.tif';'*.mat';}
        [FILENAME, PATHNAME] = uigetfile(fullfile(pwd,'*.*'),strcat(['Select file(s) to process']),'MultiSelect','on');
        name = fullfile(PATHNAME,FILENAME);
        if ~iscell(name)
            name  = {name};
        end
        set(src, 'String', name);
    end  

    function selection_uipickfiles(src, ~)
        [FILENAME] = uipickfiles;
        name = FILENAME';
        if ~iscell(name)
            name  = {name};
        end
        set(src, 'String', name);

    end

    % save settings for particular items/checklist, works for any settings
    function hcaSetsDefault = save_settings_hca(hcaSets,iL,tL,hcaSetsDefault)

        if nargin <4 
            hcaSetsDefault = struct();
        end

        fnames = fieldnames(hcaSets.default);
        tISets = ones(1,length(fnames));
        if isfield(hcaSets,'clIdx')
            tISets(hcaSets.clIdx) = 0;
        end
    
        checkListIdx = find(~tISets);
        itemListIdx = find(tISets);

        for i = 1:length(checkListIdx)
            hcaSetsDefault.default.(fnames{checkListIdx(i)}) = iL{i}.Value;
        end

        for i = 1:length(itemListIdx)
            if ~isnan(str2double(tL{i}.String))
                hcaSetsDefault.default.(fnames{itemListIdx(i)}) = str2double(tL{i}.String);
            else
                hcaSetsDefault.default.(fnames{itemListIdx(i)}) = tL{i}.String{1};
            end
        end   

    end
    
end