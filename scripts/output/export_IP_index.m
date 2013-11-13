function [] = export_IP_index(export_dir, VIndex, J, response, IP)

IPFileName = [export_dir 'IP.txt'];

R = response';

R = R(IP' > 0);

IPIndex = [J VIndex R];
save(IPFileName, 'IPIndex', '-ascii');

end % function

