function [ ] = export_featpts_mat( featpts, param )

% String constants
export_dir = ['../../fr.unistra.icube-igg.debug/' param.data_name '/'];
% Create export directory if it does not exist
enforce_existence(export_dir);

if(param.do_scale_norm)
    export_dir = [export_dir '/norm/'];
else
    export_dir = [export_dir '/notnorm/'];
end % if

enforce_existence(export_dir);

save([export_dir 'featpts.mat'], 'featpts');

end % function

