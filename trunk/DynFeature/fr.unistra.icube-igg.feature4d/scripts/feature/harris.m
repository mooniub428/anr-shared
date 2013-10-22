% Find local maxima in the corner response  (Harris corner function)

function [ response ] = harris( R, k)

dimension = size(R, 1);
response = det(R) - k * trace(R) ^ dimension;

end % function

