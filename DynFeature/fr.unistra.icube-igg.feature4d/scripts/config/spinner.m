function [ output_args ] = spinner( param, id )
%SPINNER Summary of this function goes here
%   Detailed explanation goes here

disp(cell2mat(param.spins(mod(id, 7) + 1)));


end

