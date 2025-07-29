function cmap = plasma(n)
    % PLASMA Generate plasma colormap
    % cmap = PLASMA(n) generates an n-by-3 colormap matrix
    % Default n = 256
    
    if nargin < 1, n = 256; end
    
    % Plasma colormap approximation - key color points
    plasma_data = [
        0.050383, 0.029803, 0.527975;  % Dark blue
        0.186213, 0.018803, 0.587228;  % Purple-blue
        0.287076, 0.010855, 0.627295;  % Purple
        0.381047, 0.001814, 0.653068;  % Magenta-purple
        0.471457, 0.005678, 0.659897;  % Magenta
        0.558148, 0.042253, 0.644924;  % Red-magenta
        0.640374, 0.098387, 0.606642;  % Red
        0.716387, 0.172719, 0.541106;  % Orange-red
        0.784421, 0.266479, 0.445702;  % Orange
        0.843532, 0.384299, 0.319118;  % Yellow-orange
        0.940015, 0.975158, 0.131326   % Bright yellow
    ];
    
    % Interpolate to get n colors
    x = linspace(0, 1, size(plasma_data, 1));
    xi = linspace(0, 1, n);
    cmap = interp1(x, plasma_data, xi);
end
