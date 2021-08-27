function [fig1] = plot_best_pos( fig1,comparisonStruct, numBar, sets, markers,lengthBorders)
    % plot_best_pos - pltos three maximum coefficients
  
    cumLengths = [0 lengthBorders]';
    
    posShift = cumLengths(cellfun(@(x) x.idx,comparisonStruct)');
    
    pos = cell2mat(cellfun(@(x) x.pos(1:min(end,3)),comparisonStruct,'UniformOutput',0)');

    p3 = plot(pos+posShift,1:size(pos,1),'ob');
    p3(1).Marker = markers(1);
    try
        p3(2).Marker = markers(2);
    end
    try
        p3(3).Marker = markers(3);
    end
    hold on
    

%     p4.Marker = markers(1);
%         p4 = plot(pos+posShift,1:size(pos,1),'ob');

  
    if  sets.genConsensus == 1
        plot(0:100:sum(lengthBorders), 0.5+repmat(numBar,length(0:100:sum(lengthBorders)),1))
    end
    
    plot(lengthBorders,zeros(1,length(lengthBorders)),'redx')
    
    % add lines for barcode lengths
    posEnd = cell2mat(cellfun(@(x) x.pos(1)+x.lengthMatch,comparisonStruct,'UniformOutput',0)');
    for i=1:size(pos,1)
        plot([pos(i,1) posEnd(i)]+posShift(i),[i i],'ob-');
    end
    
    xlabel('Best position (px)','Interpreter','latex')  
    ylabel('Barcode nr.','Interpreter','latex')
    if size(pos,2) == 1
        legend({'$\hat C$','Theoretical barcodes seperator'},'Location','southoutside','Interpreter','latex')
    else
        legend({'$\hat C$','$C_2$','$C_3$','Theoretical barcodes seperator'},'Location','southoutside','Interpreter','latex')
    end
    
    ylim([0,size(pos,1)+2])
    
end



