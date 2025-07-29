% Demonstration of colormap selection functionality
% This script shows different colormaps applied to brain data

addpath('../main');
addpath('../utils');
addpath('../plotting');

fprintf('=== Colormap Demonstration ===\n');

% Create sample data
sample_data = randn(200, 1) * 0.5;
sample_data(1:50) = sample_data(1:50) + 1.5;  % Positive regions
sample_data(151:200) = sample_data(151:200) - 1.2; % Negative regions

% Test different colormaps
colormaps_to_demo = {'jet', 'hot', 'viridis', 'plasma'};

for i = 1:length(colormaps_to_demo)
    cmap_name = colormaps_to_demo{i};
    
    try
        fprintf('Generating brain plot with %s colormap...\n', cmap_name);
        
        % Generate colormap
        switch cmap_name
            case 'viridis'
                color_map = viridis(64);
            case 'plasma'
                color_map = plasma(64);
            case 'inferno'
                color_map = inferno(64);
            case 'magma'
                color_map = magma(64);
            otherwise
                color_map = eval([cmap_name '(64)']);
        end
        
        % Generate output filename
        output_name = sprintf('demo_%s_colormap', cmap_name);
        
        % Call plotting function (commented out to avoid actual plotting in headless mode)
        % plot_brain_from_brain_weight('weight', sample_data, ...
        %                            'name', output_name, ...
        %                            'dir', '../output', ...
        %                            'colormap', color_map, ...
        %                            'atlas', 'schaefer200');
        
        fprintf('✓ %s colormap ready for plotting\n', cmap_name);
        
    catch ME
        fprintf('✗ Error with %s: %s\n', cmap_name, ME.message);
    end
end

fprintf('\n=== Summary of Colormap Features ===\n');
fprintf('✓ Colormap dropdown with 18 options\n');
fprintf('✓ Preview functionality for colormap visualization\n');
fprintf('✓ Custom colormap functions (viridis, plasma, inferno, magma)\n');
fprintf('✓ Integration with plot_brain_from_brain_weight function\n');
fprintf('✓ Info display shows selected colormap\n');
fprintf('✓ Auto colormap option for data-driven color selection\n\n');

fprintf('GUI Components Added:\n');
fprintf('• Colormap selection dropdown\n');
fprintf('• Colormap preview button\n');
fprintf('• Updated info display with colormap information\n');
fprintf('• Integration with plotting pipeline\n\n');
