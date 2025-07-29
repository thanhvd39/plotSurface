function generate_simulated_data()
% Generate simulated brain data for testing the GUI
% This creates realistic brain weight data for different atlases

fprintf('=== Generating Multi-Atlas Simulated Brain Data ===\n');

% Get available atlases
addpath(fullfile(pwd, 'utils')); % Make sure we can access atlas functions

try
    [available_atlases, atlas_info] = get_available_atlases();
    fprintf('Found %d available atlases\n', length(available_atlases));
catch ME
    warning('Could not load atlas information: %s', ME.message);
    available_atlases = {'schaefer200'};
    atlas_info = struct();
    atlas_info.schaefer200.num_regions = 200;
    atlas_info.schaefer200.name = 'Schaefer 200';
end

% Create output directory if it doesn't exist
output_dir = 'data/simulated';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Set random seed for reproducibility  
rng(42);

% Generate data for each available atlas
for atlas_idx = 1:length(available_atlases)
    atlas_key = available_atlases{atlas_idx};
    
    if isfield(atlas_info, atlas_key)
        n_regions = atlas_info.(atlas_key).num_regions;
        atlas_name = atlas_info.(atlas_key).name;
    else
        % Default fallback
        n_regions = 200;
        atlas_name = atlas_key;
    end
    
    fprintf('\n--- Generating data for %s (%d regions) ---\n', atlas_name, n_regions);
    
    % Generate different types of brain data for this atlas
    generate_atlas_data(atlas_key, n_regions, output_dir);
end

fprintf('\n=== Simulated data generation completed! ===\n');
fprintf('Data saved in: %s\n', output_dir);

end

function generate_atlas_data(atlas_key, n_regions, output_dir)
% Generate different types of simulated data for a specific atlas

% Create realistic brain weight patterns based on atlas size
if n_regions <= 100
    % Small atlas - fewer, larger networks
    network_sizes = round([n_regions*0.2, n_regions*0.25, n_regions*0.15, n_regions*0.4]);
elseif n_regions <= 200
    % Medium atlas - moderate number of networks
    network_sizes = round([n_regions*0.125, n_regions*0.15, n_regions*0.175, n_regions*0.1, n_regions*0.2, n_regions*0.15, n_regions*0.1]);
else
    % Large atlas (like HCP 360) - many networks
    network_sizes = round([n_regions*0.08, n_regions*0.1, n_regions*0.12, n_regions*0.06, n_regions*0.15, ...
                          n_regions*0.1, n_regions*0.08, n_regions*0.07, n_regions*0.09, n_regions*0.15]);
end

% Ensure network sizes sum to approximately n_regions
total_assigned = sum(network_sizes);
if total_assigned > n_regions
    % Scale down proportionally
    network_sizes = round(network_sizes * n_regions / total_assigned);
elseif total_assigned < n_regions
    % Add remaining regions to last network
    network_sizes(end) = network_sizes(end) + (n_regions - sum(network_sizes));
end

network_weights = randn(1, length(network_sizes)) * 0.8; % Random network weights
    
    % Add base network weight with some noise
    base_weight = network_weights(i);
    noise = randn(end_idx - current_idx + 1, 1) * 0.2;
    schaefer200_weights(current_idx:end_idx) = base_weight + noise;
    
    current_idx = end_idx + 1;
    if current_idx > n_regions_schaefer200
        break;
    end
end

% Save Schaefer 200 data
save(fullfile(output_dir, 'schaefer200_weights.mat'), 'schaefer200_weights');

% Also save as CSV for GUI testing
writematrix(schaefer200_weights, fullfile(output_dir, 'schaefer200_weights.csv'));

%% Generate data for different experimental conditions
fprintf('Creating different experimental conditions...\n');

% Condition 1: Age-related changes
age_weights = schaefer200_weights .* (1 + 0.3 * randn(n_regions_schaefer200, 1));
age_weights(1:50) = age_weights(1:50) + 0.5; % Frontal regions show age effects

% Condition 2: Gender differences  
gender_weights = schaefer200_weights .* (1 + 0.2 * randn(n_regions_schaefer200, 1));
gender_weights(51:100) = gender_weights(51:100) - 0.4; % Some regions show gender differences

% Condition 3: Disease effects (AD vs controls)
disease_weights = schaefer200_weights .* (1 + 0.4 * randn(n_regions_schaefer200, 1));
disease_weights(101:150) = disease_weights(101:150) - 0.8; % Disease-affected regions

% Save experimental conditions
save(fullfile(output_dir, 'age_related_weights.mat'), 'age_weights');
save(fullfile(output_dir, 'gender_diff_weights.mat'), 'gender_weights');
save(fullfile(output_dir, 'disease_weights.mat'), 'disease_weights');

writematrix(age_weights, fullfile(output_dir, 'age_related_weights.csv'));
writematrix(gender_weights, fullfile(output_dir, 'gender_diff_weights.csv'));
writematrix(disease_weights, fullfile(output_dir, 'disease_weights.csv'));

%% Generate multi-column data (for time series or multiple subjects)
fprintf('Creating multi-subject/time-series data...\n');

n_subjects = 10;
multi_subject_data = zeros(n_regions_schaefer200, n_subjects);

for subj = 1:n_subjects
    % Each subject has the base pattern plus individual variation
    individual_variation = randn(n_regions_schaefer200, 1) * 0.3;
    multi_subject_data(:, subj) = schaefer200_weights + individual_variation;
end

save(fullfile(output_dir, 'multi_subject_weights.mat'), 'multi_subject_data');
writematrix(multi_subject_data, fullfile(output_dir, 'multi_subject_weights.csv'));

%% Generate data with realistic value ranges
fprintf('Creating realistic value range data...\n');

% T-statistics (typical range: -5 to 5)
t_stats = schaefer200_weights * 2; % Scale to realistic t-stat range
t_stats = max(-5, min(5, t_stats)); % Clamp to reasonable range

% Z-scores (typical range: -3 to 3) 
z_scores = schaefer200_weights * 1.5;
z_scores = max(-3, min(3, z_scores));

% Effect sizes (Cohen's d, typical range: -2 to 2)
effect_sizes = schaefer200_weights * 0.8;
effect_sizes = max(-2, min(2, effect_sizes));

% Save realistic range data
save(fullfile(output_dir, 'tstatistics_weights.mat'), 't_stats');
save(fullfile(output_dir, 'zscores_weights.mat'), 'z_scores'); 
save(fullfile(output_dir, 'effect_sizes_weights.mat'), 'effect_sizes');

writematrix(t_stats, fullfile(output_dir, 'tstatistics_weights.csv'));
writematrix(z_scores, fullfile(output_dir, 'zscores_weights.csv'));
writematrix(effect_sizes, fullfile(output_dir, 'effect_sizes_weights.csv'));

%% Generate sparse data (many zeros, some significant values)
fprintf('Creating sparse activation data...\n');

sparse_weights = zeros(n_regions_schaefer200, 1);
% Only 30% of regions have non-zero values
active_regions = randperm(n_regions_schaefer200, round(0.3 * n_regions_schaefer200));
sparse_weights(active_regions) = randn(length(active_regions), 1) * 1.5;

save(fullfile(output_dir, 'sparse_activation_weights.mat'), 'sparse_weights');
writematrix(sparse_weights, fullfile(output_dir, 'sparse_activation_weights.csv'));

%% Create a comprehensive test dataset summary
fprintf('Creating dataset summary...\n');

summary_info = struct();
summary_info.description = 'Simulated brain data for GUI testing';
summary_info.atlas = 'Schaefer 200 parcellation';
summary_info.n_regions = n_regions_schaefer200;
summary_info.datasets = {
    'schaefer200_weights - Basic network pattern'
    'age_related_weights - Age-related changes'
    'gender_diff_weights - Gender differences'
    'disease_weights - Disease effects'
    'multi_subject_weights - Multiple subjects (10 subjects)'
    'tstatistics_weights - T-statistics range'
    'zscores_weights - Z-scores range'
    'effect_sizes_weights - Effect sizes (Cohen''s d)'
    'sparse_activation_weights - Sparse activation pattern'
};

summary_info.value_ranges = struct();
summary_info.value_ranges.schaefer200 = [min(schaefer200_weights), max(schaefer200_weights)];
summary_info.value_ranges.age_related = [min(age_weights), max(age_weights)];
summary_info.value_ranges.gender_diff = [min(gender_weights), max(gender_weights)];
summary_info.value_ranges.disease = [min(disease_weights), max(disease_weights)];
summary_info.value_ranges.t_stats = [min(t_stats), max(t_stats)];
summary_info.value_ranges.z_scores = [min(z_scores), max(z_scores)];
summary_info.value_ranges.effect_sizes = [min(effect_sizes), max(effect_sizes)];
summary_info.value_ranges.sparse = [min(sparse_weights), max(sparse_weights)];

save(fullfile(output_dir, 'dataset_summary.mat'), 'summary_info');

% Create a README file
readme_content = {
    'Simulated Brain Data for GUI Testing'
    '===================================='
    ''
    'This directory contains simulated brain weight data for testing the Brain Surface Plot GUI.'
    'All data is generated for the Schaefer 200 parcellation (200 brain regions).'
    ''
    'Files:'
    '------'
    'schaefer200_weights.* - Basic simulated brain network pattern'
    'age_related_weights.* - Simulated age-related brain changes'
    'gender_diff_weights.* - Simulated gender differences in brain structure'
    'disease_weights.* - Simulated disease effects (e.g., Alzheimer''s)'
    'multi_subject_weights.* - Multi-subject data (200 regions x 10 subjects)'
    'tstatistics_weights.* - Data scaled to typical t-statistic ranges (-5 to 5)'
    'zscores_weights.* - Data scaled to z-score ranges (-3 to 3)'
    'effect_sizes_weights.* - Data scaled to effect size ranges (-2 to 2)'
    'sparse_activation_weights.* - Sparse activation pattern (70% zeros)'
    ''
    'File formats:'
    '- .mat files: MATLAB format, can be loaded directly in GUI'
    '- .csv files: Comma-separated values, compatible with most software'
    ''
    'Usage in GUI:'
    '1. Start the GUI: launch_gui()'
    '2. Click "Browse Weight File" and select any .mat or .csv file'
    '3. Choose visualization options and click "Generate Plot"'
};

% Write README
fid = fopen(fullfile(output_dir, 'README.txt'), 'w');
for i = 1:length(readme_content)
    fprintf(fid, '%s\n', readme_content{i});
end
fclose(fid);

fprintf('Simulated data generation complete!\n');
fprintf('Data saved in: %s\n', output_dir);
fprintf('Files created:\n');
files = dir(fullfile(output_dir, '*.*'));
for i = 1:length(files)
    if ~files(i).isdir && ~strcmp(files(i).name(1), '.')
        fprintf('  - %s\n', files(i).name);
    end
end

end
