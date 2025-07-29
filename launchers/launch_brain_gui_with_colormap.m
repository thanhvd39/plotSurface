function launch_brain_gui_with_colormap()
    % Launch Brain Surface Plot GUI with Colormap Support
    % This script sets up paths and launches the GUI
    
    fprintf('=== Brain Surface Plot GUI with Colormap Support ===\n\n');
    
    % Set up paths
    current_dir = pwd;
    addpath(fullfile(current_dir, 'main'));
    addpath(fullfile(current_dir, 'utils'));
    addpath(fullfile(current_dir, 'plotting'));
    addpath(fullfile(current_dir, 'data'));
    
    fprintf('✓ Paths configured\n');
    
    % Check for required functions
    required_functions = {'plot_brain_from_brain_weight', 'get_brain_atlas_config', 'get_available_atlases'};
    missing_functions = {};
    
    for i = 1:length(required_functions)
        if ~exist(required_functions{i}, 'file')
            missing_functions{end+1} = required_functions{i};
        end
    end
    
    if ~isempty(missing_functions)
        fprintf('⚠️  Missing functions: %s\n', strjoin(missing_functions, ', '));
        fprintf('   GUI will have limited functionality\n');
    else
        fprintf('✓ All required functions found\n');
    end
    
    % Check for colormap functions
    colormap_functions = {'viridis', 'plasma', 'inferno', 'magma'};
    available_colormaps = {};
    
    for i = 1:length(colormap_functions)
        if exist(colormap_functions{i}, 'file')
            available_colormaps{end+1} = colormap_functions{i};
        end
    end
    
    fprintf('✓ Available custom colormaps: %s\n', strjoin(available_colormaps, ', '));
    
    % Check for test data
    test_data_dir = fullfile(current_dir, 'data', 'simulated');
    if exist(test_data_dir, 'dir')
        csv_files = dir(fullfile(test_data_dir, '*.csv'));
        if ~isempty(csv_files)
            fprintf('✓ Test data available: %d CSV files\n', length(csv_files));
        else
            fprintf('ℹ️  No test data found - use "Generate Test Data" button\n');
        end
    else
        fprintf('ℹ️  Simulated data directory not found - will be created as needed\n');
    end
    
    fprintf('\n🚀 Launching GUI...\n\n');
    
    % Launch the GUI
    try
        BrainGUI_Simple;
        fprintf('✓ GUI launched successfully!\n\n');
        
        fprintf('📋 Quick Start Guide:\n');
        fprintf('1. Load data using one of these methods:\n');
        fprintf('   • Browse CSV File - Load your own data\n');
        fprintf('   • Generate Test Data - Create sample data\n');
        fprintf('   • Load Simulated Data - Use pre-generated data\n\n');
        fprintf('2. Select brain atlas from dropdown (3 available)\n\n');
        fprintf('3. Choose colormap from 18 options:\n');
        fprintf('   • Auto (Default) - Data-driven selection\n');
        fprintf('   • Standard MATLAB: Jet, Hot, Cool, etc.\n');
        fprintf('   • Modern: Viridis, Plasma, Inferno, Magma\n\n');
        fprintf('4. Click "Preview" to see colormap visualization\n\n');
        fprintf('5. Adjust value range if needed\n\n');
        fprintf('6. Click "PLOT BRAIN SURFACE" to generate visualization\n\n');
        
    catch ME
        fprintf('❌ Error launching GUI: %s\n', ME.message);
        fprintf('Stack trace:\n');
        for i = 1:length(ME.stack)
            fprintf('  Line %d in %s\n', ME.stack(i).line, ME.stack(i).name);
        end
    end
end
