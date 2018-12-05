function [  ] = plot_comparison_exp_vs_exp(selectedIndices,comparisonStruct,theoryStruct,barcodeGen  )
    % plot_comparison_exp_vs_exp plot one barcode vs the other
    % we don't compare them anew, but just plot them on the same plot based
    % on their positions on the theory barcode. 

 import CBT.Hca.UI.Helper.load_theory_and_stretch_ex;

 if length(selectedIndices) == 2

     for ii=selectedIndices(2:end)       
         nr1 = selectedIndices(1);
         nr2 = selectedIndices(2);
         
         % load both barcode and corresponding best theory
        [ barT,~, bar1, bit1] = load_theory_and_stretch_ex(nr1, theoryStruct, comparisonStruct,barcodeGen );
        [ barT2,~, bar2, bit2] = load_theory_and_stretch_ex(nr2, theoryStruct, comparisonStruct,barcodeGen );

        % assign nan's where bitmask is 0
        bar1(~bit1) = nan;
        bar2(~bit2) = nan;
%         % barcodes
%         bar1 = hcaSessionStruct.comparisonStructure{nr1}.bestStretchedBar;
%         bar2 = hcaSessionStruct.comparisonStructure{nr2}.bestStretchedBar;
% 
%         % bitmasks
%         bit1 = hcaSessionStruct.comparisonStructure{nr1}.bestStretchedBitmask;
%         bit2 = hcaSessionStruct.comparisonStructure{nr2}.bestStretchedBitmask;

        % start positions
        pos1 =  comparisonStruct{nr1}.pos(1);
        pos2 =  comparisonStruct{nr2}.pos(1);

        % in case start positions negative (barcode overloops)
        if pos1 < 0
            pos1 = pos1 + length(barT);
        end
        
        if pos2 < 0
            pos2 = pos2 + length(barT);
        end
        
        % max coefficients
        max1 = comparisonStruct{nr1}.maxcoef(1);
        max2 = comparisonStruct{nr2}.maxcoef(1);

        % orientations
        or1 = comparisonStruct{nr1}.or(1);
        or2 = comparisonStruct{nr2}.or(1);
        
        %flip barcodes in case not the same orientation
        if or1 == 2
            bar1 = fliplr(bar1);
        end
        if or2 == 2
            bar2 = fliplr(bar2);
        end

        % plot barcode, here we zscore
        figure,
        plot(pos1:pos1+length(bar1)-1,(bar1-nanmean(bar1))./nanstd(bar1))
        hold on
        plot(pos2:pos2+length(bar2)-1,(bar2-nanmean(bar2))./nanstd(bar2))
        
        % now plot bar2
        leftX = min(pos1,pos2);
        rightX = max(pos1+length(bar1)-1,pos2+length(bar2)-1);
        barT = [barT barT];
        plot(leftX:min(length(barT),rightX), zscore(barT(leftX:min(length(barT),rightX))),'black')
        xlim([leftX rightX ])
        legend({'Barcode 1','Barcode 2', 'Theory'})
% 
%         posOnFirst = (max(pos1,pos2):min(pos1+length(bar1)-1,pos2+length(bar2)-1))-pos1+1;
%         posOnSecond = (max(pos1,pos2):min(pos1+length(bar1)-1,pos2+length(bar2)-1))-pos2+1;
% 
%         barEx1= bar1(posOnFirst);
%         barEx2= bar2(posOnSecond);


     end

 end
        

end

