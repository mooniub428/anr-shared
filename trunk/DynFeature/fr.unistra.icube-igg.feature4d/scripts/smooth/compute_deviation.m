% Implementation based on 
% Peter Kovesi, Arbitrary Gaussian Filtering with 25 Additions and 5
% Multiplications per Pixel.
% http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.155.354&rep=rep1&type=pdf
function [ std_dev ] = compute_deviation( width, n )

std_dev = sqrt((n*width^2 - n) / 12);

end % function

