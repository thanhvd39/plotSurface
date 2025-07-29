function cmap = viridis(n)
    % VIRIDIS Generate viridis colormap
    % cmap = VIRIDIS(n) generates an n-by-3 colormap matrix
    % Default n = 256
    
    if nargin < 1, n = 256; end
    
    % Viridis colormap approximation - key color points
    viridis_data = [
        0.267004, 0.004874, 0.329415;  % Dark purple
        0.282623, 0.140926, 0.457517;  % Purple
        0.253935, 0.265254, 0.529983;  % Blue-purple
        0.206756, 0.371758, 0.553117;  % Blue
        0.163625, 0.471133, 0.558148;  % Blue-green
        0.127568, 0.566949, 0.550556;  % Green-blue
        0.134692, 0.658636, 0.517649;  % Green
        0.266941, 0.748751, 0.440573;  % Yellow-green
        0.477504, 0.821444, 0.318195;  % Yellow
        0.741388, 0.873449, 0.149561;  % Light yellow
        0.993248, 0.906157, 0.143936   % Bright yellow
    ];
    
    % Interpolate to get n colors
    x = linspace(0, 1, size(viridis_data, 1));
    xi = linspace(0, 1, n);
    cmap = interp1(x, viridis_data, xi);
end
