% Get a set of strain vectors/tensors in a local neighbourhood ...
% That could used for local covariance analysis

function [ V ] = global_strain_tensor(S, N, t_i, f_i, param)

global nwindow;

tri_ring = nonzeros(N(t_i, :));

n = nwindow.var_space * nwindow.var_time;
V = zeros(n, param.n_dim);

starting_frame = f_i - nwindow.var_time;
ending_frame = f_i + nwindow.var_time;

if(starting_frame < 1)
    starting_frame = 1;
end % if
if(ending_frame > param.n_f)
    ending_frame = param.n_f;
end % if

counter = 1;
for i = starting_frame : ending_frame
    for j = 1 : nwindow.var_space
        t = tri_ring(j);
        V(counter, :) = S(t, :, i);
        counter = counter + 1;
    end % for
end % for

end % function

