function generate_simulated_data_multi_atlas()
% Generate simulated brain data for testing the GUI
% This creates realistic brain weight data for different atlases

fprintf('=== Generating Multi-Atlas Simulated Brain Data ===\n');

% Get available atlases
addpath(fullfile(pwd, 'utils')); % Make sure we can access atlas functions

try
    [available_atlases, atlas_info] = get_available_atlases();
    fprintf('Found %d available atlases\n', length(available_atlases));
catch ME
    warning('AtlasLoader:Failed', 'Could not load atlas information: %s', ME.message);
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

fprintf('  Creating data for %s atlas (%d regions)...\n', atlas_key, n_regions);

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

%% Generate basic network pattern
basic_weights = zeros(n_regions, 1);
current_idx = 1;

for network_idx = 1:length(network_sizes)
    end_idx = min(current_idx + network_sizes(network_idx) - 1, n_regions);
    
    % Add base network weight with some noise
    base_weight = network_weights(network_idx);
    noise = randn(end_idx - current_idx + 1, 1) * 0.2;
    basic_weights(current_idx:end_idx) = base_weight + noise;
    
    current_idx = end_idx + 1;
    if current_idx > n_regions
        break;
    end
end

% Save basic pattern
filename_base = sprintf('%s_basic', atlas_key);
save(fullfile(output_dir, [filename_base '.mat']), 'basic_weights');
writematrix(basic_weights, fullfile(output_dir, [filename_base '.csv']));

%% Generate age-related pattern
age_weights = basic_weights + randn(n_regions, 1) * 0.3;
% Add age-related decline in frontal regions (first 20% of regions)
frontal_regions = 1:round(n_regions * 0.2);
age_weights(frontal_regions) = age_weights(frontal_regions) - 0.5;

filename_age = sprintf('%s_age_related', atlas_key);
save(fullfile(output_dir, [filename_age '.mat']), 'age_weights');
writematrix(age_weights, fullfile(output_dir, [filename_age '.csv']));

%% Generate disease pattern (e.g., Alzheimer's)
disease_weights = basic_weights;
% Add disease effects - reduced activity in memory regions (middle regions)
memory_regions = round(n_regions*0.3):round(n_regions*0.7);
disease_weights(memory_regions) = disease_weights(memory_regions) - randn(length(memory_regions), 1) * 0.8;

filename_disease = sprintf('%s_disease', atlas_key);
save(fullfile(output_dir, [filename_disease '.mat']), 'disease_weights');
writematrix(disease_weights, fullfile(output_dir, [filename_disease '.csv']));

%% Generate gender difference pattern
male_weights = basic_weights + randn(n_regions, 1) * 0.2;
female_weights = basic_weights + randn(n_regions, 1) * 0.2;
% Add gender-specific patterns
male_weights(1:round(n_regions*0.1)) = male_weights(1:round(n_regions*0.1)) + 0.4; % Higher in some regions
female_weights(round(n_regions*0.6):round(n_regions*0.8)) = female_weights(round(n_regions*0.6):round(n_regions*0.8)) + 0.3;

filename_male = sprintf('%s_male', atlas_key);
filename_female = sprintf('%s_female', atlas_key);
save(fullfile(output_dir, [filename_male '.mat']), 'male_weights');
save(fullfile(output_dir, [filename_female '.mat']), 'female_weights');
writematrix(male_weights, fullfile(output_dir, [filename_male '.csv']));
writematrix(female_weights, fullfile(output_dir, [filename_female '.csv']));

%% Generate statistical maps (t-statistics, z-scores, effect sizes)
% T-statistics (typically range -5 to 5)
t_stats = randn(n_regions, 1) * 2;
t_stats(t_stats > 5) = 5;
t_stats(t_stats < -5) = -5;

filename_tstat = sprintf('%s_tstatistics', atlas_key);
save(fullfile(output_dir, [filename_tstat '.mat']), 't_stats');
writematrix(t_stats, fullfile(output_dir, [filename_tstat '.csv']));

% Z-scores (typically range -3 to 3)
z_scores = randn(n_regions, 1) * 1.5;
z_scores(z_scores > 3) = 3;
z_scores(z_scores < -3) = -3;

filename_zscore = sprintf('%s_zscores', atlas_key);
save(fullfile(output_dir, [filename_zscore '.mat']), 'z_scores');
writematrix(z_scores, fullfile(output_dir, [filename_zscore '.csv']));

% Effect sizes (Cohen's d)
effect_sizes = randn(n_regions, 1) * 0.8;

filename_effect = sprintf('%s_effect_sizes', atlas_key);
save(fullfile(output_dir, [filename_effect '.mat']), 'effect_sizes');
writematrix(effect_sizes, fullfile(output_dir, [filename_effect '.csv']));

%% Generate sparse activation pattern
sparse_weights = zeros(n_regions, 1);
% Only activate 30% of regions
active_regions = randperm(n_regions, round(n_regions * 0.3));
sparse_weights(active_regions) = randn(length(active_regions), 1) * 1.2;

filename_sparse = sprintf('%s_sparse_activation', atlas_key);
save(fullfile(output_dir, [filename_sparse '.mat']), 'sparse_weights');
writematrix(sparse_weights, fullfile(output_dir, [filename_sparse '.csv']));

fprintf('  ✓ Generated 8 different datasets for %s\n', atlas_key);

end
