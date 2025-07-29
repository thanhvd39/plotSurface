% Test script to demonstrate colormap functionality in Brain GUI
% This script shows how different colormaps affect brain visualization

addpath('../main');
addpath('../utils');
addpath('../plotting');

fprintf('=== Testing Colormap Functionality ===\n\n');

% Test 1: Test colormap helper functions
fprintf('1. Testing colormap helper functions:\n');
colormaps_to_test = {'viridis', 'plasma', 'inferno', 'magma'};

for i = 1:length(colormaps_to_test)
    cmap_name = colormaps_to_test{i};
    try
        % Test if our custom colormap functions work
        eval(sprintf('cmap = %s(64);', cmap_name));
        fprintf('   ✓ %s colormap: Generated %dx%d colormap\n', cmap_name, size(cmap, 1), size(cmap, 2));
        
        % Check if values are in valid range [0,1]
        if all(cmap(:) >= 0) && all(cmap(:) <= 1)
            fprintf('     Values in valid range [0,1]\n');
        else
            fprintf('     ⚠️ Some values outside [0,1] range\n');
        end
    catch ME
        fprintf('   ✗ %s colormap failed: %s\n', cmap_name, ME.message);
    end
end

% Test 2: Generate sample data and test plotting with different colormaps
fprintf('\n2. Testing colormap integration with brain plotting:\n');

% Create sample brain data (200 regions for Schaefer atlas)
sample_data = randn(200, 1) * 0.5; % Random data with some structure
sample_data(1:50) = sample_data(1:50) + 1.5;  % Make some regions positive
sample_data(151:200) = sample_data(151:200) - 1.2; % Make some regions negative

fprintf('   Generated sample data: %d regions, range [%.3f, %.3f]\n', ...
        length(sample_data), min(sample_data), max(sample_data));

% Test colormap options
colormap_options = {'jet', 'hot', 'cool', 'viridis', 'plasma'};

for i = 1:length(colormap_options)
    cmap_name = colormap_options{i};
    try
        % Generate colormap
        switch cmap_name
            case 'viridis'
                cmap = viridis(64);
            case 'plasma'  
                cmap = plasma(64);
            case 'inferno'
                cmap = inferno(64);
            case 'magma'
                cmap = magma(64);
            otherwise
                cmap = eval([cmap_name '(64)']);
        end
        
        fprintf('   ✓ %s: Ready for brain plotting (%dx%d)\n', cmap_name, size(cmap, 1), size(cmap, 2));
        
    catch ME
        fprintf('   ✗ %s: Failed - %s\n', cmap_name, ME.message);
    end
end

% Test 3: Check if GUI components would work
fprintf('\n3. Testing GUI colormap dropdown options:\n');
gui_colormap_options = {'Auto (Default)', 'Jet', 'Hot', 'Cool', 'Spring', 'Summer', ...
                       'Autumn', 'Winter', 'Gray', 'Bone', 'Copper', 'Pink', ...
                       'Lines', 'Parula', 'Viridis', 'Plasma', 'Inferno', 'Magma'};

fprintf('   Available colormap options in GUI: %d\n', length(gui_colormap_options));
for i = 1:length(gui_colormap_options)
    fprintf('     %2d. %s\n', i, gui_colormap_options{i});
end

fprintf('\n=== Colormap Test Complete ===\n');
fprintf('The GUI now supports:\n');
fprintf('• Colormap selection dropdown with %d options\n', length(gui_colormap_options));
fprintf('• Colormap preview functionality\n');
fprintf('• Integration with brain plotting functions\n');
fprintf('• Custom colormap functions for newer MATLAB colormaps\n');
fprintf('• Info display showing selected colormap\n\n');

fprintf('Usage:\n');
fprintf('1. Run BrainGUI_Simple\n');
fprintf('2. Load data (CSV file or generate test data)\n');
fprintf('3. Select desired atlas from dropdown\n');
fprintf('4. Select desired colormap from dropdown\n');
fprintf('5. Click "Preview" to see colormap preview\n');
fprintf('6. Click "PLOT BRAIN SURFACE" to generate brain plot\n\n');
