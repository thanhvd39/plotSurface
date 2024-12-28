function cmap = createCustomColormap()
%CREATECUSTOMCOLORMAP Creates a custom colormap for visualization.
%   This function defines a colormap with three colors:
%   - cmap(1,:) = Light blue ([228,246,249]/255)
%   - cmap(2,:) = Light red ([247,218,218]/255)
%   - cmap(3,:) = Dark red ([164,46,42]/255)

cmap = zeros(3,3); % Initialize colormap matrix

% Define colors
% cmap(2,:) = [247,218,218]/255; % Light red

cmap(2,:) = [251,226,209]/255; % Light red
cmap(3,:) = [164,46,42]/255;   % Dark red
% cmap(1,:) = [228,246,249]/255; % Light blue
% cmap(1,:) = [224, 248, 212]/255;
cmap(1,:) = [205,239,195]/255;
cmap = [[1,1,1];cmap];
end