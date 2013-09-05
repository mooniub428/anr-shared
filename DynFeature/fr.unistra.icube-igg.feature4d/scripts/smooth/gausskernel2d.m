function [ gaussian ] = gausskernel2d( x, t, sigma )

gaussian = (1 / (2 * pi * sigma ^ 2)) * exp( -(x^2 + t^2) / (2 * sigma ^ 2) );

end % function

