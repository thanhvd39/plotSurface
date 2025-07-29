% Test script to check atlas availability and plotting functionality
clear; clc;

% Add paths
addpath('utils');
addpath('plotting');
addpath('data');

% Test 1: Check if atlas configuration function exists
fprintf('=== Test 1: Atlas Configuration Function ===\n');
try
    atlas_config = get_brain_atlas_config();
    fprintf('✓ get_brain_atlas_config() works\n');
    atlas_keys = fieldnames(atlas_config);
    fprintf('Found %d atlas configurations: %s\n', length(atlas_keys), strjoin(atlas_keys, ', '));
catch ME
    fprintf('✗ Error in get_brain_atlas_config(): %s\n', ME.message);
end

% Test 2: Check available atlases
fprintf('\n=== Test 2: Available Atlases ===\n');
try
    [available_atlases, atlas_info] = get_available_atlases();
    if isempty(available_atlases)
        fprintf('✗ No atlases available!\n');
    else
        fprintf('✓ Found %d available atlases:\n', length(available_atlases));
        for i = 1:length(available_atlases)
            atlas_key = available_atlases{i};
            atlas_name = atlas_info.(atlas_key).name;
            regions = atlas_info.(atlas_key).num_regions;
            fprintf('  %d. %s: %s (%d regions)\n', i, atlas_key, atlas_name, regions);
        end
    end
catch ME
    fprintf('✗ Error in get_available_atlases(): %s\n', ME.message);
end

% Test 3: Check data files
fprintf('\n=== Test 3: Data Files ===\n');
data_dir = fullfile(pwd, 'data');
fprintf('Data directory: %s\n', data_dir);

% List annotation files
annot_files = dir(fullfile(data_dir, '*.annot'));
if isempty(annot_files)
    fprintf('✗ No .annot files found!\n');
else
    fprintf('✓ Found %d annotation files:\n', length(annot_files));
    for i = 1:length(annot_files)
        fprintf('  %s\n', annot_files(i).name);
    end
end

% Test 4: Check plotting function
fprintf('\n=== Test 4: Plotting Function ===\n');
if exist('plot_brain_from_brain_weight', 'file')
    fprintf('✓ plot_brain_from_brain_weight function exists\n');
else
    fprintf('✗ plot_brain_from_brain_weight function not found!\n');
end

fprintf('\nTest completed.\n');
