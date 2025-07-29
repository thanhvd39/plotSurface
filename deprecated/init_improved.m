function init_improved()
% Improved initialization script for brain surface plotting
% This script sets up the environment and checks for dependencies

    fprintf('Initializing brain surface plotting environment...\n');
    
    % Get current directory
    current_dir = fileparts(mfilename('fullpath'));
    
    % Add subfolders to path
    paths_to_add = {
        fullfile(current_dir, 'functions'),
        fullfile(current_dir, 'utils'),
        fullfile(current_dir, '..', 'data'),
        fullfile(current_dir, '..', 'scripts')
    };
    
    for i = 1:length(paths_to_add)
        if exist(paths_to_add{i}, 'dir')
            addpath(genpath(paths_to_add{i}));
            fprintf('Added to path: %s\n', paths_to_add{i});
        else
            fprintf('Warning: Directory not found: %s\n', paths_to_add{i});
        end
    end
    
    % Check for required MATLAB toolboxes
    check_toolboxes();
    
    % Check for required data files
    check_data_files();
    
    % Check for required functions
    check_functions();
    
    % Set default figure properties for better visualization
    set_default_figure_properties();
    
    fprintf('Initialization complete!\n');
    fprintf('\nUsage options:\n');
    fprintf('1. GUI interface: run launch_gui()\n');
    fprintf('2. Command line: use plot_brain_from_brain_weight_improved()\n');
    fprintf('3. Original interface: use plot_brain_from_brain_weight()\n\n');
end

function check_toolboxes()
    % Check for required MATLAB toolboxes
    
    fprintf('\nChecking MATLAB toolboxes...\n');
    
    required_toolboxes = {
        'Statistics and Machine Learning Toolbox',
        'Image Processing Toolbox'
    };
    
    for i = 1:length(required_toolboxes)
        if license('test', get_toolbox_license_name(required_toolboxes{i}))
            fprintf('✓ %s: Available\n', required_toolboxes{i});
        else
            fprintf('✗ %s: Not available (some features may not work)\n', required_toolboxes{i});
        end
    end
end

function license_name = get_toolbox_license_name(toolbox_name)
    % Convert toolbox display name to license name
    
    switch toolbox_name
        case 'Statistics and Machine Learning Toolbox'
            license_name = 'statistics_toolbox';
        case 'Image Processing Toolbox'
            license_name = 'image_toolbox';
        otherwise
            license_name = '';
    end
end

function check_data_files()
    % Check for required data files
    
    fprintf('\nChecking data files...\n');
    
    required_files = {
        '../data/mySurface_data.mat',
        '../data/lh.Schaefer2018_200Parcels_7Networks_order.annot',
        '../data/rh.Schaefer2018_200Parcels_7Networks_order.annot',
        '../data/lh.inflated.freesurfer.gii',
        '../data/rh.inflated.freesurfer.gii'
    };
    
    optional_files = {
        '../data/lh.HCPMMP1.annot',
        '../data/rh.HCPMMP1.annot',
        '../data/example_data.mat'
    };
    
    % Check required files
    all_required_present = true;
    for i = 1:length(required_files)
        if exist(required_files{i}, 'file')
            fprintf('✓ %s\n', required_files{i});
        else
            fprintf('✗ %s (REQUIRED)\n', required_files{i});
            all_required_present = false;
        end
    end
    
    % Check optional files
    fprintf('\nOptional files:\n');
    for i = 1:length(optional_files)
        if exist(optional_files{i}, 'file')
            fprintf('✓ %s\n', optional_files{i});
        else
            fprintf('- %s (optional)\n', optional_files{i});
        end
    end
    
    if ~all_required_present
        fprintf('\n⚠️  Warning: Some required files are missing!\n');
        fprintf('Please ensure all data files are in the ../data/ directory.\n');
    end
end

function check_functions()
    % Check for required custom functions
    
    fprintf('\nChecking custom functions...\n');
    
    required_functions = {
        'plotSurfaceROIBoundary',
        'convertCorticalThickness2VertexData',
        'invalidateNonSurfaceRegions',
        'MyExampleSurfacePlotFunction',
        'read_annotation'
    };
    
    for i = 1:length(required_functions)
        if exist(required_functions{i}, 'file')
            fprintf('✓ %s\n', required_functions{i});
        else
            fprintf('✗ %s (check functions directory)\n', required_functions{i});
        end
    end
end

function set_default_figure_properties()
    % Set default figure properties for better visualization
    
    % Set default figure properties
    set(groot, 'defaultFigureColor', 'white');
    set(groot, 'defaultAxesColor', 'none');
    set(groot, 'defaultAxesFontSize', 12);
    set(groot, 'defaultTextFontSize', 12);
    set(groot, 'defaultAxesLineWidth', 1);
    
    % Set default colormap
    set(groot, 'defaultFigureColormap', jet(64));
    
    fprintf('\n✓ Default figure properties configured\n');
end

% Additional utility functions
function create_output_directory()
    % Create output directory if it doesn't exist
    
    output_dir = '../output';
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
        fprintf('Created output directory: %s\n', output_dir);
    end
end

function version_info = get_version_info()
    % Get version information about the plotting system
    
    version_info = struct();
    version_info.matlab_version = version;
    version_info.plotting_system_version = '2.0';
    version_info.last_updated = '2024';
    
    fprintf('\n=== Version Information ===\n');
    fprintf('MATLAB Version: %s\n', version_info.matlab_version);
    fprintf('Brain Plotting System Version: %s\n', version_info.plotting_system_version);
    fprintf('Last Updated: %s\n', version_info.last_updated);
end
