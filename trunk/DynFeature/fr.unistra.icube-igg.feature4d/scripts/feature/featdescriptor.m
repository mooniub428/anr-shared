function [ feat_dscr ] = featdescriptor( R, D_eigen )

n_t = size(R, 3);
n_f = size(R, 4);

feat_dscr = zeros(n_t, n_f);

for f_i = 2 : n_f
    for t_i = 1 : n_t
        C = R(:,:, t_i, f_i);        
        lambdas = eig(C);
        feat_dscr(t_i, f_i) = FracAnisotropy(lambdas);
        
        D = D_eigen(t_i,:,f_i);
        D = reshape(D, 3,1);
        D = D - 1.0;
        if(norm(D) < 0.5)
            feat_dscr(t_i, f_i) = -1.0;
        end % if
        %{
        if( mean(abs(D)) < 0.001 )
            feat_dscr(t_i, f_i) = -1.0;
        end % if
        %}
        %{
        if( sum(abs(D)) < 0.25)
            feat_dscr(t_i, f_i) = -1.0;
        end % if
        %}
    end % for
end % for

end % function

