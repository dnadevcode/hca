function [bindingConstantNames,bindingConstantVals] = import_binding_constant_rules(name)
    % import_binding_constant_rules
    
    % 
     % A => 1 , C => 2, G => 3,  T(U) => 4
    
    switch name
        case 'literature'
            % A => 1 , C => 2, G => 3,  T(U) => 4
            fid = fopen('binding_constant_rules.txt'); 
            value = textscan(fid,'%4c %f','delimiter','\n'); fclose(fid);     
            
            bindingConstantNames = value{1};
            
            bindingConstantVals = value{2};
            
        otherwise
            error('binding constant rules undefined');
    end

end

