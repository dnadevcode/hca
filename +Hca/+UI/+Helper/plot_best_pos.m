function [fig1] = plot_best_pos( fig1,comparisonStruct, numBar, sets, markers,lengthBorders)
    % plot_best_pos - pltos three maximum coefficients
  
    cumLengths = [0 cumsum(lengthBorders)]';
    
    posShift = cumLengths(cellfun(@(x) x.idx,comparisonStruct)');
    
    pos = cell2mat(cellfun(@(x) x.pos,comparisonStruct,'UniformOutput',0)');

    p3 = plot(pos+posShift,1:size(pos,1),'ob');
    p3(1).Marker = markers(1);
    p3(2).Marker = markers(2);
    p3(3).Marker = markers(3);
    hold on
  
    if  sets.genConsensus == 1
        plot(0:100:sum(lengthBorders), 0.5+repmat(numBar,length(0:100:sum(lengthBorders)),1))
    end
    
    plot(lengthBorders,zeros(1,length(lengthBorders)),'x')
    
    xlabel('Best position (px)','Interpreter','latex')  
    ylabel('Barcode nr.','Interpreter','latex')
    legend({'$\hat C$','$C_2$','$C_3$','Consensus line'},'Location','ne','Interpreter','latex')
    ylim([0,numBar+2])
    
end



