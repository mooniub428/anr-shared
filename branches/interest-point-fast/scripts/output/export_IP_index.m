function [] = export_IP_index(export_dir, VIndex, J, response, IP, ST, vid_start)

IPFileName = [export_dir 'IP.txt'];

R = zeros(numel(J), 1);
R = response';

R = R(IP' > 0);

%SHW: If vid_from_zero==1, then add -1 from VIndex.
if(vid_start == 0)
    VIndex = VIndex - 1;

IPIndex = [J VIndex ST R];
save(IPFileName, 'IPIndex', '-ascii');

end % function

