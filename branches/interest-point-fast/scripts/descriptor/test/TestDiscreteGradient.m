function [] = TestDiscreteGradient()

[F, F1, v, h] = GridData();

% Compute "ground-truth" gradient
[px, py] = gradient(F);

% Plot 
figure
subplot(1,2,1); 
image(flipud(F));

subplot(1,2,2); 
contour(v,v,F), hold on, quiver(v,v,px,py)

Patch = Grid2Vec(X, Y, Z);
DistMatrix = squareform(pdist(Patch));
A = GetAdj(DistMatrix, h);

GradientSet(F, Patch, PatchWithBorder, A);

end % function

