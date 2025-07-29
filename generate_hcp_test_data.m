% Generate test data for HCP MMP atlas (360 regions)
% This creates realistic brain activation patterns for the 360-region HCP atlas

fprintf('Generating HCP MMP atlas test data (360 regions)...\n');

% Set random seed for reproducibility
rng(42);

% Generate 360 region data
n_regions = 360;

% Create different test datasets
datasets = struct();

%% 1. HCP Default Mode Network pattern
datasets.hcp_dmn = struct();
datasets.hcp_dmn.name = 'HCP Default Mode Network';
datasets.hcp_dmn.data = randn(n_regions, 1) * 0.3;

% Simulate DMN regions (approximate HCP regions)
dmn_regions = [1:20, 181:200, 50:70, 230:250, 100:120, 280:300];
datasets.hcp_dmn.data(dmn_regions) = datasets.hcp_dmn.data(dmn_regions) + 1.5;

% Add some anti-correlated regions (task-positive network)
task_regions = [30:45, 210:225, 80:95, 260:275];
datasets.hcp_dmn.data(task_regions) = datasets.hcp_dmn.data(task_regions) - 1.2;

%% 2. HCP Motor Network pattern  
datasets.hcp_motor = struct();
datasets.hcp_motor.name = 'HCP Motor Network';
datasets.hcp_motor.data = randn(n_regions, 1) * 0.2;

% Motor regions
motor_regions = [25:35, 205:215, 60:75, 240:255];
datasets.hcp_motor.data(motor_regions) = datasets.hcp_motor.data(motor_regions) + 2.0;

%% 3. HCP Visual Network pattern
datasets.hcp_visual = struct();
datasets.hcp_visual.name = 'HCP Visual Network';
datasets.hcp_visual.data = randn(n_regions, 1) * 0.25;

% Visual regions (posterior)
visual_regions = [150:180, 330:360, 120:140, 300:320];
datasets.hcp_visual.data(visual_regions) = datasets.hcp_visual.data(visual_regions) + 1.8;

%% 4. HCP Disease pattern (Alzheimer's-like)
datasets.hcp_disease = struct();
datasets.hcp_disease.name = 'HCP Disease Pattern';
datasets.hcp_disease.data = randn(n_regions, 1) * 0.4;

% Disease affects temporal and parietal regions
disease_regions = [40:60, 220:240, 90:110, 270:290, 130:150, 310:330];
datasets.hcp_disease.data(disease_regions) = datasets.hcp_disease.data(disease_regions) - 1.5;

%% 5. HCP Multi-subject pattern
datasets.hcp_multisubject = struct();
datasets.hcp_multisubject.name = 'HCP Multi-subject';
n_subjects = 10;
datasets.hcp_multisubject.data = randn(n_regions, n_subjects);

% Add subject-specific patterns
for subj = 1:n_subjects
    % Random regions active for each subject
    active_regions = randperm(n_regions, round(n_regions * 0.3));
    datasets.hcp_multisubject.data(active_regions, subj) = ...
        datasets.hcp_multisubject.data(active_regions, subj) + 1.0 + randn(1) * 0.3;
end

%% Save all datasets
output_dir = fullfile(pwd, 'data', 'simulated');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

dataset_names = fieldnames(datasets);
fprintf('Saving %d HCP atlas datasets to %s:\n', length(dataset_names), output_dir);

for i = 1:length(dataset_names)
    dataset_key = dataset_names{i};
    dataset = datasets.(dataset_key);
    
    % Save as CSV
    csv_filename = fullfile(output_dir, [dataset_key '_360regions.csv']);
    writematrix(dataset.data, csv_filename);
    
    % Save as MAT
    mat_filename = fullfile(output_dir, [dataset_key '_360regions.mat']);
    brain_weights = dataset.data;
    save(mat_filename, 'brain_weights', '-v7.3');
    
    fprintf('  ✓ %s: %s\n', dataset.name, [dataset_key '_360regions.csv']);
    fprintf('    Size: %dx%d, Range: %.3f to %.3f\n', ...
            size(dataset.data, 1), size(dataset.data, 2), ...
            min(dataset.data(:)), max(dataset.data(:)));
end

fprintf('\nHCP atlas test data generation complete! 🧠\n');
fprintf('These datasets are designed for the HCP Multi-Modal Parcellation (360 regions)\n');
fprintf('\nTo use with GUI:\n');
fprintf('1. Launch GUI: launch_brain_gui()\n');
fprintf('2. Select "HCP Multi-Modal Parcellation" from atlas dropdown\n');
fprintf('3. Browse and load one of the *_360regions.csv files\n');
fprintf('4. Click "PLOT BRAIN SURFACE"\n');
