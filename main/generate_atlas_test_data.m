% Generate test data for different atlases
% This script creates sample data files for testing the multi-atlas system

fprintf('Generating test data for different brain atlases...\n\n');

% Create output directory
output_dir = fullfile(pwd, 'data', 'atlas_test_data');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Get atlas configurations
atlas_config = get_brain_atlas_config();
[available_atlases, atlas_info] = get_available_atlases();

for i = 1:length(available_atlases)
    atlas_key = available_atlases{i};
    atlas = atlas_info.(atlas_key);
    
    fprintf('Generating data for %s (%d regions)...\n', atlas.name, atlas.num_regions);
    
    % Generate realistic test data
    rng(123 + i); % Different seed for each atlas
    
    % Create structured brain data
    data = randn(atlas.num_regions, 1) * 0.5;
    
    % Add some structure based on typical brain networks
    if atlas.num_regions == 200
        % Schaefer 200: Add network-specific patterns
        data(1:50) = data(1:50) + 1.2;      % Visual network (stronger)
        data(51:80) = data(51:80) - 0.8;    % Somatomotor network
        data(81:120) = data(81:120) + 0.6;  % Dorsal attention
        data(121:160) = data(121:160) - 1.0; % Default mode network
        data(161:200) = data(161:200) + 0.4; % Control networks
        
    elseif atlas.num_regions == 360
        % HCP-MMP: Add more detailed regional patterns
        data(1:60) = data(1:60) + 1.5;      % Primary sensory areas
        data(61:120) = data(61:120) - 1.2;  % Motor areas
        data(121:180) = data(121:180) + 0.8; % Association areas
        data(181:240) = data(181:240) - 0.6; % Prefrontal regions
        data(241:300) = data(241:300) + 1.0; % Temporal regions
        data(301:360) = data(301:360) - 0.4; % Parietal regions
    end
    
    % Save as CSV
    csv_filename = fullfile(output_dir, sprintf('%s_test_data.csv', atlas_key));
    writematrix(data, csv_filename);
    
    % Save as MAT
    mat_filename = fullfile(output_dir, sprintf('%s_test_data.mat', atlas_key));
    brain_weights = data; %#ok<NASGU>
    save(mat_filename, 'brain_weights');
    
    fprintf('  Saved: %s\n', csv_filename);
    fprintf('  Saved: %s\n', mat_filename);
    fprintf('  Data range: %.3f to %.3f\n', min(data), max(data));
    fprintf('  Non-zero regions: %d/%d\n\n', sum(data ~= 0), length(data));
end

fprintf('✓ Test data generation completed!\n');
fprintf('Files saved in: %s\n', output_dir);

% List generated files
generated_files = dir(fullfile(output_dir, '*.*'));
generated_files = generated_files(~[generated_files.isdir]);

fprintf('\nGenerated files:\n');
for i = 1:length(generated_files)
    fprintf('  - %s\n', generated_files(i).name);
end
