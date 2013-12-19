function [] = TestDiscreteGradient()

% Get grid data points, with scalar field
[Patch, Patch_prime, F, F_prime, Fv, Fv_prime, v, h] = GridData(); % prime referes to "border"

% Compute "ground-truth" gradient
[px, py] = gradient(F);

% Plot 
figure
subplot(2,2,1); 
image(flipud(F));

subplot(2,2,2); 
contour(v,v,F), hold on, quiver(v,v,px,py)

Patch = Grid2Vec(Patch.X, Patch.Y, Patch.Z);
Patch_prime = Grid2Vec(Patch_prime.X, Patch_prime.Y, Patch_prime.Z);
[Patch, Patch_prime] = PatchIndexIntersect(Patch, Patch_prime);

DistMatrix = squareform(pdist(Patch_prime(:, 1:3)));
A = GetAdj(DistMatrix, h);

G = GradientSet(Fv_prime, Patch, Patch_prime, A);

subplot(2,2,3); 
image(flipud(F));

[gx, gy] = Vec2Grid(G);
subplot(2,2,4); 
contour(v, v, F), hold on, quiver(v, v, gx, gy)

end % function

