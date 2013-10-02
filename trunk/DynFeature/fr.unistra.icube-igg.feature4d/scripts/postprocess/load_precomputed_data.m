function [ ] = load_precomputed_data( param.data_name )

% String constants
dir_ = ['../../fr.unistra.icube-igg.debug/' param.data_name '/'];


if(param.do_scale_norm)
    dir_ = [dir_ '/norm/'];
else
    dir_ = [dir_ '/notnorm/'];
end % if

load([dir_ 'objseq.mat']);
load([dir_ 'D_.mat']);
load([dir_ 'feature_response.mat']);
load([dir_ 'featpts.mat']);


end

