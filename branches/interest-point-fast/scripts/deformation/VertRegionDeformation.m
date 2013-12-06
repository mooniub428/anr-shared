% This function computes strain values for faces in all frames of an animation.
%
function [D] = VertRegionDeformation(vertices, triangles, rgnRad, geoDistData)
    disp(':: Compute region surface deformation');
    nbV = size(vertices, 1);
    nbF = size(vertices, 3);
    
    % Compute surface area per vertex
    [vertSurfArea ~] = CompSurfArea(squeeze(vertices(:,:,1)), triangles);

    % Another method
    vertSeg = ComputeVertRgnUsingGeoDist(squeeze(vertices(:,:,1)), geoDistData, rgnRad);

    D = zeros(nbV, nbF);
    for i = 1 : nbV        
        D(i, :) = ComputeStrainForAVert(vertices, vertSurfArea, vertSeg, i);
    end % for
    
    % Free memory
    clear vertTri;
end % function VertRegionDeformation


% Compute the surface area per vertex
function [ vertSurfArea, triSurfArea ] = CompSurfArea( vertices, triangles )
    nbTri=size(triangles,1);
    nbV=size(vertices,1);
    vertSurfArea=zeros(nbV,1);
    triSurfArea=zeros(nbTri,1);

    surfArea=0;
    for i=1:nbTri
        % Compute the surface area of the triangle
        x=[vertices(triangles(i,1),1), vertices(triangles(i,2),1), vertices(triangles(i,3),1)];
        y=[vertices(triangles(i,1),2), vertices(triangles(i,2),2), vertices(triangles(i,3),2)];
        z=[vertices(triangles(i,1),3), vertices(triangles(i,2),3), vertices(triangles(i,3),3)];
        ons = [1 1 1];
        triSurfArea(i) = 0.5*sqrt(det([x;y;ons])^2 + det([y;z;ons])^2 + det([z;x;ons])^2);
        surfArea=surfArea+triSurfArea(i);
    
        vertSurfArea(triangles(i,1))=vertSurfArea(triangles(i,1))+triSurfArea(i)/3;
        vertSurfArea(triangles(i,2))=vertSurfArea(triangles(i,2))+triSurfArea(i)/3;
        vertSurfArea(triangles(i,3))=vertSurfArea(triangles(i,3))+triSurfArea(i)/3;
    end % for
end % function CompSurfArea


% Compute a set of vertices around a triangle and whose distance is smaller
% to rgnRad
function [vertSeg] = ComputeVertRgnUsingGeoDist(vertices, geoDistData, rgnRad)
    nbV=size(vertices,1);
    vertSeg=cell(nbV,1);
    
    for vi = 1 : nbV 
        vertSeg{vi} = vi;
        while (numel(vertSeg{vi}) < 4)
            distance_row = geoDistData(vi, :);
            neighbVID = find(distance_row < rgnRad);
            neighbVID = find(neighbVID ~= vi);
            if(numel(neighbVID) > 0)
                vertSeg{vi} = [vi, neighbVID];
            end % if
            rgnRad = 1.1 * rgnRad;
        end % while
    end % for
end % function ComputeVertRgnUsingGeoDist


function [ strain ] = ComputeStrainForAVert(animVertices,vertSurfArea,vertSeg,vertID)
    nbF=size(animVertices, 3);
    strain=zeros(1,nbF);

    src = [animVertices(vertSeg{vertID}, 1, 1), animVertices(vertSeg{vertID}, 2, 1), animVertices(vertSeg{vertID}, 3, 1)];
  
    assert(vertSeg{vertID}(1)==vertID);
    
    origSrc=[animVertices(vertID, 1, 1)',animVertices(vertID, 2, 1)',animVertices(vertID, 3, 1)'];
    src=src-repmat(origSrc,numel(vertSeg{vertID}),1);
    % Compute the distance to the center of the segment
    w=sqrt(sum(src.^2,2));
    tmpVertSeg=vertSeg{vertID};
    tmpVertSeg=tmpVertSeg(w>0);
    src=src(w>0,:);
    w=w(w>0);

    wSurf=vertSurfArea(tmpVertSeg);
    wSurf=wSurf./sum(wSurf);
    wSrc=src.*repmat(wSurf,1,3);

    for f = 2 : nbF
        trg = [animVertices(tmpVertSeg, 1, f), animVertices(tmpVertSeg, 2,  f), animVertices(tmpVertSeg, 3, f)];
        % Translation to the origin
        %origTrg=sum(trg,1)/numel(vertSeg{vertID});
        origTrg = [animVertices(vertID, 1, f)', animVertices(vertID, 2, f)', animVertices(vertID, 3, f)'];
        trg = trg - repmat(origTrg, numel(tmpVertSeg),1);
        wTrg = trg.*repmat(wSurf, 1, 3);
    
        % Compute the rotation matrix
        %   [U,~,V] = svd(src'*trg);
        [U,~,V] = svd(wSrc'*wTrg);
        R=U*V';
    
        % Compute the residual
        strainPerV=sqrt(sum((src*R-trg).^2,2));
        % Compute the residual average
        strain(f)=sum((strainPerV./w).*wSurf);
    
        src=trg;
        wSrc=wTrg;
    end % for
end % function ComputeStrainForAVert

