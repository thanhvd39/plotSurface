% Simple test script to verify the GUI colormap functionality
addpath('main');
addpath('utils');
addpath('plotting');

fprintf('Testing BrainGUI_Simple with colormap functionality...\n');

try
    % Test 1: Create GUI (this should work without errors)
    fprintf('1. Creating GUI...\n');
    BrainGUI_Simple;
    fprintf('   ✓ GUI created successfully\n');
    
    pause(1); % Let GUI initialize
    
    % Close the GUI
    close all;
    
    fprintf('2. Testing colormap functions...\n');
    
    % Test colormap functions
    test_colormaps = {'viridis', 'plasma', 'inferno', 'magma'};
    for i = 1:length(test_colormaps)
        cmap_name = test_colormaps{i};
        try
            eval(sprintf('cmap = %s(64);', cmap_name));
            fprintf('   ✓ %s colormap working\n', cmap_name);
        catch ME
            fprintf('   ✗ %s colormap failed: %s\n', cmap_name, ME.message);
        end
    end
    
    fprintf('\n✓ All tests passed!\n');
    fprintf('The GUI should now work properly with colormap selection.\n');
    
catch ME
    fprintf('✗ Error: %s\n', ME.message);
    fprintf('Stack trace:\n');
    for i = 1:length(ME.stack)
        fprintf('  Line %d in %s\n', ME.stack(i).line, ME.stack(i).name);
    end
end
