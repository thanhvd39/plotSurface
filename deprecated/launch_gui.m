function launch_gui()
% Launch the Brain Surface Plot GUI
% This is the main entry point for the improved brain plotting system

    fprintf('Initializing Brain Surface Plot GUI...\n');
    
    % Add necessary paths
    current_dir = fileparts(mfilename('fullpath'));
    addpath(genpath(fullfile(current_dir, 'functions')));
    addpath(genpath(fullfile(current_dir, 'utils')));
    addpath(genpath(fullfile(current_dir, '..', 'data')));
    
    % Check for required files
    required_files = {
        '../data/mySurface_data.mat',
        '../data/lh.Schaefer2018_200Parcels_7Networks_order.annot',
        '../data/rh.Schaefer2018_200Parcels_7Networks_order.annot'
    };
    
    missing_files = {};
    for i = 1:length(required_files)
        if ~exist(required_files{i}, 'file')
            missing_files{end+1} = required_files{i};
        end
    end
    
    if ~isempty(missing_files)
        fprintf('Warning: Missing required files:\n');
        for i = 1:length(missing_files)
            fprintf('  - %s\n', missing_files{i});
        end
        fprintf('Please ensure all data files are in the correct location.\n');
    end
    
    % Launch the GUI
    try
        BrainSurfacePlotGUI();
        fprintf('GUI launched successfully!\n');
        fprintf('Usage instructions:\n');
        fprintf('1. Load your weight data (CSV or MAT file)\n');
        fprintf('2. Select atlas and visualization options\n');
        fprintf('3. Click "Generate Plot" to create brain surface visualization\n');
        fprintf('4. Use "Save Figures" to export results\n');
    catch ME
        fprintf('Error launching GUI: %s\n', ME.message);
        fprintf('Falling back to command-line interface...\n');
        demo_command_line_usage();
    end
end

function demo_command_line_usage()
    % Demonstrate command-line usage of the improved plotting function
    
    fprintf('\n=== Command-Line Usage Example ===\n');
    fprintf('% Load example data\n');
    fprintf('data = load(''../data/example_data.mat'');\n');
    fprintf('weight_data = data.weight_vector; %% Assuming 200x1 vector for Schaefer atlas\n\n');
    
    fprintf('%% Basic usage\n');
    fprintf('plot_brain_from_brain_weight_improved(''weight'', weight_data, ...\n');
    fprintf('    ''name'', ''my_brain_plot'', ...\n');
    fprintf('    ''dir'', ''./output'');\n\n');
    
    fprintf('%% Advanced usage with custom options\n');
    fprintf('plot_brain_from_brain_weight_improved(''weight'', weight_data, ...\n');
    fprintf('    ''name'', ''advanced_plot'', ...\n');
    fprintf('    ''dir'', ''./output'', ...\n');
    fprintf('    ''colormap'', ''viridis'', ...\n');
    fprintf('    ''atlas'', ''schaefer200'', ...\n');
    fprintf('    ''hemisphere'', ''both'', ...\n');
    fprintf('    ''views'', {{''lateral'', ''medial'', ''dorsal''}}, ...\n');
    fprintf('    ''threshold'', 0.1, ...\n');
    fprintf('    ''formats'', {{''png'', ''svg'', ''pdf''}}, ...\n');
    fprintf('    ''dpi'', 300, ...\n');
    fprintf('    ''show_colorbar'', true, ...\n');
    fprintf('    ''verbose'', true);\n\n');
    
    % Try to run a demo if example data exists
    if exist('../data/example_data.mat', 'file')
        fprintf('Running demo with example data...\n');
        try
            run_demo();
        catch ME
            fprintf('Demo failed: %s\n', ME.message);
        end
    else
        fprintf('Example data not found. Creating synthetic demo...\n');
        run_synthetic_demo();
    end
end

function run_demo()
    % Run demo with actual example data
    data = load('../data/example_data.mat');
    fields = fieldnames(data);
    weight_data = data.(fields{1});
    
    % Ensure proper size for Schaefer 200 atlas
    if length(weight_data) ~= 200
        if size(weight_data, 1) == 200
            weight_data = weight_data(:, 1);
        elseif size(weight_data, 2) == 200
            weight_data = weight_data(1, :)';
        else
            error('Data does not match Schaefer 200 atlas (expected 200 regions)');
        end
    end
    
    % Create output directory
    output_dir = '../output/demo';
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end
    
    % Run the improved plotting function
    plot_brain_from_brain_weight_improved('weight', weight_data, ...
        'name', 'demo_plot', ...
        'dir', output_dir, ...
        'colormap', 'viridis', ...
        'formats', {'png'}, ...
        'verbose', true);
    
    fprintf('Demo completed! Check %s for output files.\n', output_dir);
end

function run_synthetic_demo()
    % Run demo with synthetic data
    
    % Create synthetic brain data (200 regions for Schaefer atlas)
    rng(42); % For reproducibility
    weight_data = randn(200, 1) * 0.5;
    
    % Add some structure to make it more interesting
    weight_data(1:50) = weight_data(1:50) + 1;    % Positive values in first 50 regions
    weight_data(51:100) = weight_data(51:100) - 1; % Negative values in next 50 regions
    weight_data(101:end) = weight_data(101:end) * 0.2; % Smaller values in remaining regions
    
    % Create output directory
    output_dir = '../output/synthetic_demo';
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end
    
    fprintf('Using synthetic data (200 regions)...\n');
    
    try
        % Run the improved plotting function
        plot_brain_from_brain_weight_improved('weight', weight_data, ...
            'name', 'synthetic_demo', ...
            'dir', output_dir, ...
            'colormap', 'diverging', ...
            'formats', {'png'}, ...
            'auto_range', true, ...
            'verbose', true);
        
        fprintf('Synthetic demo completed! Check %s for output files.\n', output_dir);
    catch ME
        fprintf('Synthetic demo failed: %s\n', ME.message);
        fprintf('This might be due to missing surface data files.\n');
    end
end
