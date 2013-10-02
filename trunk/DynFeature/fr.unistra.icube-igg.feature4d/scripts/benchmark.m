% Data sets
datasets{1} = 'cylinder';
datasets{2} = 'cylinder-with-stop-large';
datasets{3} = 'horse';
datasets{4} = 'camel';

n = numel(datasets);

% 1
% Compute featpts with param.do_scale_norm == true
for i = 1 : n
    try
        main_f(cell2mat(datasets(i)), true);
    catch err
        err % just print the error to console
    end    
end % for

% 2
% Compute featpts with param.do_scale_norm == false
for i = 1 : n
    try
        main_f(cell2mat(datasets(i)), false);
    catch err
        err % just print the error to console
    end    
end % for