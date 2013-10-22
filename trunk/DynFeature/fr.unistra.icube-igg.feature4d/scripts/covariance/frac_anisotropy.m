function [ fa ] = frac_anisotropy( lambdas )

n = numel(lambdas);
l_m = mean(lambdas);

coef = sqrt(3 / 2);

numerator = 0.0;
denominator = 0.0;
for i = 1 : n
    l = lambdas(i);
    numerator = numerator + (l - l_m)^2;
    denominator = denominator + l^2;
end % for

fa = coef * sqrt(numerator) / sqrt(denominator);

end % function

