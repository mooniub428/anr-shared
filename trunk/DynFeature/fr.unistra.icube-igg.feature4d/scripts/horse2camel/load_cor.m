function [ ct2ht ] = load_cor(filename, ct2ht)

% number of target triangles
n_t = size(ct2ht, 1);

% open file
fid = fopen(filename);

% Read file contents into a column vector t_map
[t_map, count] = fscanf(fid, '%d');

% Indexing starts from 0 in the input, therefore add 1 in order to get
% matlab compliant
t_map = t_map;

cur_tri = 0;
for i = 1 : count 
    next_map = t_map(i);    
    if(next_map == cur_tri)        
        cur_tri = cur_tri + 1;
    else
        ct2ht(cur_tri) = { [cell2mat(ct2ht(cur_tri)) (next_map + 1)]};
    end % if
end % for

fclose(fid); % close the resource

end % function

