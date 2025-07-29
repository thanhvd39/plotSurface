function launch_brain_gui()
% Brain Surface Plot GUI - Fixed Version
% This version includes fixes for:
% - Colormap selection functionality 
% - Path handling for output files
% - Complete plotting function integration

fprintf('\n');
fprintf('========================================\n');
fprintf('  Brain Surface Plotting System v2.0\n');
fprintf('========================================\n');
fprintf('\n');

try
    % Setup paths for organized structure
    current_dir = pwd;
    
    % Add organized paths
    addpath(fullfile(current_dir, 'main'));
    addpath(fullfile(current_dir, 'plotting'));  
    addpath(fullfile(current_dir, 'utils'));
    addpath(fullfile(current_dir, 'data'));
    
    fprintf('Setting up organized file structure...\n');
    fprintf('  ✓ Main GUI files: main/\n');
    fprintf('  ✓ Plotting functions: plotting/\n');
    fprintf('  ✓ Utilities: utils/\n');
    fprintf('  ✓ Data: data/\n');
    
    % Check MATLAB version
    matlab_version = version('-release');
    year = str2double(matlab_version(1:4));
    if year < 2014
        warning('This GUI requires MATLAB R2014b or later. Some features may not work properly.');
    end
    
    % Create required directories
    required_dirs = {'data', 'output', 'output/gui_plots', 'output/csv_plots'};
    for i = 1:length(required_dirs)
        dir_path = fullfile(current_dir, required_dirs{i});
        if ~exist(dir_path, 'dir')
            fprintf('  Creating directory: %s\n', required_dirs{i});
            mkdir(dir_path);
        end
    end
    
    % Check for key files
    fprintf('\nChecking system components...\n');
    
    key_files = {
        fullfile(current_dir, 'plotting', 'plot_brain_from_brain_weight.m'),
        fullfile(current_dir, 'plotting', 'MyExampleSurfacePlotFunction.m'),
        fullfile(current_dir, 'utils', 'read_annotation.m'),
        fullfile(current_dir, 'main', 'BrainGUI_Simple.m')
    };
    
    file_status = {'Core plotting function', 'Surface plot function', 'Annotation reader', 'Main GUI'};
    all_files_ok = true;
    
    for i = 1:length(key_files)
        if exist(key_files{i}, 'file')
            fprintf('  ✓ %s\n', file_status{i});
        else
            fprintf('  ✗ %s (MISSING)\n', file_status{i});
            all_files_ok = false;
        end
    end
    
    % Check for data files
    data_files = {
        fullfile(current_dir, 'data', 'mySurface_data.mat'),
        fullfile(current_dir, 'data', 'lh.Schaefer2018_200Parcels_7Networks_order.annot'),
        fullfile(current_dir, 'data', 'rh.Schaefer2018_200Parcels_7Networks_order.annot')
    };
    
    data_ok = true;
    for i = 1:length(data_files)
        if ~exist(data_files{i}, 'file')
            data_ok = false;
            break;
        end
    end
    
    if data_ok
        fprintf('  ✓ Brain surface data files\n');
    else
        fprintf('  ⚠ Brain surface data files (some missing - basic plots still work)\n');
    end
    
    if ~all_files_ok
        error('Critical files are missing. Please check the file organization.');
    end
    
    fprintf('\nLaunching Brain Surface Plot GUI...\n\n');
    
    % Launch the main GUI
    BrainGUI_Simple();
    
    fprintf('========================================\n');
    fprintf('              Quick Start\n');
    fprintf('========================================\n');
    fprintf('\n');
    fprintf('1. Generate test data:\n');
    fprintf('   → Click "Generate Test Data" button\n');
    fprintf('\n');
    fprintf('2. Or load your data:\n');
    fprintf('   → Click "Browse CSV File" button\n');
    fprintf('   → Select file with 200 brain region weights\n');
    fprintf('\n');
    fprintf('3. Plot brain surface:\n');
    fprintf('   → Click "PLOT BRAIN SURFACE" button\n');
    fprintf('   → Plots will appear in separate windows\n');
    fprintf('\n');
    fprintf('4. Save results:\n');
    fprintf('   → Click "Save Figures" to export plots\n');
    fprintf('   → Files saved in output/ directory\n');
    fprintf('\n');
    
    % Show available test data
    sim_dir = fullfile(current_dir, 'data', 'simulated');
    if exist(sim_dir, 'dir')
        sim_files = dir(fullfile(sim_dir, '*.csv'));
        if ~isempty(sim_files)
            fprintf('Available test datasets:\n');
            for i = 1:min(3, length(sim_files))
                fprintf('   • %s\n', sim_files(i).name);
            end
            if length(sim_files) > 3
                fprintf('   ... and %d more files\n', length(sim_files) - 3);
            end
            fprintf('\n');
        end
    end
    
    fprintf('GUI ready! 🧠✨\n');
    fprintf('========================================\n');
    
catch ME
    fprintf('\n❌ Error launching GUI:\n');
    fprintf('   %s\n', ME.message);
    fprintf('\nTroubleshooting:\n');
    fprintf('1. Ensure you are in the plotSurface directory\n');
    fprintf('2. Check that all files are properly organized\n');
    fprintf('3. Try: addpath(genpath(pwd))\n');
    fprintf('4. Restart MATLAB if problems persist\n');
    
    % Show file organization help
    fprintf('\nExpected file organization:\n');
    fprintf('plotSurface/\n');
    fprintf('├── main/           (GUI files)\n');  
    fprintf('├── plotting/       (Core plotting functions)\n');
    fprintf('├── utils/          (Support functions)\n');
    fprintf('├── data/           (Brain surface data)\n');
    fprintf('└── output/         (Generated plots)\n');
    
    rethrow(ME);
end

end
