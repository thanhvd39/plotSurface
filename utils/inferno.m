function cmap = inferno(n)
    % INFERNO Generate inferno colormap
    % cmap = INFERNO(n) generates an n-by-3 colormap matrix
    % Default n = 256
    
    if nargin < 1, n = 256; end
    
    % Inferno colormap approximation - key color points
    inferno_data = [
        0.001462, 0.000466, 0.013866;  % Black
        0.048691, 0.004135, 0.170838;  % Very dark blue
        0.109883, 0.010855, 0.300543;  % Dark blue
        0.186213, 0.018803, 0.407061;  % Blue-purple
        0.287076, 0.072911, 0.485077;  % Purple
        0.417642, 0.163625, 0.529983;  % Red-purple
        0.578304, 0.289371, 0.539294;  % Red
        0.735683, 0.449540, 0.510637;  % Orange-red
        0.864746, 0.630084, 0.429466;  % Orange
        0.944006, 0.827160, 0.318195;  % Yellow-orange
        0.988362, 0.998364, 0.644924   % Light yellow
    ];
    
    % Interpolate to get n colors
    x = linspace(0, 1, size(inferno_data, 1));
    xi = linspace(0, 1, n);
    cmap = interp1(x, inferno_data, xi);
end
