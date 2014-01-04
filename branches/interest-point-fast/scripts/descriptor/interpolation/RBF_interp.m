%***************************************************************
% Usage:[r_complex] = RBF_interp(V1,Vm,r_simple )
% V1: vertex of markers in frame 1
% Vm: vertex of mesh complex in frame 1
% r_simple: the composant r in the mesh simple
% r_complex: the composant r in the mesh complex
%
% Reference: http://liris.cnrs.fr/Documents/Liris-3546.pdf
%
%           23/06/2013 Tian Tian
%***************************************************************

function [r_complex] = RBF_interp(V1,Vm,r_simple )

X = V1';
V_complex = Vm';
Y_1 = r_simple(1,:);
Y_2 = r_simple(2,:);
Y_3 = r_simple(3,:);


rbf_x = rbfcreate(X, Y_1,'RBFFunction', 'multiquadric', 'Stats', 'on');
rbf_y = rbfcreate(X, Y_2,'RBFFunction', 'multiquadric', 'Stats', 'on');
rbf_z = rbfcreate(X, Y_3,'RBFFunction', 'multiquadric', 'Stats', 'on');

x = rbfinterp( V_complex, rbf_x);
y = rbfinterp( V_complex, rbf_y);
z = rbfinterp( V_complex, rbf_z);
    
r_complex = [x;y;z]';

