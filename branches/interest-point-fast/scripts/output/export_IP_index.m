function [] = export_IP_index(export_dir, VIndex, J)

IPFileName = [export_dir 'IP.txt'];

IPIndex = [J VIndex];
save(IPFileName, 'IPIndex', '-ascii');

end % function

