function [triRing] = TriRing(VertID, Triangles)    
     triRing = [];
     numOfRingPoints = size(VertID, 1);
     for i = 1 : numOfRingPoints
         [ti, ~] = find(Triangles == VertID(i));
         triRing = [triRing; ti];
     end % for
     triRing = unique(triRing);
end % function