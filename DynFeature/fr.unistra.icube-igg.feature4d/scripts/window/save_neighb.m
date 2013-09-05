function [] = save_neighb(nvar, N, Nid)

assignin('caller', nvar, N);
assignin('caller', [nvar 'id'], N);

end % function

