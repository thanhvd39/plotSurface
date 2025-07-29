function launch_simple_gui()
% Simple launcher for the organized brain plotting system
%
% This launcher:
% 1. Sets up paths for the organized file structure
% 2. Launches the simple brain GUI
% 3. Provides quick start instructions

fprintf('\n');
fprintf('🧠 Brain Surface Plotting - Simple Launch\n');
fprintf('=========================================\n');

try
    % Setup organized paths
    current_dir = pwd;
    addpath(fullfile(current_dir, 'main'));
    addpath(fullfile(current_dir, 'plotting'));
    addpath(fullfile(current_dir, 'utils'));
    addpath(fullfile(current_dir, 'data'));
    
    % Create output directories
    output_dirs = {'output', 'output/gui_plots', 'output/csv_plots'};
    for i = 1:length(output_dirs)
        if ~exist(fullfile(current_dir, output_dirs{i}), 'dir')
            mkdir(fullfile(current_dir, output_dirs{i}));
        end
    end
    
    fprintf('✓ Paths configured for organized structure\n');
    fprintf('✓ Output directories ready\n');
    
    % Launch GUI
    fprintf('✓ Launching Brain GUI...\n\n');
    BrainGUI_Simple();
    
    % Quick start guide
    fprintf('Quick Start:\n');
    fprintf('1. Click "Generate Test Data" for sample data\n');
    fprintf('2. Or "Browse CSV File" for your data\n');
    fprintf('3. Click "PLOT BRAIN SURFACE" to generate plots\n');
    fprintf('4. Use "Save Figures" to export results\n\n');
    
catch ME
    fprintf('❌ Error: %s\n', ME.message);
    fprintf('\nTry running from the main plotSurface directory.\n');
    rethrow(ME);
end

end
