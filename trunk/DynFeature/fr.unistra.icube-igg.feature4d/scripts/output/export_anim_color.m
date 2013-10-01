function [  ] = export_anim_color( D_, vertices_with_spheres )

% String constants
export_dir = '../../fr.unistra.icube-igg.debug/featpts_vis/';
basename = 'frame_';

n = size(D_, 1);
n_with_spheres = size(vertices_with_spheres);

% Compute color
C=[];
for i = 2 : n
    scalars = D_(:,i))';
    scalars = [scalars max(scalars) * ones(n_with_spheres - n)];
    c = produce_color(scalars) / 255;
    C=[C; c]; 
end % for

save('colors.txt', 'C', '-ascii');

end % function

