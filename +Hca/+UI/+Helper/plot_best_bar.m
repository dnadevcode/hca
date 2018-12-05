function [] = plot_best_bar(fig1, barcodeGen, consensusStruct, comparisonStruct,theoryStruct, maxcoef )
    % plot_best_bar
    
    % plots best barcode vs theory in case barcode is always larger than
    % theory

    len1=length(barcodeGen);
    % barcode orientations
    orientation = cell2mat(cellfun(@(x) x.or,comparisonStruct,'UniformOutput',0)');
    pos = cell2mat(cellfun(@(x) x.pos,comparisonStruct,'UniformOutput',0)');

    % number and value of the best barcode
    [dd,ii] =max(maxcoef(:,1));
    
    % load theory file
    fileID = fopen(theoryStruct{comparisonStruct{ii}.idx}.filename,'r');
    formatSpec = '%f';
    theorBar = fscanf(fileID,formatSpec);
    fclose(fileID);
    
    % theory length
    thrLen = theoryStruct{comparisonStruct{ii}.idx}.length;
    
    % bitmask. In case of linear barcode, would like to modify this
    theorBit = ones(1,thrLen);
    
    % load either theory barcode or the consensus barcode
    try
        expBar = barcodeGen{ii}.rawBarcode;
        expBit = barcodeGen{ii}.rawBitmask;
    catch
        expBar = consensusStruct.rawBarcode;
        expBit = consensusStruct.rawBitmask;  
    end
    expLen = length(expBar);

    % interpolate to the length which gave best CC value
    expBar = interp1(expBar, linspace(1,expLen,expLen*comparisonStruct{ii}.bestBarStretch));
    expBit = expBit(round(linspace(1,expLen,expLen*comparisonStruct{ii}.bestBarStretch)));
    expBar(~expBit)= nan;
    
    % flip barcode if it gabe best match when flipped                  
    if orientation(ii,1) == 2
        expBar = fliplr(expBar);
        expBit = fliplr(expBit);
    end
    % fit positions
    fitPositions = pos(ii,1):pos(ii,1)+length(expBar)-1;
    
    if min(fitPositions) > 0 && max(fitPositions) < thrLen
        % position on the theory barcode
        barFit = theorBar(fitPositions);
        barBit = theorBit(fitPositions);

        % mean and std of theory where bitmask of experiment is nonzero.
        % if there were some zero's in the theory, then this would not be
        % correct?
        m1 = mean(barFit(logical(expBit)));
        s1= std(barFit(logical(expBit)));

        % mean and std of experiment
        m2 = mean(expBar(logical(expBit)));
        s2= std(expBar(logical(expBit)));

        plot(fitPositions, ((expBar-m2)/s2) *s1+m1)
        hold on
        plot(fitPositions, barFit)
        xlim([min(fitPositions) max(fitPositions)])

        xlabel('Position (px)','Interpreter','latex')
        ylabel('Rescaled to theoretical intesity','Interpreter','latex')
        if ii <= len1
            name = num2str(ii);
        else
            name = 'consensus';
        end

        title(strcat(['Experimental barcode vs theory ']),'Interpreter','latex');
        legend({strcat(['$\hat C_{\rm ' name '}=$' num2str(dd,'%0.2f')]), strrep(strrep(theoryStruct{comparisonStruct{ii}.idx}.filename,'_',' '),'.txt','')},'Interpreter','latex')
    else
        warning('Experiment vs. theory not printed');
    end
end

