function [ ] = export_strain_vis( D_, objseq, param )

if (param.visualize_strain)
    export_dir = '../../fr.unistra.icube-igg.debug/strain_vis/';
    basename = 'strain_';
    
    for fi = 2 : objseq.n_f
        id = int2str(fi);
        if (fi < 10)
            id = ['0' id];
        end % if
        filename = [export_dir basename id '.ply'];
        vertex_color = produce_color(D_(:, fi));
        vertices = reshape(objseq.V(:, :, fi), objseq.n_v, 3);
        exportPLY(filename, vertices, vertex_color, objseq.triangles, 0);
    end % for
end % if

end % function

