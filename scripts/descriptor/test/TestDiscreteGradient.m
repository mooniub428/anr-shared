function [] = TestDiscreteGradient()

% Get grid data points, with scalar field
[Patch, Patch_prime, F, F_prime, v, h] = GridData(); % prime referes to "border"

% Compute "ground-truth" gradient
[px, py] = gradient(F);

% Plot 
figure
subplot(1,2,1); 
image(flipud(F));

subplot(1,2,2); 
contour(v,v,F), hold on, quiver(v,v,px,py)

Patch = Grid2Vec(Patch.X, Patch.Y, Patch.Z);
Patch_prime = Grid2Vec(Patch.X, Patch.Y, Patch.Z);
DistMatrix = squareform(pdist(Patch));
A = GetAdj(DistMatrix, h);

GradientSet(F, Patch, PatchWithBorder, A);

end % function

