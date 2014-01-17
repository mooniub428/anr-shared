% phi is elevation, theta is azimuth
function [omega] = SolidAngle(phi, deltaTheta, deltaPhi)

omega = deltaTheta * (cos(phi) - cos(phi + deltaPhi));

end % function

