function cmap = magma(n)
    % MAGMA Generate magma colormap
    % cmap = MAGMA(n) generates an n-by-3 colormap matrix
    % Default n = 256
    
    if nargin < 1, n = 256; end
    
    % Magma colormap approximation - key color points
    magma_data = [
        0.001462, 0.000466, 0.013866;  % Black
        0.078815, 0.009605, 0.162629;  % Very dark purple
        0.155834, 0.025563, 0.278513;  % Dark purple
        0.232077, 0.059706, 0.378384;  % Purple
        0.302436, 0.117570, 0.456550;  % Purple-magenta
        0.384299, 0.200582, 0.508781;  % Magenta
        0.493377, 0.313952, 0.529983;  % Red-magenta
        0.636902, 0.458219, 0.503410;  % Red
        0.784421, 0.619701, 0.426973;  % Orange-red
        0.895285, 0.795952, 0.348901;  % Orange
        0.987053, 0.991438, 0.749504   % Light yellow
    ];
    
    % Interpolate to get n colors
    x = linspace(0, 1, size(magma_data, 1));
    xi = linspace(0, 1, n);
    cmap = interp1(x, magma_data, xi);
end
