%{
Vector3d Tri::cartesian(const Vector3d& barycentric) const
{
      return barycentric.x * p0 + barycentric.y * p1 + barycentric.z * p2;
}
%}
function [Cartesian] = Barycentric2Cartesian(BarCoord, Triangle)
	Cartesian = zeros(1, 3);
	for i = 1 : 3
		Cartesian = Cartesian + BarCoord(i) * Triangle(i, :);
	end % function
end % function