function [ featpts_filtered ] = postprocess_featpts( featpts, eps, objseq, D_, feature_response )

% number of feature pts
n = numel(featpts);

% Init a set of filtered feature points
featpts_filtered = [];

% Iterate over features and filter out those with a feature respose less
% then pre-defined threshold "eps"
for i = 1 : n
    feat = featpts{i};
    f_response = feat(3);
    if(f_response > eps)
        featpts_filtered = [featpts_filtered; feat];
    end % if
end % for

end % function

