function [Gd] = compute_geod(data_folder, data_name, file_name, name)

command = ['"' data_folder '../Geodesic.exe" ' file_name];  
system(command);
Gd = load([file_name '.geodesic.txt']);

cur_dir = pwd;
cd([data_folder 'obj']);
delete([name '.geodesic.txt']);
cd(cur_dir);

end % function

