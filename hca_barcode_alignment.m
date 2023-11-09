function [] = hca_barcode_alignment(useGUI, hcaSets)
    %   Replicates HCA_Gui, nicer graphical user interface
    %   Written by Albertas Dvirnas


    duplicates = [];% to store duplicate settings between windows

    dotImport = [];
    textList = [];
    itemsList = [];
    itemsListA = [];
    versionHCA = [];
    textListA = [];
    iL = [];
    t1 =[]; t2 = []; t3 = []; t4 = [];
    itemsListS =[];
    textListS = [];
    
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

%             tsHCC = uitabgroup('Parent',t1);
%             hPanelImport = uitab(tsHCC, 'title', 'DBM settings');
%             
%             hHomeScreen= uitab(tsHCC, 'title',strcat('HomeScreen'));
%             hPanelRawKymos= uitab(tsHCC, 'title',strcat('unaligned Kymos'));
       


    end



    function [structFiles] = get_files_function(tsSet,structFiles,run_handle)

        structSets = structFiles.sets;
        structFiles.dotImport = uicontrol('Parent', tsSet, 'Style', 'edit','String',{fullfile(fileparts(mfilename('fullpath')),'files','kymo_example.tif')},'Units', 'normal', 'Position', [0 0.9 0.5 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
        set(structFiles.dotImport, 'Min', 0, 'Max', 25);% limit to 10 files via gui;
        structFiles.dotButton = uicontrol('Parent', tsSet, 'Style', 'pushbutton','String',{'Browse folder'},'Callback',@(src, event) selection_folder(structFiles.dotImport,event),'Units', 'normal', 'Position', [0.6 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
        structFiles.dotButtonFile = uicontrol('Parent', tsSet, 'Style', 'pushbutton','String',{'Browse file'},'Callback',@(src, event) selection_file(structFiles.dotImport,event),'Units', 'normal', 'Position', [0.7 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
        structFiles.dotButtonUI = uicontrol('Parent', tsSet, 'Style', 'pushbutton','String',{'uigetfiles'},'Callback',@(src, event) selection_uipickfiles(structFiles.dotImport,event),'Units', 'normal', 'Position', [0.8 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
        structFiles.runButton = uicontrol('Parent', tsSet, 'Style', 'pushbutton','String',{'Run'},'Callback',run_handle,'Units', 'normal', 'Position', [0.7 0.2 0.2 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]

        fnames = fieldnames(structSets.default);
        tISets = ones(1,length(fnames));
        if isfield(structSets,'clIdx')
            tISets(structSets.clIdx) = 0;
        end
    
        checkListIdx = find(~tISets);
        itemListIdx = find(tISets);

        iL = cell(1,length(checkListIdx));
        for i = 1:length(checkListIdx)
            iL{i} = uicontrol('Parent', tsSet, 'Style', 'checkbox','Value', hcaSets.default.(fnames{checkListIdx(i)}),'String',fnames{checkListIdx(i)},'Units', 'normal', 'Position', [0.45 .83-0.05*i 0.3 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
        end
                
        positionsText = cell(1,length(itemListIdx));
        positionsBox = cell(1,length(itemListIdx));

        for i=1:length(itemListIdx) % these will be in two columns
            positionsText{i} =   [0.2-0.2*mod(i,2) .88-0.1*ceil(i/2) 0.2 0.03];
            positionsBox{i} =   [0.2-0.2*mod(i,2) .83-0.1*ceil(i/2) 0.15 0.05];
        end

        tL = cell(1,length(itemListIdx));

        for i=1:length(itemListIdx)
            tL{i} = uicontrol('Parent', tsSet, 'Style', 'text','String',fnames{itemListIdx(i)},'Units', 'normal', 'Position', positionsText{i},'HorizontalAlignment','Left');
            tL{i} = uicontrol('Parent', tsSet, 'Style', 'edit','String',{num2str(structSets.default.(fnames{itemListIdx(i)}))},'Units', 'normal', 'Position', positionsBox{i});
        end

        % save in duplicates
        structFiles.Item = iL;
        structFiles.Text = tL;


    end

    % to remove (in favor of get_files_function, which is more general)
    function [dotImport,iL,tL] = get_files_fun(tsSet,setstxt,clI,run_handle)
                dotImport = uicontrol('Parent', tsSet, 'Style', 'edit','String',{fullfile(fileparts(mfilename('fullpath')),'files','kymo_example.tif')},'Units', 'normal', 'Position', [0 0.9 0.5 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                set(dotImport, 'Min', 0, 'Max', 25);% limit to 10 files via gui;
                dotButton = uicontrol('Parent', tsSet, 'Style', 'pushbutton','String',{'Browse folder'},'Callback',@selection,'Units', 'normal', 'Position', [0.6 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                dotButtonFile = uicontrol('Parent', tsSet, 'Style', 'pushbutton','String',{'Browse file'},'Callback',@selection2,'Units', 'normal', 'Position', [0.7 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                dotButtonUI = uicontrol('Parent', tsSet, 'Style', 'pushbutton','String',{'uigetfiles'},'Callback',@selection3,'Units', 'normal', 'Position', [0.8 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                runButton = uicontrol('Parent', tsSet, 'Style', 'pushbutton','String',{'Run'},'Callback',run_handle,'Units', 'normal', 'Position', [0.7 0.2 0.2 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]

                mFilePath = mfilename('fullpath');
%                 mfolders = split(mFilePath, {'\', '/'});
                [fd, fe] = fileparts(mFilePath);
                % read settings txt
                setsTable  = readtable(fullfile(fd,'files',setstxt),'Format','%s%s%s');

                % Checklist as a loop
                tI = setsTable.Var2;
                val = setsTable.Var1;

                tISets = ones(1,length(tI));
                tISets(clI) = 0;

                checkListIdx = find(~tISets);
                itemListIdx = find(tISets);

                iL = cell(1,length(checkListIdx));
                for i = 1:length(checkListIdx)
                    iL{i} = uicontrol('Parent', tsSet, 'Style', 'checkbox','Value', str2double(val{checkListIdx(i)}),'String',tI(checkListIdx(i)),'Units', 'normal', 'Position', [0.45 .83-0.05*i 0.3 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                end
                
                positionsText = cell(1,length(itemListIdx));
                positionsBox = cell(1,length(itemListIdx));

                for i=1:length(itemListIdx) % these will be in two columns
                    positionsText{i} =   [0.2-0.2*mod(i,2) .88-0.1*ceil(i/2) 0.2 0.03];
                    positionsBox{i} =   [0.2-0.2*mod(i,2) .83-0.1*ceil(i/2) 0.15 0.05];
                end
                
                tL = cell(1,length(checkListIdx));

                for i=1:length(itemListIdx)
                    tL{i} = uicontrol('Parent', tsSet, 'Style', 'text','String',tI(itemListIdx(i)),'Units', 'normal', 'Position', positionsText{i},'HorizontalAlignment','Left');%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                    tL{i} = uicontrol('Parent', tsSet, 'Style', 'edit','String',{strip(val{itemListIdx(i)})},'Units', 'normal', 'Position', positionsBox{i});%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                end


    end

    function SelectedOldHCA(~,~)
            disp('Running HCA_Gui v. 4.7.0')
            delete(hFig);
            HCA_Gui;
    end


    function SelectedDuplicatesSorter(~,~)
        disp('Running Duplicates sorting')
        if hcaSets.useGUI
            if isempty(t4)
                t4 = uitab(h, 'title', 'Duplicates sorter');
            end
            h.SelectedTab = t4; 
        end
        tsDuplicates = uitabgroup('Parent',t4);
        tsDuplicatesSettings = uitab(tsDuplicates, 'title', 'Duplicate sorter settings');
        [duplicates.sets] = Core.Default.read_default_sets('duplicatessets.txt');

        [duplicates] = get_files_function(tsDuplicatesSettings,duplicates, @run_duplicatessorter);


    end


    function SelectedShrinkSorter(~,~)
        disp('Running shrink sorting')
        if hcaSets.useGUI
            if isempty(t3)
                t3 = uitab(h, 'title', 'Shrink sorter');
            end
            h.SelectedTab = t3; 
        end
        tsShrink = uitabgroup('Parent',t3);
        tsShrinkSettings = uitab(tsShrink, 'title', 'Shrink sorter settings');
        [dotImport, itemsListS,textListS] = get_files_fun(tsShrinkSettings,'shrinksortersets.txt',[], @run_shrinksorter);


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

                dotImport = uicontrol('Parent', tsAlignmentSettings, 'Style', 'edit','String',{fullfile(fileparts(mfilename('fullpath')),'files','kymo_example.tif')},'Units', 'normal', 'Position', [0 0.9 0.5 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                set(dotImport, 'Min', 0, 'Max', 25)% limit to 10 files via gui;
                
                dotButton = uicontrol('Parent', tsAlignmentSettings, 'Style', 'pushbutton','String',{'Browse folder'},'Callback',@selection,'Units', 'normal', 'Position', [0.6 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                dotButtonFile = uicontrol('Parent', tsAlignmentSettings, 'Style', 'pushbutton','String',{'Browse file'},'Callback',@selection2,'Units', 'normal', 'Position', [0.7 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                dotButtonUI = uicontrol('Parent', tsAlignmentSettings, 'Style', 'pushbutton','String',{'uigetfiles'},'Callback',@selection3,'Units', 'normal', 'Position', [0.8 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                runButton = uicontrol('Parent', tsAlignmentSettings, 'Style', 'pushbutton','String',{'Run'},'Callback',@run_alignment,'Units', 'normal', 'Position', [0.7 0.2 0.2 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                
%                 clearButton = uicontrol('Parent', tsTheorySettings, 'Style', 'pushbutton','String',{'Clear visual results'},'Callback',@clear_results,'Units', 'normal', 'Position', [0.7 0.1 0.2 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]

                mFilePath = mfilename('fullpath');
%                 mfolders = split(mFilePath, {'\', '/'});
                [fd, fe] = fileparts(mFilePath);
                % read settings txt
                setsTable  = readtable(fullfile(fd,'files','hcaalignmentsets.txt'),'Format','%s%s%s');

                % Checklist as a loop
                textItems = setsTable.Var2;
                values = setsTable.Var1;

                textItemSets = ones(1,length(textItems));
                textItemSets([3:10 15:16]) = 0;

                checkListIdx = find(~textItemSets);
                itemListIdx = find(textItemSets);

                for i = 1:length(checkListIdx)
                    itemsListA{i} = uicontrol('Parent', tsAlignmentSettings, 'Style', 'checkbox','Value', str2double(values{checkListIdx(i)}),'String',textItems(checkListIdx(i)),'Units', 'normal', 'Position', [0.45 .83-0.05*i 0.3 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                end
                
                set(itemsListA{3}, 'Enable', 'off'); % to be re-implemented
                set(itemsListA{4}, 'Enable', 'off'); % to be re-implemented

 
                for i=1:length(itemListIdx) % these will be in two columns
                    positionsText{i} =   [0.2-0.2*mod(i,2) .88-0.1*ceil(i/2) 0.2 0.03];
                    positionsBox{i} =   [0.2-0.2*mod(i,2) .83-0.1*ceil(i/2) 0.15 0.05];
                end
                
                for i=1:length(itemListIdx)
                    textListTA{i} = uicontrol('Parent', tsAlignmentSettings, 'Style', 'text','String',textItems(itemListIdx(i)),'Units', 'normal', 'Position', positionsText{i},'HorizontalAlignment','Left');%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                    textListA{i} = uicontrol('Parent', tsAlignmentSettings, 'Style', 'edit','String',{strip(values{itemListIdx(i)})},'Units', 'normal', 'Position', positionsBox{i});%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                end


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


                dotImport = uicontrol('Parent', tsTheorySettings, 'Style', 'edit','String',{fullfile(fileparts(mfilename('fullpath')),'files','sequence.fasta')},'Units', 'normal', 'Position', [0 0.9 0.5 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                set(dotImport, 'Min', 0, 'Max', 25)% limit to 10 files via gui;
                
                dotButton = uicontrol('Parent', tsTheorySettings, 'Style', 'pushbutton','String',{'Browse folder'},'Callback',@selection,'Units', 'normal', 'Position', [0.6 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                dotButtonFile = uicontrol('Parent', tsTheorySettings, 'Style', 'pushbutton','String',{'Browse file'},'Callback',@selection2,'Units', 'normal', 'Position', [0.7 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                dotButtonUI = uicontrol('Parent', tsTheorySettings, 'Style', 'pushbutton','String',{'uigetfiles'},'Callback',@selection3,'Units', 'normal', 'Position', [0.8 0.9 0.1 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                runButton = uicontrol('Parent', tsTheorySettings, 'Style', 'pushbutton','String',{'Run'},'Callback',@run_theory,'Units', 'normal', 'Position', [0.7 0.2 0.2 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                
%                 clearButton = uicontrol('Parent', tsTheorySettings, 'Style', 'pushbutton','String',{'Clear visual results'},'Callback',@clear_results,'Units', 'normal', 'Position', [0.7 0.1 0.2 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]

                mFilePath = mfilename('fullpath');
%                 mfolders = split(mFilePath, {'\', '/'});
                [fd, fe] = fileparts(mFilePath);
                % read settings txt
                setsTable  = readtable(fullfile(fd,'files','hcasets.txt'),'Format','%s%s%s');

                % Checklist as a loop
                textItems = setsTable.Var2;
                values = setsTable.Var1;
                checkItems = [15:17];
                for i = 1:length(checkItems)
                    itemsList{i} = uicontrol('Parent', tsTheorySettings, 'Style', 'checkbox','Value', str2double(setsTable.Var1{checkItems(i)}),'String',{textItems{checkItems(i)}},'Units', 'normal', 'Position', [0.45 .83-0.05*i 0.3 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                end


 
                for i=1:length(textItems)-2 % these will be in two columns
                    positionsText{i} =   [0.2-0.2*mod(i,2) .88-0.1*ceil(i/2) 0.2 0.03];
                    positionsBox{i} =   [0.2-0.2*mod(i,2) .83-0.1*ceil(i/2) 0.15 0.05];
                end
                
                for i=1:length(textItems)-2
                    textListT{i} = uicontrol('Parent', tsTheorySettings, 'Style', 'text','String',{textItems{i}},'Units', 'normal', 'Position', positionsText{i},'HorizontalAlignment','Left');%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                    textList{i} = uicontrol('Parent', tsTheorySettings, 'Style', 'edit','String',{strip(values{i})},'Units', 'normal', 'Position', positionsBox{i});%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                end

            end

%             delete(hFig);
%             HCA_theory;
    end


    function run_duplicatessorter(src,event)
            display(['Started shrink sorter hca_alignment v',versionHCA{1}]);

            duplicatesSets = save_settings_hca(duplicates.sets, duplicates.Item,duplicates.Text);

            duplicatesSets.kymofolder = duplicates.dotImport.String;

            import Core.duplicatessorter;
            duplicatessorter(duplicatesSets);

    end


    function run_shrinksorter(src,event)
            display(['Started shrink sorter hca_alignment v',versionHCA{1}]);
            hcaSets.kymofolder = dotImport.String;
            save_settings_shrink();

            import Core.shrink_finder_fun;
            shrink_finder_fun(hcaSets);

    end

    function run_alignment(src, event)
            
            display(['Started analysis hca_alignment v',versionHCA{1}])
            hcaSets.kymofolder = dotImport.String;
            save_settings_align();
            
            import Core.run_hca_alignment;
            [barcodeGenC,consensusStruct, comparisonStruct, theoryStruct, hcaSets] = run_hca_alignment(hcaSets);

            import Core.run_visual_fun;
            if ~isempty(comparisonStruct)
                run_visual_fun(barcodeGenC,consensusStruct, comparisonStruct, theoryStruct, hcaSets, tsAlignmentVisual);
            end
            

    end

        function run_theory(src, event)
            
            display(['Started analysis hca_theory v',versionHCA{1}])
            hcaSets.folder = dotImport.String;
            save_settings();

            import Core.run_hca_theory;
            run_hca_theory(hcaSets)


        end

    function selection_folder(src, event)
        [rawNames] = uigetdir(pwd,strcat('Select folder with file(s) to process'));
        set(src, 'String', rawNames);
    end   

    function selection_file(src, event)
        [FILENAME, PATHNAME] = uigetfile(fullfile(pwd,'*.*'),strcat(['Select file(s) to process']),'MultiSelect','on');
        name = fullfile(PATHNAME,FILENAME);
        if ~iscell(name)
            name  = {name};
        end
        set(src, 'String', name);
    end  

    function selection_uipickfiles(src, event)
        [FILENAME] = uipickfiles;
        name = FILENAME';
        if ~iscell(name)
            name  = {name};
        end
        set(src, 'String', name);

    end



% toremove
    function selection(src, event)
        [rawNames] = uigetdir(pwd,strcat(['Select folder with file(s) to process']));
        set(btn, 'String', strcat(rawNames,filesep));
        dotImport.String = strcat(rawNames,filesep);
        processFolders = 1;

    end    

    function selection2(src, event)
        [FILENAME, PATHNAME] = uigetfile(fullfile(pwd,'*.*'),strcat(['Select file(s) to process']),'MultiSelect','on');
        dotImport.String = fullfile(PATHNAME,FILENAME);
        if ~iscell(dotImport.String)
            dotImport.String  = {dotImport.String};
        end
        processFolders = 0;

    end    

    function selection3(src, event)
        [FILENAME] = uipickfiles;
        dotImport.String = FILENAME';
        if ~iscell(dotImport.String)
            dotImport.String  = {dotImport.String};
        end
        processFolders = 0;

    end

    


    function  save_settings() % all changeable settings here
        % save settings from menu.    
        hcaSets.theoryGen.meanBpExt_nm = str2double(textList{1}.String);
        hcaSets.theoryGen.concN =  str2double(textList{2}.String);  
        hcaSets.theoryGen.concY = str2double(textList{3}.String);   
        hcaSets.theoryGen.concDNA =  str2double(textList{4}.String);
        hcaSets.theoryGen.psfSigmaWidth_nm  = str2double(textList{5}.String);
        hcaSets.theoryGen.pixelWidth_nm  = str2double(textList{6}.String);
        hcaSets.deltaCut  = str2double(textList{7}.String);
        hcaSets.widthSigmasFromMean  = str2double(textList{8}.String);
        hcaSets.theoryGen.method  = textList{9}.String{1};
        hcaSets.theoryGen.k  = max(2.^15,2.^(str2double(textList{10}.String)));
        hcaSets.theoryGen.m  = min(2.^15,2.^(str2double(textList{11}.String)));

        hcaSets.pattern  = textList{12}.String{1};
        hcaSets.lambda.fold  = textList{13}.String{1};
        hcaSets.lambda.name  = textList{14}.String{1};

        hcaSets.theoryGen.computeFreeConcentrations  = itemsList{1}.Value;
        hcaSets.theoryGen.isLinearTF  = itemsList{2}.Value;
        hcaSets.theoryGen.computeBitmask = itemsList{3}.Value;
    end


    function save_settings_align() % all changeable settings here
        % save settings from menu.    
        hcaSets.timeFramesNr = str2double(textListA{1}.String);
        hcaSets.alignMethod=  str2double(textListA{2}.String);  
        hcaSets.filterSettings.filter = itemsListA{1}.Value;   
        hcaSets.genConsensus =  itemsListA{2}.Value;
        hcaSets.bitmaskSettings  = itemsListA{3}.Value;
        hcaSets.edgeSettings  = itemsListA{4}.Value;
        hcaSets.skipEdgeDetection  = itemsListA{5}.Value;
        hcaSets.random.generate  = itemsListA{6}.Value;
        hcaSets.subfragment.generate  =itemsListA{7}.Value;
        hcaSets.identifyDisc  =itemsListA{9}.Value;
        hcaSets.saveOutput  =itemsListA{10}.Value;

        if itemsListA{8}.Value==1
            hcaSets.comparisonMethod  = 'mass_pcc';
        else
            hcaSets.comparisonMethod  = 'mpnan';
        end

%         hcaSets.shrinkFinder = itemsListA{9}.Value;

        hcaSets.minLen  = str2double(textListA{3}.String{1});
        hcaSets.w = hcaSets.minLen;
        hcaSets.nmbp = str2double(textListA{4}.String{1});
        hcaSets.theory.stretchFactors = 1-str2double(textListA{5}.String{1})/100:str2double(textListA{6}.String{1})/100:1+str2double(textListA{5}.String{1})/100;
    end

    function save_settings_shrink()
        hcaSets.shrink_threshold = str2double(textListS{1}.String);
%         hcaSets.consecutive_bgthreshold = str2double(textListS{2}.String);
%         hcaSets.consecutive_edge_threshold = str2double(textListS{3}.String);
        hcaSets.restrict = str2double(textListS{2}.String);
        hcaSets.gd = str2double(textListS{3}.String);
        hcaSets.around_feat = str2double(textListS{4}.String);
        hcaSets.p_feat = str2double(textListS{5}.String);

    end

    % save settings for particular items/checklist, works for any settings
    function hcaSets = save_settings_hca(hcaSets,iL,tL)
        fnames = fieldnames(hcaSets.default);
        tISets = ones(1,length(fnames));
        if isfield(hcaSets,'clIdx')
            tISets(hcaSets.clIdx) = 0;
        end
    
        checkListIdx = find(~tISets);
        itemListIdx = find(tISets);

        for i = 1:length(checkListIdx)
            hcaSets.default.(fnames{checkListIdx(i)}) = iL{i}.Value;
        end

        for i = 1:length(itemListIdx)
            if ~isnan(str2double(tL{i}.String))
                hcaSets.default.(fnames{itemListIdx(i)}) = str2double(tL{i}.String);
            else
                hcaSets.default.(fnames{itemListIdx(i)}) = tL{i}.String{1};
            end
        end   

    end
    
end