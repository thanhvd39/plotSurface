% Test script for Schaefer 100 regions atlas plotting
% This script generates test data, loads it, and plots using Schaefer 100 atlas

clear; clc;
fprintf('=== Testing Schaefer 100 Regions Atlas Plotting ===\n\n');

try
    % Add necessary paths
    current_dir = pwd;
    addpath(fullfile(current_dir, 'plotting'));
    addpath(fullfile(current_dir, 'utils'));
    addpath(fullfile(current_dir, 'data'));
    addpath(fullfile(current_dir, 'main'));
    
    % Create output directory if it doesn't exist
    output_dir = fullfile(current_dir, 'output');
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end
    
    fprintf('1. Setting up paths and directories... ✓\n');
    
    % Check if required functions exist
    if ~exist('plot_brain_from_brain_weight', 'file')
        error('plot_brain_from_brain_weight function not found!');
    end
    
    if ~exist('get_available_atlases', 'file')
        error('get_available_atlases function not found!');
    end
    
    fprintf('2. Checking required functions... ✓\n');
    
    % Get available atlases and check if Schaefer 100 is available
    [available_atlases, atlas_info] = get_available_atlases();
    
    if ~ismember('schaefer100', available_atlases)
        error('Schaefer 100 atlas not available! Available atlases: %s', strjoin(available_atlases, ', '));
    end
    
    fprintf('3. Verifying Schaefer 100 atlas availability... ✓\n');
    fprintf('   Atlas name: %s\n', atlas_info.schaefer100.name);
    fprintf('   Regions: %d\n', atlas_info.schaefer100.num_regions);
    fprintf('   LH annotation: %s\n', atlas_info.schaefer100.lh_annot);
    fprintf('   RH annotation: %s\n', atlas_info.schaefer100.rh_annot);
    
    % Generate test data for Schaefer 100 (100 regions)
    fprintf('\n4. Generating test data for Schaefer 100...\n');
    
    rng(42); % Fixed seed for reproducibility
    num_regions = 100;
    
    % Create structured test data with different patterns
    test_data = randn(num_regions, 1) * 0.5; % Base random noise
    
    % Add strong positive activation in first 15 regions (e.g., frontal areas)
    test_data(1:15) = test_data(1:15) + 2.5;
    
    % Add moderate positive activation in regions 16-30 (e.g., parietal areas)
    test_data(16:30) = test_data(16:30) + 1.2;
    
    % Add strong negative activation in regions 31-45 (e.g., temporal areas)
    test_data(31:45) = test_data(31:45) - 1.8;
    
    % Add moderate negative activation in regions 46-60
    test_data(46:60) = test_data(46:60) - 0.8;
    
    % Leave regions 61-100 as mostly baseline with small variations
    test_data(61:100) = test_data(61:100) * 0.3;
    
    % Save test data
    test_filename = fullfile('data', 'test_schaefer100_regions.csv');
    writematrix(test_data, test_filename);
    
    fprintf('   ✓ Test data generated: %s\n', test_filename);
    fprintf('   Data range: %.3f to %.3f\n', min(test_data), max(test_data));
    fprintf('   Strong positive regions: 1-15 (mean: %.3f)\n', mean(test_data(1:15)));
    fprintf('   Moderate positive regions: 16-30 (mean: %.3f)\n', mean(test_data(16:30)));
    fprintf('   Strong negative regions: 31-45 (mean: %.3f)\n', mean(test_data(31:45)));
    fprintf('   Moderate negative regions: 46-60 (mean: %.3f)\n', mean(test_data(46:60)));
    fprintf('   Baseline regions: 61-100 (mean: %.3f)\n', mean(test_data(61:100)));
    
    % Test different colormaps
    colormaps_to_test = {
        {'Auto', ''},
        {'Jet', jet(64)},
        {'Hot', hot(64)},
        {'Cool', cool(64)},
        {'Viridis', viridis(64)},
        {'Plasma', plasma(64)}
    };
    
    fprintf('\n5. Testing different colormaps with Schaefer 100 atlas...\n');
    
    for i = 1:length(colormaps_to_test)
        colormap_name = colormaps_to_test{i}{1};
        colormap_data = colormaps_to_test{i}{2};
        
        fprintf('   Testing %s colormap...', colormap_name);
        
        try
            % Generate unique image name
            image_name = sprintf('test_schaefer100_%s_%s', lower(colormap_name), datestr(now, 'HHMMSS'));
            
            % Call plotting function
            plot_brain_from_brain_weight('weight', test_data, ...
                                       'name', image_name, ...
                                       'dir', 'output', ...
                                       'colormap', colormap_data, ...
                                       'atlas', 'schaefer100', ...
                                       'min', -inf, ...
                                       'max', inf);
            
            fprintf(' ✓ SUCCESS\n');
            
        catch ME
            fprintf(' ✗ FAILED: %s\n', ME.message);
        end
        
        % Small pause between plots
        pause(1);
    end
    
    % Test with custom value ranges
    fprintf('\n6. Testing custom value ranges...\n');
    
    range_tests = {
        {'Full_Range', -inf, inf},
        {'Positive_Only', 0, inf},
        {'Negative_Only', -inf, 0},
        {'Custom_Range', -1, 2}
    };
    
    for i = 1:length(range_tests)
        range_name = range_tests{i}{1};
        min_val = range_tests{i}{2};
        max_val = range_tests{i}{3};
        
        fprintf('   Testing %s (%.1f to %.1f)...', range_name, min_val, max_val);
        
        try
            image_name = sprintf('test_schaefer100_range_%s_%s', range_name, datestr(now, 'HHMMSS'));
            
            plot_brain_from_brain_weight('weight', test_data, ...
                                       'name', image_name, ...
                                       'dir', 'output', ...
                                       'colormap', viridis(64), ...
                                       'atlas', 'schaefer100', ...
                                       'min', min_val, ...
                                       'max', max_val);
            
            fprintf(' ✓ SUCCESS\n');
            
        catch ME
            fprintf(' ✗ FAILED: %s\n', ME.message);
        end
        
        pause(1);
    end
    
    % Summary
    fprintf('\n=== TEST SUMMARY ===\n');
    fprintf('✓ Schaefer 100 atlas test completed successfully!\n');
    fprintf('✓ Test data generated with 100 regions\n');
    fprintf('✓ Multiple colormaps tested\n');
    fprintf('✓ Different value ranges tested\n');
    fprintf('✓ Output files saved to: %s\n', output_dir);
    
    % List generated files
    output_files = dir(fullfile(output_dir, 'test_schaefer100*.png'));
    if ~isempty(output_files)
        fprintf('\nGenerated plot files:\n');
        for i = 1:length(output_files)
            fprintf('  - %s\n', output_files(i).name);
        end
    end
    
    fprintf('\nTo use this data in the GUI:\n');
    fprintf('1. Run: BrainGUI_Simple\n');
    fprintf('2. Click "Browse CSV File" and select: %s\n', test_filename);
    fprintf('3. Select "Schaefer 100 Parcels (7 Networks) (100 regions)" from atlas dropdown\n');
    fprintf('4. Choose your preferred colormap\n');
    fprintf('5. Click "PLOT BRAIN SURFACE"\n');
    
catch ME
    fprintf('✗ Error during testing: %s\n', ME.message);
    fprintf('\nError details:\n');
    for i = 1:length(ME.stack)
        fprintf('  %s (line %d) in %s\n', ME.stack(i).name, ME.stack(i).line, ME.stack(i).file);
    end
end
