function [angle] = RotAngle(e_prime)

x = e_prime(1);
y = e_prime(2);

if(x > 0 && y >= 0) % I Quarter
    angle = atan(y / x);
elseif( x < 0 && y >= 0) % II Quarter
    angle = atan(y / x);
    angle = pi + angle;
elseif(x < 0 && y <= 0) % III Quarter
    angle = atan(y / x);
    angle = pi + angle;
elseif(x > 0 && y <= 0) % IV Quarter
    angle = atan(y / x);
elseif( (x == 0) && (y < 0) ) % Singularity
    angle = 3 * pi / 2;
elseif( (x == 0) && (y > 0) )
end % if

end % function

