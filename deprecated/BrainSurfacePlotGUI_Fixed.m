function BrainSurfacePlotGUI_Fixed()
% Advanced GUI for plotting brain surfaces with atlas and weight data
% Fixed version with proper error handling and path management

    % Initialize the GUI
    fig = uifigure('Name', 'Brain Surface Plot Tool (Fixed)', ...
                   'Position', [100, 100, 1200, 800], ...
                   'Color', [0.94, 0.94, 0.94]);
    
    % Initialize variables
    brain_data = [];
    atlas_data = [];
    current_colormap = 'jet';
    
    % Get current directory and set up paths
    current_dir = fileparts(mfilename('fullpath'));
    if isempty(current_dir)
        current_dir = pwd;
    end
    
    % Set up proper paths
    data_dir = fullfile(current_dir, 'data');
    functions_dir = fullfile(current_dir, 'src', 'functions');
    utils_dir = fullfile(current_dir, 'src', 'utils');
    output_dir = fullfile(current_dir, 'output');
    
    % Add paths
    if exist(functions_dir, 'dir')
        addpath(genpath(functions_dir));
    end
    if exist(utils_dir, 'dir')
        addpath(genpath(utils_dir));
    end
    if exist(data_dir, 'dir')
        addpath(data_dir);
    end
    
    % Create output directory if it doesn't exist
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end
    
    % Check for required files and functions
    [files_ok, missing_files, functions_ok, missing_functions] = checkRequirements();
    
    % Create main layout
    createLayout();
    
    function [files_ok, missing_files, funcs_ok, missing_funcs] = checkRequirements()
        % Check for required data files
        required_files = {
            fullfile(data_dir, 'mySurface_data.mat'),
            fullfile(data_dir, 'lh.Schaefer2018_200Parcels_7Networks_order.annot'),
            fullfile(data_dir, 'rh.Schaefer2018_200Parcels_7Networks_order.annot')
        };
        
        missing_files = {};
        for i = 1:length(required_files)
            if ~exist(required_files{i}, 'file')
                missing_files{end+1} = required_files{i};
            end
        end
        files_ok = isempty(missing_files);
        
        % Check for required functions
        required_functions = {
            'read_annotation',
            'convertCorticalThickness2VertexData', 
            'invalidateNonSurfaceRegions',
            'MyExampleSurfacePlotFunction',
            'plotSurfaceROIBoundary'
        };
        
        missing_funcs = {};
        for i = 1:length(required_functions)
            if ~exist(required_functions{i}, 'file')
                missing_funcs{end+1} = required_functions{i};
            end
        end
        funcs_ok = isempty(missing_funcs);
    end
    
    function createLayout()
        % Create main grid layout
        main_grid = uigridlayout(fig, [1, 3]);
        main_grid.ColumnWidth = {'1.5x', '2x', '1x'};
        
        % Left panel - Controls
        left_panel = uipanel(main_grid, 'Title', 'Controls', ...
                             'BackgroundColor', [0.97, 0.97, 0.97]);
        
        % Center panel - Visualization
        center_panel = uipanel(main_grid, 'Title', 'Brain Visualization', ...
                              'BackgroundColor', 'white');
        
        % Right panel - Settings
        right_panel = uipanel(main_grid, 'Title', 'Settings & Info', ...
                             'BackgroundColor', [0.97, 0.97, 0.97]);
        
        createControlPanel(left_panel);
        createVisualizationPanel(center_panel);
        createSettingsPanel(right_panel);
        
        % Display warnings if requirements are missing
        if ~files_ok || ~functions_ok
            showRequirementsWarning();
        end
    end
    
    function showRequirementsWarning()
        warning_msg = 'Missing Requirements Detected:\n\n';
        
        if ~files_ok
            warning_msg = [warning_msg 'Missing Data Files:\n'];
            for i = 1:length(missing_files)
                warning_msg = [warning_msg sprintf('  • %s\n', missing_files{i})];
            end
            warning_msg = [warning_msg '\n'];
        end
        
        if ~functions_ok
            warning_msg = [warning_msg 'Missing Functions:\n'];
            for i = 1:length(missing_functions)
                warning_msg = [warning_msg sprintf('  • %s\n', missing_functions{i})];
            end
            warning_msg = [warning_msg '\n'];
        end
        
        warning_msg = [warning_msg 'Some features may not work correctly.\n'];
        warning_msg = [warning_msg 'You can still load data and use basic functionality.'];
        
        uialert(fig, warning_msg, 'Missing Requirements', 'Icon', 'warning');
    end
    
    function createControlPanel(parent)
        % Create grid for controls
        ctrl_grid = uigridlayout(parent, [15, 1]);
        ctrl_grid.RowHeight = repmat({'fit'}, 1, 15);
        
        % Data Loading Section
        uilabel(ctrl_grid, 'Text', 'Data Loading', 'FontWeight', 'bold', ...
                'FontSize', 14, 'HorizontalAlignment', 'center');
        
        % Weight data input
        weight_grid = uigridlayout(ctrl_grid, [2, 2]);
        weight_grid.ColumnWidth = {'1x', '3x'};
        
        uilabel(weight_grid, 'Text', 'Weight Data:');
        weight_file_field = uieditfield(weight_grid, 'text', ...
                                       'Placeholder', 'Select weight file...');
        
        uilabel(weight_grid, 'Text', '');
        uibutton(weight_grid, 'Text', 'Browse Weight File', ...
                'ButtonPushedFcn', @(~,~) loadWeightData(weight_file_field));
        
        % Generate test data button
        test_data_grid = uigridlayout(ctrl_grid, [1, 2]);
        test_data_grid.ColumnWidth = {'1x', '3x'};
        
        uilabel(test_data_grid, 'Text', '');
        uibutton(test_data_grid, 'Text', 'Generate Test Data', ...
                'ButtonPushedFcn', @generateTestData, ...
                'BackgroundColor', [0.1, 0.4, 0.8], ...
                'FontColor', 'white');
        
        % Atlas selection
        atlas_grid = uigridlayout(ctrl_grid, [2, 2]);
        atlas_grid.ColumnWidth = {'1x', '3x'};
        
        uilabel(atlas_grid, 'Text', 'Atlas:');
        atlas_dropdown = uidropdown(atlas_grid, ...
                                   'Items', {'Schaefer 200', 'Schaefer 400', 'HCPMMP1', 'Custom'}, ...
                                   'Value', 'Schaefer 200', ...
                                   'ValueChangedFcn', @atlasChanged);
        
        uilabel(atlas_grid, 'Text', 'Custom Atlas:');
        atlas_file_field = uieditfield(atlas_grid, 'text', ...
                                      'Placeholder', 'Custom atlas file...', ...
                                      'Enable', 'off');
        
        % Visualization Options
        uilabel(ctrl_grid, 'Text', 'Visualization Options', 'FontWeight', 'bold', ...
                'FontSize', 14, 'HorizontalAlignment', 'center');
        
        % Colormap selection
        cmap_grid = uigridlayout(ctrl_grid, [1, 2]);
        cmap_grid.ColumnWidth = {'1x', '3x'};
        
        uilabel(cmap_grid, 'Text', 'Colormap:');
        colormap_dropdown = uidropdown(cmap_grid, ...
                                      'Items', {'jet', 'parula', 'viridis', 'plasma', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'turbo'}, ...
                                      'Value', 'jet', ...
                                      'ValueChangedFcn', @colormapChanged);
        
        % Value range controls
        range_grid = uigridlayout(ctrl_grid, [2, 2]);
        range_grid.ColumnWidth = {'1x', '3x'};
        
        uilabel(range_grid, 'Text', 'Min Value:');
        min_value_field = uieditfield(range_grid, 'numeric', ...
                                     'Value', -1, ...
                                     'ValueChangedFcn', @rangeChanged);
        
        uilabel(range_grid, 'Text', 'Max Value:');
        max_value_field = uieditfield(range_grid, 'numeric', ...
                                     'Value', 1, ...
                                     'ValueChangedFcn', @rangeChanged);
        
        % Auto-range checkbox
        auto_range_cb = uicheckbox(ctrl_grid, 'Text', 'Auto Range', ...
                                  'Value', true, ...
                                  'ValueChangedFcn', @autoRangeChanged);
        
        % View options
        view_grid = uigridlayout(ctrl_grid, [3, 2]);
        view_grid.ColumnWidth = {'1x', '3x'};
        
        uilabel(view_grid, 'Text', 'Views:');
        view_options = uicheckboxgroup(view_grid, ...
                                      'Items', {'Lateral', 'Medial', 'Dorsal'}, ...
                                      'Value', {'Lateral', 'Medial'});
        
        uilabel(view_grid, 'Text', 'Hemisphere:');
        hemisphere_dropdown = uidropdown(view_grid, ...
                                        'Items', {'Both', 'Left', 'Right'}, ...
                                        'Value', 'Both');
        
        uilabel(view_grid, 'Text', 'Surface Type:');
        surface_dropdown = uidropdown(view_grid, ...
                                     'Items', {'Inflated', 'Pial', 'White'}, ...
                                     'Value', 'Inflated');
        
        % Action buttons
        button_grid = uigridlayout(ctrl_grid, [3, 1]);
        
        plot_button = uibutton(button_grid, 'Text', 'Generate Plot', ...
                              'FontSize', 14, 'FontWeight', 'bold', ...
                              'BackgroundColor', [0.2, 0.6, 0.2], ...
                              'FontColor', 'white', ...
                              'ButtonPushedFcn', @generatePlot);
        
        save_button = uibutton(button_grid, 'Text', 'Save Figures', ...
                              'ButtonPushedFcn', @saveFigures);
        
        clear_button = uibutton(button_grid, 'Text', 'Clear All', ...
                               'ButtonPushedFcn', @clearAll);
        
        % Progress indicator
        progress_bar = uiprogressdlg(fig, 'Title', 'Processing...', ...
                                    'Message', 'Initializing...', ...
                                    'Visible', 'off');
    end
    
    function createVisualizationPanel(parent)
        % Create axes for brain visualization
        brain_axes = uiaxes(parent, 'Position', [10, 10, 580, 400]);
        brain_axes.Title.String = 'Brain Surface Visualization';
        brain_axes.XLabel.String = '';
        brain_axes.YLabel.String = '';
        brain_axes.ZLabel.String = '';
        
        % Initially show a placeholder
        [X, Y, Z] = sphere(20);
        surf(brain_axes, X, Y, Z, 'EdgeColor', 'none', 'FaceAlpha', 0.3);
        colormap(brain_axes, 'gray');
        axis(brain_axes, 'equal', 'off');
        title(brain_axes, 'Load data to begin visualization');
        view(brain_axes, [45, 30]);
    end
    
    function createSettingsPanel(parent)
        % Create grid for settings
        settings_grid = uigridlayout(parent, [12, 1]);
        settings_grid.RowHeight = repmat({'fit'}, 1, 12);
        
        % Output settings
        uilabel(settings_grid, 'Text', 'Output Settings', 'FontWeight', 'bold', ...
                'FontSize', 14, 'HorizontalAlignment', 'center');
        
        % Output directory
        dir_grid = uigridlayout(settings_grid, [2, 2]);
        dir_grid.ColumnWidth = {'1x', '3x'};
        
        uilabel(dir_grid, 'Text', 'Output Dir:');
        output_dir_field = uieditfield(dir_grid, 'text', 'Value', output_dir);
        
        uilabel(dir_grid, 'Text', '');
        uibutton(dir_grid, 'Text', 'Browse', ...
                'ButtonPushedFcn', @(~,~) selectOutputDir(output_dir_field));
        
        % File format options
        format_grid = uigridlayout(settings_grid, [2, 2]);
        format_grid.ColumnWidth = {'1x', '3x'};
        
        uilabel(format_grid, 'Text', 'Format:');
        format_checkgroup = uicheckboxgroup(format_grid, ...
                                           'Items', {'PNG', 'SVG', 'PDF'}, ...
                                           'Value', {'PNG'});
        
        % Figure settings
        uilabel(settings_grid, 'Text', 'Figure Settings', 'FontWeight', 'bold', ...
                'FontSize', 14, 'HorizontalAlignment', 'center');
        
        % DPI setting
        dpi_grid = uigridlayout(settings_grid, [1, 2]);
        dpi_grid.ColumnWidth = {'1x', '3x'};
        
        uilabel(dpi_grid, 'Text', 'DPI:');
        dpi_field = uieditfield(dpi_grid, 'numeric', 'Value', 300);
        
        % Figure size
        size_grid = uigridlayout(settings_grid, [2, 2]);
        size_grid.ColumnWidth = {'1x', '3x'};
        
        uilabel(size_grid, 'Text', 'Width (in):');
        width_field = uieditfield(size_grid, 'numeric', 'Value', 12);
        
        uilabel(size_grid, 'Text', 'Height (in):');
        height_field = uieditfield(size_grid, 'numeric', 'Value', 8);
        
        % Data info panel
        uilabel(settings_grid, 'Text', 'Data Information', 'FontWeight', 'bold', ...
                'FontSize', 14, 'HorizontalAlignment', 'center');
        
        info_textarea = uitextarea(settings_grid, 'Value', 'No data loaded', ...
                                  'Editable', 'off');
        
        % System info
        uilabel(settings_grid, 'Text', 'System Status', 'FontWeight', 'bold', ...
                'FontSize', 14, 'HorizontalAlignment', 'center');
        
        status_text = sprintf('Data Files: %s\nFunctions: %s\nOutput Dir: Ready', ...
                             iif(files_ok, 'OK', 'Missing'), ...
                             iif(functions_ok, 'OK', 'Missing'));
        status_textarea = uitextarea(settings_grid, 'Value', status_text, ...
                                    'Editable', 'off');
    end
    
    % Callback functions
    function loadWeightData(file_field)
        [filename, pathname] = uigetfile({
            '*.csv;*.mat;*.txt', 'Data Files (*.csv,*.mat,*.txt)';
            '*.csv', 'CSV Files (*.csv)';
            '*.mat', 'MATLAB Files (*.mat)';
            '*.txt', 'Text Files (*.txt)';
            '*.*', 'All Files (*.*)'
        }, 'Select Weight Data File');
        
        if filename ~= 0
            filepath = fullfile(pathname, filename);
            file_field.Value = filepath;
            
            try
                progress_bar.Visible = 'on';
                progress_bar.Value = 0.3;
                progress_bar.Message = 'Loading weight data...';
                
                [~, ~, ext] = fileparts(filename);
                switch lower(ext)
                    case '.csv'
                        brain_data = readmatrix(filepath);
                    case '.mat'
                        loaded_data = load(filepath);
                        fields = fieldnames(loaded_data);
                        % Try to find the main data field
                        if length(fields) == 1
                            brain_data = loaded_data.(fields{1});
                        else
                            % Look for common field names
                            common_names = {'weight', 'data', 'values', 'brain_data', 'cortical_thickness'};
                            found = false;
                            for i = 1:length(common_names)
                                if isfield(loaded_data, common_names{i})
                                    brain_data = loaded_data.(common_names{i});
                                    found = true;
                                    break;
                                end
                            end
                            if ~found
                                % Use the first numeric field
                                for i = 1:length(fields)
                                    if isnumeric(loaded_data.(fields{i}))
                                        brain_data = loaded_data.(fields{i});
                                        break;
                                    end
                                end
                            end
                        end
                    case '.txt'
                        brain_data = readmatrix(filepath);
                    otherwise
                        error('Unsupported file format: %s', ext);
                end
                
                % Ensure we have numeric data
                if ~isnumeric(brain_data)
                    error('Data must be numeric');
                end
                
                % Convert to column vector if it's a row vector
                if size(brain_data, 1) == 1 && size(brain_data, 2) > 1
                    brain_data = brain_data';
                end
                
                % Update info
                updateDataInfo(info_textarea);
                
                % Auto-set range if enabled
                if auto_range_cb.Value
                    min_value_field.Value = min(brain_data(:));
                    max_value_field.Value = max(brain_data(:));
                end
                
                progress_bar.Visible = 'off';
                uialert(fig, sprintf('Weight data loaded successfully!\nShape: %dx%d', size(brain_data, 1), size(brain_data, 2)), ...
                        'Success', 'Icon', 'success');
                
            catch ME
                progress_bar.Visible = 'off';
                uialert(fig, ['Error loading data: ' ME.message], 'Error', 'Icon', 'error');
            end
        end
    end
    
    function generateTestData(~, ~)
        try
            progress_bar.Visible = 'on';
            progress_bar.Value = 0.5;
            progress_bar.Message = 'Generating test data...';
            
            % Generate synthetic Schaefer 200 data
            rng(42); % For reproducibility
            n_regions = 200;
            
            % Create realistic brain network patterns
            brain_data = zeros(n_regions, 1);
            
            % Network 1: Visual (regions 1-25) - moderate positive
            brain_data(1:25) = 0.6 + randn(25, 1) * 0.2;
            
            % Network 2: Somatomotor (regions 26-55) - strong positive  
            brain_data(26:55) = 1.2 + randn(30, 1) * 0.3;
            
            % Network 3: Dorsal Attention (regions 56-80) - moderate negative
            brain_data(56:80) = -0.8 + randn(25, 1) * 0.2;
            
            % Network 4: Ventral Attention (regions 81-100) - weak positive
            brain_data(81:100) = 0.3 + randn(20, 1) * 0.15;
            
            % Network 5: Limbic (regions 101-110) - weak negative
            brain_data(101:110) = -0.4 + randn(10, 1) * 0.1;
            
            % Network 6: Frontoparietal (regions 111-140) - strong negative
            brain_data(111:140) = -1.1 + randn(30, 1) * 0.25;
            
            % Network 7: Default Mode (regions 141-200) - mixed pattern
            brain_data(141:170) = 0.8 + randn(30, 1) * 0.3;
            brain_data(171:200) = -0.6 + randn(30, 1) * 0.25;
            
            % Set file field to indicate test data
            weight_file_field.Value = 'Generated Test Data (Schaefer 200)';
            
            % Update info
            updateDataInfo(info_textarea);
            
            % Auto-set range if enabled
            if auto_range_cb.Value
                min_value_field.Value = min(brain_data(:));
                max_value_field.Value = max(brain_data(:));
            end
            
            progress_bar.Visible = 'off';
            uialert(fig, 'Test data generated successfully!', 'Success', 'Icon', 'success');
            
        catch ME
            progress_bar.Visible = 'off';
            uialert(fig, ['Error generating test data: ' ME.message], 'Error', 'Icon', 'error');
        end
    end
    
    function atlasChanged(src, ~)
        if strcmp(src.Value, 'Custom')
            atlas_file_field.Enable = 'on';
        else
            atlas_file_field.Enable = 'off';
        end
    end
    
    function colormapChanged(src, ~)
        current_colormap = src.Value;
    end
    
    function rangeChanged(~, ~)
        auto_range_cb.Value = false;
    end
    
    function autoRangeChanged(src, ~)
        if src.Value && ~isempty(brain_data)
            min_value_field.Value = min(brain_data(:));
            max_value_field.Value = max(brain_data(:));
        end
    end
    
    function selectOutputDir(dir_field)
        selected_dir = uigetdir(output_dir, 'Select Output Directory');
        if selected_dir ~= 0
            dir_field.Value = selected_dir;
            output_dir = selected_dir;
        end
    end
    
    function updateDataInfo(textarea)
        if isempty(brain_data)
            info_text = 'No data loaded';
        else
            info_text = sprintf(['Data Shape: %s\n' ...
                               'Min Value: %.4f\n' ...
                               'Max Value: %.4f\n' ...
                               'Mean: %.4f\n' ...
                               'Std: %.4f\n' ...
                               'Non-zero elements: %d\n' ...
                               'Zero elements: %d'], ...
                               mat2str(size(brain_data)), ...
                               min(brain_data(:)), ...
                               max(brain_data(:)), ...
                               mean(brain_data(:)), ...
                               std(brain_data(:)), ...
                               sum(brain_data(:) ~= 0), ...
                               sum(brain_data(:) == 0));
        end
        textarea.Value = info_text;
    end
    
    function generatePlot(~, ~)
        if isempty(brain_data)
            uialert(fig, 'Please load weight data first or generate test data!', 'No Data', 'Icon', 'warning');
            return;
        end
        
        try
            progress_bar.Visible = 'on';
            progress_bar.Value = 0.1;
            progress_bar.Message = 'Initializing plot generation...';
            
            % Call the plotting function
            if functions_ok && files_ok
                plotBrainSurface();
            else
                plotSimpleBrain();
            end
            
            progress_bar.Visible = 'off';
            uialert(fig, 'Brain surface plot generated successfully!', 'Success', 'Icon', 'success');
            
        catch ME
            progress_bar.Visible = 'off';
            error_msg = ['Error generating plot: ' ME.message];
            if ~functions_ok || ~files_ok
                error_msg = [error_msg '\n\nNote: Some required files or functions are missing. ' ...
                           'This may be causing the error. Please check the System Status panel.'];
            end
            uialert(fig, error_msg, 'Error', 'Icon', 'error');
        end
    end
    
    function plotSimpleBrain()
        % Simple fallback plotting when full functions aren't available
        progress_bar.Value = 0.5;
        progress_bar.Message = 'Creating simple visualization...';
        
        % Clear axes
        cla(brain_axes);
        
        % Create a simple bar plot of the data
        if size(brain_data, 2) == 1
            bar(brain_axes, brain_data);
            title(brain_axes, 'Brain Region Weights (Simple View)');
        else
            imagesc(brain_axes, brain_data);
            title(brain_axes, 'Brain Data Matrix (Simple View)');
            colorbar(brain_axes);
        end
        
        xlabel(brain_axes, 'Brain Regions');
        ylabel(brain_axes, 'Weight Values');
        
        % Apply colormap
        colormap(brain_axes, current_colormap);
        
        % Set color limits
        if ~auto_range_cb.Value
            clim(brain_axes, [min_value_field.Value, max_value_field.Value]);
        end
        
        progress_bar.Value = 1.0;
        progress_bar.Message = 'Complete!';
    end
    
    function plotBrainSurface()
        % Full brain surface plotting (when all files are available)
        progress_bar.Value = 0.3;
        progress_bar.Message = 'Loading surface data...';
        
        % Load surface and atlas data
        try
            % Load surface data
            surface_data_path = fullfile(data_dir, 'mySurface_data.mat');
            load(surface_data_path);
            
            % Set up atlas paths
            atlas_name = atlas_dropdown.Value;
            switch atlas_name
                case 'Schaefer 200'
                    path_annot_lh = fullfile(data_dir, 'lh.Schaefer2018_200Parcels_7Networks_order.annot');
                    path_annot_rh = fullfile(data_dir, 'rh.Schaefer2018_200Parcels_7Networks_order.annot');
                case 'HCPMMP1'
                    path_annot_lh = fullfile(data_dir, 'lh.HCPMMP1.annot');
                    path_annot_rh = fullfile(data_dir, 'rh.HCPMMP1.annot');
                case 'Custom'
                    if isempty(atlas_file_field.Value)
                        error('Please specify custom atlas file');
                    end
                    % Handle custom atlas (simplified)
                    path_annot_lh = atlas_file_field.Value;
                    path_annot_rh = atlas_file_field.Value;
            end
            
            progress_bar.Value = 0.5;
            progress_bar.Message = 'Processing brain data...';
            
            % Process the brain data
            cortical_thickness_weight = brain_data;
            if size(cortical_thickness_weight, 2) > 1
                cortical_thickness_weight = cortical_thickness_weight(:, 1);
            end
            
            % Handle missing data
            cortical_thickness_weight(cortical_thickness_weight == -999) = 0;
            
            progress_bar.Value = 0.7;
            progress_bar.Message = 'Converting to vertex data...';
            
            % Process data for surface plotting
            if exist('invalidateNonSurfaceRegions', 'file')
                i_cortical_thickness_weight = invalidateNonSurfaceRegions(cortical_thickness_weight);
            else
                i_cortical_thickness_weight = cortical_thickness_weight;
            end
            
            % Set color limits
            if auto_range_cb.Value
                cmin = min(i_cortical_thickness_weight(:));
                cmax = max(i_cortical_thickness_weight(:));
            else
                cmin = min_value_field.Value;
                cmax = max_value_field.Value;
            end
            climits = [cmin, cmax];
            
            % Generate colormap
            cmap = generateColormap(current_colormap, 64);
            
            progress_bar.Value = 0.9;
            progress_bar.Message = 'Rendering brain surface...';
            
            % Convert to vertex data
            if exist('convertCorticalThickness2VertexData', 'file')
                [left_cdata, lh_vertex_id, right_cdata, rh_vertex_id, final_cdata, vertex_id] = ...
                    convertCorticalThickness2VertexData(path_annot_lh, path_annot_rh, i_cortical_thickness_weight);
                
                % Prepare data structure
                data_all.both = final_cdata;
                data_all.lh = left_cdata;
                data_all.rh = right_cdata;
                
                % Create new figure for brain surface
                brain_fig = figure('Name', 'Brain Surface Plot', 'Position', [200, 200, 900, 600]);
                
                % Call the main plotting function
                if exist('MyExampleSurfacePlotFunction', 'file')
                    MyExampleSurfacePlotFunction(surface_all, id_all, data_all, cmap, '', climits);
                else
                    error('MyExampleSurfacePlotFunction not found');
                end
            else
                error('convertCorticalThickness2VertexData function not found');
            end
            
            progress_bar.Value = 1.0;
            progress_bar.Message = 'Complete!';
            
        catch ME
            % Fall back to simple plotting
            fprintf('Full brain surface plotting failed: %s\n', ME.message);
            fprintf('Falling back to simple visualization...\n');
            plotSimpleBrain();
        end
    end
    
    function cmap = generateColormap(colormap_name, n)
        try
            switch colormap_name
                case 'viridis'
                    cmap = viridis(n);
                case 'plasma'
                    cmap = plasma(n);
                case 'turbo'
                    if exist('turbo', 'file')
                        cmap = turbo(n);
                    else
                        cmap = jet(n);
                    end
                otherwise
                    cmap = eval([colormap_name '(' num2str(n) ')']);
            end
        catch
            % Default to jet if colormap fails
            cmap = jet(n);
        end
    end
    
    function saveFigures(~, ~)
        try
            % Get all open figures
            figs = findall(groot, 'Type', 'figure');
            if isempty(figs)
                uialert(fig, 'No figures to save!', 'No Figures', 'Icon', 'warning');
                return;
            end
            
            formats = format_checkgroup.Value;
            timestamp = datestr(now, 'yyyymmdd_HHMMSS');
            
            saved_files = {};
            for fig_idx = 1:length(figs)
                current_fig = figs(fig_idx);
                if ~strcmp(current_fig.Name, 'Brain Surface Plot Tool (Fixed)')
                    for i = 1:length(formats)
                        format = lower(formats{i});
                        filename = fullfile(output_dir, sprintf('brain_figure_%d_%s.%s', fig_idx, timestamp, format));
                        
                        switch format
                            case 'png'
                                print(current_fig, filename, '-dpng', ['-r' num2str(dpi_field.Value)]);
                            case 'svg'
                                print(current_fig, filename, '-dsvg');
                            case 'pdf'
                                print(current_fig, filename, '-dpdf');
                        end
                        saved_files{end+1} = filename;
                    end
                end
            end
            
            if ~isempty(saved_files)
                msg = sprintf('Figures saved:\n%s', strjoin(saved_files, '\n'));
                uialert(fig, msg, 'Success', 'Icon', 'success');
            else
                uialert(fig, 'No figures were saved!', 'Warning', 'Icon', 'warning');
            end
            
        catch ME
            uialert(fig, ['Error saving figures: ' ME.message], 'Error', 'Icon', 'error');
        end
    end
    
    function clearAll(~, ~)
        brain_data = [];
        weight_file_field.Value = '';
        atlas_file_field.Value = '';
        info_textarea.Value = 'No data loaded';
        
        % Clear brain axes
        cla(brain_axes);
        [X, Y, Z] = sphere(20);
        surf(brain_axes, X, Y, Z, 'EdgeColor', 'none', 'FaceAlpha', 0.3);
        colormap(brain_axes, 'gray');
        axis(brain_axes, 'equal', 'off');
        title(brain_axes, 'Load data to begin visualization');
        view(brain_axes, [45, 30]);
    end

end

% Helper function
function result = iif(condition, true_value, false_value)
    if condition
        result = true_value;
    else
        result = false_value;
    end
end

% Helper functions for custom colormaps
function cmap = viridis(n)
    if nargin < 1, n = 256; end
    % Viridis colormap approximation
    r = [0.267004, 0.229739, 0.191460, 0.152047, 0.112626, 0.073417, 0.034484, 0.001462];
    g = [0.004874, 0.144670, 0.287675, 0.431594, 0.574804, 0.717387, 0.858960, 0.998364];
    b = [0.329415, 0.516055, 0.682284, 0.827371, 0.952552, 1.053830, 1.131326, 1.189896];
    
    x = linspace(0, 1, length(r));
    xi = linspace(0, 1, n);
    
    cmap = [interp1(x, r, xi)', interp1(x, g, xi)', interp1(x, b, xi)'];
end

function cmap = plasma(n)
    if nargin < 1, n = 256; end
    % Plasma colormap approximation
    r = [0.050383, 0.200519, 0.352209, 0.507075, 0.665191, 0.825207, 0.985367, 0.940015];
    g = [0.029803, 0.041388, 0.053156, 0.065492, 0.078815, 0.093548, 0.110152, 0.987622];
    b = [0.527975, 0.632077, 0.694502, 0.717522, 0.703827, 0.656075, 0.588235, 0.644824];
    
    x = linspace(0, 1, length(r));
    xi = linspace(0, 1, n);
    
    cmap = [interp1(x, r, xi)', interp1(x, g, xi)', interp1(x, b, xi)'];
end
