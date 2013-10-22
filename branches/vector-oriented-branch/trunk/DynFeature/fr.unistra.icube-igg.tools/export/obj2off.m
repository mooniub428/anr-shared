%dbstop if error

% List all files (not sure if it works on Windows properly)
FileList = ls('*/*.obj');

% File list used space and tabulation as a delimeter
SpaceSplit = regexp(FileList, '\s');
TabSplit = regexp(FileList, '\t');

% Concatenate to have overall split
Split = sort(unique([SpaceSplit TabSplit]));

% Number of splitting poistion in vector Files
nSpl = length(Split);
% Number of characters in vector Files (including splitting spaces and
% tabs)
nChar = length(FileList);


% Now create a cell array containing all the listed files
u = 1;
count = 1;
Files = cell(count);
for iSpl = 1 : nSpl
    v = Split(iSpl) - 1;
    filename = FileList(u : v);
    if( length(filename) > 1 )
        %disp(filename);
        Files{count} = {filename};
        count = count + 1;
    end % if
    u = Split(iSpl) + 1;
end % for

% Iterate over the files and convert .obj to .off
nFiles = count - 1;
% Add mesh toolbox to matlab path
addpath('/Users/vm/Documents/Xdev/toolbox_graph');
for i = 1 : nFiles
    ObjFileName = cell2mat(Files{i});
    %[V, T, N] = read_obj(ObjFileName);
    [V, T] = read_obj(ObjFileName);
    OffFileName = strrep(ObjFileName, '.obj', '.off');
    disp([OffFileName ' ' int2str(nFiles - i) ' files remaining..']);
    write_off(OffFileName, V, T);
end % for
