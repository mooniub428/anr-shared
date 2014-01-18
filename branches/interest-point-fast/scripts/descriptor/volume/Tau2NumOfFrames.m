function [Frames] = Tau2NumOfFrames(fi, tau)

Frames = [fi - 1 : fi + 1];
Frames = [fi - 2 : fi + 2];

end % function

