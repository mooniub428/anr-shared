function [ D_ ] = gauss_scale( D )

distribution(D);
D_ = arrayfun(@gausslike, D);

end % function


function [g] = gausslike(x)

num_sigm = 1;

[g_m, g_sigm] = distribution(-1);

%if(x < num_sigm * g_sigm)
    k = 1;
    sigm = g_m;
%else
 %   k = num_sigm / exp(4);
  %  sigm = num_sigm * g_sigm; 
%end % if

g = k * (1 / (sigm * sqrt(2 * pi))) * exp(-x^2 / (2 * sigm^2));
g = 1 / g;

end % function

function [m, sigm] = distribution(D)

persistent max_;
persistent sigm_;

if(D ~= -1)
    mu = mean(reshape(D, numel(D), 1));
    max_ = max(reshape(D, numel(D), 1));
    sigm_ = std(reshape(D, numel(D), 1));
end % if

m = max_;
sigm = sigm_;

end % function
