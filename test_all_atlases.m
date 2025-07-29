% Test multi-atlas functionality
clear; clc;

% Test with actual GUI launch
try
    fprintf('=== Testing Multi-Atlas Brain Plotting System ===\n\n');
    
    % Add paths first
    current_dir = pwd;
    addpath(fullfile(current_dir, 'plotting'));
    addpath(fullfile(current_dir, 'utils'));
    addpath(fullfile(current_dir, 'data'));
    addpath(fullfile(current_dir, 'main'));
    
    % Test 1: Check if atlas functions exist
    fprintf('1. Checking atlas functions...\n');
    if exist('get_brain_atlas_config', 'file')
        fprintf('   ✓ get_brain_atlas_config found\n');
    else
        fprintf('   ✗ get_brain_atlas_config missing\n');
        return;
    end
    
    if exist('get_available_atlases', 'file')
        fprintf('   ✓ get_available_atlases found\n');
    else
        fprintf('   ✗ get_available_atlases missing\n');
        return;
    end
    
    % Test 2: Get available atlases
    fprintf('\n2. Getting available atlases...\n');
    [available_atlases, atlas_info] = get_available_atlases();
    
    if isempty(available_atlases)
        fprintf('   ✗ No atlases available!\n');
        return;
    else
        fprintf('   ✓ Found %d available atlases:\n', length(available_atlases));
        for i = 1:length(available_atlases)
            atlas_key = available_atlases{i};
            atlas_name = atlas_info.(atlas_key).name;
            regions = atlas_info.(atlas_key).num_regions;
            fprintf('     %d. %s: %s (%d regions)\n', i, atlas_key, atlas_name, regions);
        end
    end
    
    % Test 3: Check plotting function
    fprintf('\n3. Checking plotting function...\n');
    if exist('plot_brain_from_brain_weight', 'file')
        fprintf('   ✓plot_brain_from_brain_weight found\n');
    else
        fprintf('   ✗ plot_brain_from_brain_weight missing\n');
        return;
    end
    
    % Test 4: Check existing simulated data and create proper atlas-matched files
    fprintf('\n4. Checking and fixing simulated data files...\n');
    
    % Check existing simulated data
    sim_dir = fullfile(current_dir, 'data', 'simulated');
    fprintf('   Checking simulated data directory: %s\n', sim_dir);
    
    if exist(sim_dir, 'dir')
        sim_files = dir(fullfile(sim_dir, '*.csv'));
        fprintf('   Found %d CSV files in simulated data\n', length(sim_files));
        
        % Check sizes of key files
        for j = 1:length(sim_files)
            file_path = fullfile(sim_dir, sim_files(j).name);
            try
                data = readmatrix(file_path);
                fprintf('   %s: %d regions\n', sim_files(j).name, length(data));
            catch
                fprintf('   %s: Could not read\n', sim_files(j).name);
            end
        end
    end
    
    % Generate/copy proper test data for each available atlas
    fprintf('\n   Creating atlas-matched test data...\n');
    for i = 1:length(available_atlases)
        atlas_key = available_atlases{i};
        num_regions = atlas_info.(atlas_key).num_regions;
        atlas_name = atlas_info.(atlas_key).short_name;
        
        % Check if we have existing data that matches
        matched_file = '';
        if num_regions == 100 && exist(fullfile('data', 'test_schaefer100.csv'), 'file')
            % Use existing 100-region file from main data directory
            existing_data = readmatrix(fullfile('data', 'test_schaefer100.csv'));
            if length(existing_data) == 100
                matched_file = 'test_schaefer100.csv';
                test_data = existing_data;
            end
        elseif num_regions == 200 && exist(fullfile(sim_dir, 'schaefer200_weights.csv'), 'file')
            % Use simulated 200-region data
            existing_data = readmatrix(fullfile(sim_dir, 'schaefer200_weights.csv'));
            if length(existing_data) == 200
                matched_file = 'schaefer200_weights.csv';
                test_data = existing_data;
            end
        end
        
        if isempty(matched_file)
            % Generate new test data if no matching file found
            rng(42 + i); % Different seed for each atlas
            test_data = randn(num_regions, 1);
            test_data(1:min(20, num_regions)) = test_data(1:min(20, num_regions)) + 2;
            test_data(min(21, num_regions):min(40, num_regions)) = test_data(min(21, num_regions):min(40, num_regions)) - 1.5;
            matched_file = sprintf('generated_%d_regions', num_regions);
        end
        
        % Save test file with proper naming
        test_filename = sprintf('data/test_%s_%d.csv', atlas_key, num_regions);
        writematrix(test_data, test_filename);
        
        fprintf('   ✓ Created %s (%d regions) - source: %s\n', test_filename, num_regions, matched_file);
    end
    
    % Test 5: Try plotting with each atlas
    fprintf('\n5. Testing plotting with each atlas...\n');
    for i = 1:length(available_atlases)
        atlas_key = available_atlases{i};
        num_regions = atlas_info.(atlas_key).num_regions;
        test_filename = sprintf('data/test_%s_%d.csv', atlas_key, num_regions);
        
        try
            fprintf('   Testing %s...', atlas_key);
            
            % Load test data
            test_data = readmatrix(test_filename);
            
            % Test plotting
            plot_name = sprintf('test_plot_%s', atlas_key);
            plot_brain_from_brain_weight('weight', test_data, ...
                                       'name', plot_name, ...
                                       'dir', 'output', ...
                                       'atlas', atlas_key, ...
                                       'colormap', jet(64));
            
            fprintf(' ✓ SUCCESS\n');
            
        catch ME
            fprintf(' ✗ FAILED: %s\n', ME.message);
        end
    end
    
    fprintf('\n=== Summary ===\n');
    fprintf('Available atlases: %d\n', length(available_atlases));
    fprintf('You can now run BrainGUI_Simple and test with:\n');
    for i = 1:length(available_atlases)
        atlas_key = available_atlases{i};
        num_regions = atlas_info.(atlas_key).num_regions;
        fprintf('  - Load test_%s_%d.csv and select %s\n', atlas_key, num_regions, atlas_info.(atlas_key).name);
    end
    
catch ME
    fprintf('Error during testing: %s\n', ME.message);
    fprintf('Stack trace:\n');
    for i = 1:length(ME.stack)
        fprintf('  %s (line %d)\n', ME.stack(i).name, ME.stack(i).line);
    end
end
