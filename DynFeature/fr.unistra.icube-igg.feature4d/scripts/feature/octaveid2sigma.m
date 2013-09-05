function [ sigma ] = octaveid2sigma( objseq, oi )
    sigma = sqrt(oi) * objseq.edge_mean;
end % 

