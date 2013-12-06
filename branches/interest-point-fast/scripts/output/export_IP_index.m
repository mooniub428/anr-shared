function [] = export_IP_index(export_dir, VIndex, J, response, IP, ST)

IPFileName = [export_dir 'IP.txt'];

R = zeros(numel(J), 1);
R = response';

R = R(IP' > 0);

IPIndex = [J VIndex ST R];
save(IPFileName, 'IPIndex', '-ascii');

end % function

