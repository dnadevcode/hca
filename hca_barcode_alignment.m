function [] = hca_barcode_alignment(useGUI, hcaSets)
    %   Replicates HCA_Gui, nicer graphical user interface
    %   Written by Albertas Dvirnas

    import Core.hpfl_extract;

    dotImport = [];
    textList = [];
    itemsList = [];
    versionHCA = [];
    textListA = [];
    itemsListA = [];

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
        [hFig,hPanel] = generate_gui();     
    else


    end
 

    function [hFig,hPanel] = generate_gui()


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


            cellsAlignment = {'Run Alignment'}
            mSubALignment  = cellfun(@(x) uimenu(mSub{3},'Text',x),cellsAlignment,'un',false);
            mSubALignment{1}.MenuSelectedFcn = @SelectedHCAAlignment;


            hPanel = uipanel('Parent', hFig);
    
%             tsHCC = uitabgroup('Parent',t1);
%             hPanelImport = uitab(tsHCC, 'title', 'DBM settings');
%             
%             hHomeScreen= uitab(tsHCC, 'title',strcat('HomeScreen'));
%             hPanelRawKymos= uitab(tsHCC, 'title',strcat('unaligned Kymos'));
       


    end

    function SelectedOldHCA(~,~)
            disp('Running HCA_Gui v. 4.7.0')
            delete(hFig);
            HCA_Gui;
    end

    function SelectedHCAAlignment(~,~)
            disp('Running HCA_alignment')

            if hcaSets.useGUI
                h = uitabgroup('Parent',hPanel);
                t1 = uitab(h, 'title', 'HCA alignment');
                tsAlignment = uitabgroup('Parent',t1);
                tsAlignmentSettings = uitab(tsAlignment, 'title', 'Alignment settings');


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
%                 checkItems = [15:17];
%                 for i = 1:length(checkItems)
%                     itemsListA{i} = uicontrol('Parent', tsAlignmentSettings, 'Style', 'checkbox','Value', str2double(setsTable.Var1{checkItems(i)}),'String',{textItems{checkItems(i)}},'Units', 'normal', 'Position', [0.45 .83-0.05*i 0.3 0.05]);%, 'Max', Inf, 'Min', 0);  [left bottom width height]
%                 end

 
                for i=1:length(textItems) % these will be in two columns
                    positionsText{i} =   [0.2-0.2*mod(i,2) .88-0.1*ceil(i/2) 0.2 0.03];
                    positionsBox{i} =   [0.2-0.2*mod(i,2) .83-0.1*ceil(i/2) 0.15 0.05];
                end
                
                for i=1:length(textItems)
                    textListTA{i} = uicontrol('Parent', tsAlignmentSettings, 'Style', 'text','String',{textItems{i}},'Units', 'normal', 'Position', positionsText{i},'HorizontalAlignment','Left');%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                    textListA{i} = uicontrol('Parent', tsAlignmentSettings, 'Style', 'edit','String',{strip(values{i})},'Units', 'normal', 'Position', positionsBox{i});%, 'Max', Inf, 'Min', 0);  [left bottom width height]
                end


            end

    end

    function SelectedHCAtheory(~,~)
            disp('Running HCA_theory')

            if hcaSets.useGUI
                h = uitabgroup('Parent',hPanel);
                t1 = uitab(h, 'title', 'HCA theory');
                tsTheory = uitabgroup('Parent',t1);
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

    function run_alignment(src, event)
            
            display(['Started analysis hca_alignment v',versionHCA{1}])
            hcaSets.kymofolder = dotImport.String;
            save_settings_align();
            
            import Core.run_hca_alignment;
            run_hca_alignment(hcaSets)


        end

        function run_theory(src, event)
            
            display(['Started analysis hca_theory v',versionHCA{1}])
            hcaSets.folder = dotImport.String;
            save_settings();

            import Core.run_hca_theory;
            run_hca_theory(hcaSets)


        end


    function selection(src, event)
        [rawNames] = uigetdir(pwd,strcat(['Select folder with file(s) to process']));
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

    


    function save_settings() % all changeable settings here
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
        hcaSets.filterSettings.filter = str2double(textListA{3}.String);   
        hcaSets.genConsensus =  str2double(textListA{4}.String);
        hcaSets.bitmaskSettings  = str2double(textListA{5}.String);
        hcaSets.edgeSettings  = str2double(textListA{6}.String);
        hcaSets.skipEdgeDetection  = str2double(textListA{7}.String);
        hcaSets.random.generate  = str2double(textListA{8}.String);
        hcaSets.subfragment.generate  = str2double(textListA{9}.String{1});
   
        hcaSets.comparisonMethod  = textListA{10}.String{1};
        hcaSets.minLen  = str2double(textListA{11}.String{1});
        hcaSets.nmbp = str2double(textListA{12}.String{1});
        hcaSets.theory.stretchFactors = 1-str2double(textListA{13}.String{1})/100:str2double(textListA{14}.String{1})/100:1+str2double(textListA{13}.String{1})/100;
    end
    
end



% %         definput = {'0','1','0','0','0','0','0','0','0','mass_pcc','0'};
%         answer = inputdlg(prompt,title,dims,definput);
%         
%         sets.timeFramesNr = str2double(answer{1});
%         sets.alignMethod = str2double(answer{2});
%         sets.filterSettings.filter = str2double(answer{3});
%         sets.genConsensus = str2double(answer{4});
%         sets.bitmaskSettings = str2double(answer{5});
%         sets.edgeSettings = str2double(answer{6});
%         sets.skipEdgeDetection = str2double(answer{7}); % skips edge detection and assumes the first
%         % non-zero and last nonzero to be edges of molecule
%         sets.random.generate = str2double(answer{8});
%         sets.subfragment.generate = str2double(answer{9});
%         sets.comparisonMethod = answer{10};
%         sets.minLen = str2double(answer{11});