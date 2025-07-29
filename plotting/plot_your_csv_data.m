function plot_your_csv_data(csv_file_path, image_name)
% Plot brain data from CSV file - exactly like your example
% 
% Usage:
%   plot_your_csv_data('/path/to/your/data.csv', 'your_image_name')
%
% Example:
%   plot_your_csv_data('/Users/tth/Thanh/rePLS/rePLS-figures/figures/figure4/4a/mean_P.csv', 'group4_cortical_thickness')

if nargin < 1
    error('Please provide CSV file path');
end
if nargin < 2
    image_name = 'brain_plot';
end

clc;

fprintf('=== Plotting Brain Data from CSV ===\n');
fprintf('File: %s\n', csv_file_path);
fprintf('Image name: %s\n\n', image_name);

%% Setup (organized structure)
fprintf('1. Initializing environment...\n');
current_dir = pwd;
addpath(fullfile(current_dir, 'plotting'));
addpath(fullfile(current_dir, 'utils'));
addpath(fullfile(current_dir, 'data'));

% Create output directory
output_dir = fullfile(current_dir, 'output', 'csv_plots');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

%% Load and process data (exactly like your example)
fprintf('2. Loading CSV data...\n');
if ~exist(csv_file_path, 'file')
    error('CSV file not found: %s', csv_file_path);
end

% Read data exactly like your code
data = readtable(csv_file_path);
data = table2array(data);

fprintf('   Data shape: %dx%d\n', size(data, 1), size(data, 2));
fprintf('   Data range: %.4f to %.4f\n', min(data(:)), max(data(:)));

%% Setup visualization parameters (exactly like your example)
fprintf('3. Setting up visualization...\n');
color_map = jet(64);
color_map = flipud(color_map);  % Flip like your example

%% Generate brain plot (exactly like your code)
fprintf('4. Generating brain surface plot...\n');
try
    % Call the exact function with exact parameters like your example
    plot_brain_from_brain_weight("weight", data, ...
        "name", image_name, ...
        "colormap", color_map, ...
        "dir", output_dir);
    
    fprintf('   ✓ Brain plot generated successfully!\n');
    
catch ME
    fprintf('   ✗ Error: %s\n', ME.message);
    fprintf('   This might be due to:\n');
    fprintf('   - Wrong data format (should be 200x1 for Schaefer atlas)\n');
    fprintf('   - Missing surface data files\n');
    fprintf('   - Data values out of expected range\n');
    return;
end

%% Display results
fprintf('\n5. Results:\n');
fprintf('   Output directory: %s\n', output_dir);

% List generated files
output_files = dir(fullfile(output_dir, [image_name '*']));
if ~isempty(output_files)
    fprintf('   Generated files:\n');
    for i = 1:length(output_files)
        fprintf('     - %s\n', output_files(i).name);
    end
else
    fprintf('   No output files found.\n');
end

fprintf('\n=== Complete! ===\n');
fprintf('Your brain surface plots have been generated.\n');
fprintf('Check: %s\n', output_dir);

end
