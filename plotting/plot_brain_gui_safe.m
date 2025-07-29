function plot_brain_gui_safe(csv_file_path, image_name)
% GUI-Safe Brain plotting function
% This version is specifically designed to work with the organized file structure
% 
% Usage:
%   plot_brain_gui_safe('/path/to/your/data.csv', 'your_image_name')

if nargin < 1
    error('Please provide CSV file path');
end
if nargin < 2
    image_name = 'brain_plot';
end

fprintf('=== GUI-Safe Brain Plotting (Organized Structure) ===\n');
fprintf('File: %s\n', csv_file_path);
fprintf('Image name: %s\n\n', image_name);

try
    %% Setup with organized paths
    fprintf('1. Initializing environment...\n');
    current_dir = pwd;
    addpath(fullfile(current_dir, 'plotting'));
    addpath(fullfile(current_dir, 'utils'));
    addpath(fullfile(current_dir, 'data'));

    % Create output directory
    output_dir = fullfile(current_dir, 'output', 'gui_plots');
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    %% Load and process data
    fprintf('2. Loading CSV data...\n');
    if ~exist(csv_file_path, 'file')
        error('CSV file not found: %s', csv_file_path);
    end

    % Read data
    data = readmatrix(csv_file_path);

    fprintf('   Data shape: %dx%d\n', size(data, 1), size(data, 2));
    fprintf('   Data range: %.4f to %.4f\n', min(data(:)), max(data(:)));

    % Ensure we have a column vector
    if size(data, 1) == 1
        data = data';
    end
    
    % Use first column if multiple columns
    if size(data, 2) > 1
        data = data(:, 1);
        fprintf('   Using first column only\n');
    end

    %% Setup visualization parameters
    fprintf('3. Setting up visualization...\n');
    color_map = flipud(jet(64));

    %% Call main plotting function (GUI-safe)
    fprintf('4. Generating brain surface plot...\n');
    
    % Check if main plotting function exists
    if exist('plot_brain_from_brain_weight', 'file')
        % Call the main plotting function - this creates separate figure windows
        plot_brain_from_brain_weight("weight", data, "colormap", color_map, ...
                                    "min", -1, "max", 1, "name", image_name);
        
        % Files are automatically saved by the function
        fprintf('   Brain plots generated successfully!\n');
        fprintf('   Files saved with prefix: %s\n', image_name);
        
        % List generated files
        output_files = dir(fullfile(pwd, [image_name '*.png']));
        svg_files = dir(fullfile(pwd, [image_name '*.svg']));
        
        if ~isempty(output_files) || ~isempty(svg_files)
            fprintf('   Generated files:\n');
            for i = 1:length(output_files)
                fprintf('     - %s\n', output_files(i).name);
            end
            for i = 1:length(svg_files)
                fprintf('     - %s\n', svg_files(i).name);
            end
        end
        
    else
        error('plot_brain_from_brain_weight function not found in plotting/ directory');
    end
    
    fprintf('\n=== Brain plotting completed successfully! ===\n');
    
catch ME
    fprintf('ERROR in brain plotting: %s\n', ME.message);
    fprintf('Stack trace:\n');
    for i = 1:length(ME.stack)
        fprintf('  %s:%d in %s\n', ME.stack(i).file, ME.stack(i).line, ME.stack(i).name);
    end
    rethrow(ME);
end

end
