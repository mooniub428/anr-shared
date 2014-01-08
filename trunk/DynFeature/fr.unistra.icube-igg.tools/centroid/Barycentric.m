%{
void Barycentric(Point a, Point b, Point c, float &u, float &v, float &w)
{
    Vector v0 = b - a, v1 = c - a, v2 = p - a;
    float d00 = Dot(v0, v0);
    float d01 = Dot(v0, v1);
    float d11 = Dot(v1, v1);
    float d20 = Dot(v2, v0);
    float d21 = Dot(v2, v1);
    float invDenom = 1.0 / (d00 * d11 - d01 * d01);
    v = (d11 * d20 - d01 * d21) * invDenom;
    w = (d00 * d21 - d01 * d20) * invDenom;
    u = 1.0f - v - w;
}
%}


% Compute barycentric coordinates (u, v, w) for
% Point with respect to Triangle
% Point is supposed to be a row vector
function [u v w] = Barycentric(Point, Triangle)
    v0 = Triangle(2, :) - Triangle(1, :);
    v1 = Triangle(3, :) - Triangle(1, :);
    v2 = Point - Triangle(1, :);
    d00 = dot(v0, v0);
    d01 = dot(v0, v1);
    d11 = dot(v1, v1);
    d20 = dot(v2, v0);
    d21 = dot(v2, v1);
    invDenom = 1.0 / (d00 * d11 - d01 * d01);
    v = (d11 * d20 - d01 * d21) * invDenom;
    w = (d00 * d21 - d01 * d20) * invDenom;
    u = 1.0 - v - w;
end % function

