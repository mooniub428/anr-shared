function [ D_ ] = scale_data( D, scale_function )

disp(':: Scale Data');
tic;
D_ = scale_function(D);
D_ = D_ / max(reshape(D_, numel(D_), 1));
toc;

end % function

