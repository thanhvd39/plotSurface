function BrainSurfacePlotGUI()
% Advanced GUI for plotting brain surfaces with atlas and weight data
% Improved version with better functionality and user experience

    % Initialize the GUI
    fig = uifigure('Name', 'Brain Surface Plot Tool', ...
                   'Position', [100, 100, 1200, 800], ...
                   'Color', [0.94, 0.94, 0.94]);
    
    % Initialize variables
    brain_data = [];
    atlas_data = [];
    current_colormap = 'jet';
    output_dir = pwd;
    
    % Create main layout
    createLayout();
    
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
                                      'Items', {'jet', 'parula', 'viridis', 'plasma', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'custom'}, ...
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
                                      'Value', {'Lateral', 'Medial', 'Dorsal'});
        
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
        surf(brain_axes, peaks(50), 'EdgeColor', 'none');
        colormap(brain_axes, 'gray');
        axis(brain_axes, 'off');
        title(brain_axes, 'Load data to begin visualization');
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
        output_dir_field = uieditfield(dir_grid, 'text', 'Value', pwd);
        
        uilabel(dir_grid, 'Text', '');
        uibutton(dir_grid, 'Text', 'Browse', ...
                'ButtonPushedFcn', @(~,~) selectOutputDir(output_dir_field));
        
        % File format options
        format_grid = uigridlayout(settings_grid, [2, 2]);
        format_grid.ColumnWidth = {'1x', '3x'};
        
        uilabel(format_grid, 'Text', 'Format:');
        format_checkgroup = uicheckboxgroup(format_grid, ...
                                           'Items', {'PNG', 'SVG', 'PDF'}, ...
                                           'Value', {'PNG', 'SVG'});
        
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
        
        % Advanced options
        uilabel(settings_grid, 'Text', 'Advanced Options', 'FontWeight', 'bold', ...
                'FontSize', 14, 'HorizontalAlignment', 'center');
        
        % Threshold settings
        thresh_cb = uicheckbox(settings_grid, 'Text', 'Apply Threshold', ...
                              'ValueChangedFcn', @thresholdChanged);
        
        % Smoothing options
        smooth_cb = uicheckbox(settings_grid, 'Text', 'Surface Smoothing');
    end
    
    % Callback functions
    function loadWeightData(file_field)
        [filename, pathname] = uigetfile({'*.csv;*.mat;*.txt', 'Data Files (*.csv,*.mat,*.txt)'});
        if filename ~= 0
            filepath = fullfile(pathname, filename);
            file_field.Value = filepath;
            
            try
                progress_bar.Visible = 'on';
                progress_bar.Value = 0.3;
                progress_bar.Message = 'Loading weight data...';
                
                [~, ~, ext] = fileparts(filename);
                switch ext
                    case '.csv'
                        brain_data = readtable(filepath);
                        brain_data = table2array(brain_data);
                    case '.mat'
                        loaded_data = load(filepath);
                        fields = fieldnames(loaded_data);
                        brain_data = loaded_data.(fields{1});
                    case '.txt'
                        brain_data = readmatrix(filepath);
                end
                
                % Update info
                updateDataInfo(info_textarea);
                
                % Auto-set range if enabled
                if auto_range_cb.Value
                    min_value_field.Value = min(brain_data(:));
                    max_value_field.Value = max(brain_data(:));
                end
                
                progress_bar.Visible = 'off';
                uialert(fig, 'Weight data loaded successfully!', 'Success', 'Icon', 'success');
                
            catch ME
                progress_bar.Visible = 'off';
                uialert(fig, ['Error loading data: ' ME.message], 'Error', 'Icon', 'error');
            end
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
        if strcmp(current_colormap, 'custom')
            % Allow user to define custom colormap
            answer = inputdlg('Custom Colormap', 1, {'jet(64)'});
            if ~isempty(answer)
                try
                    current_colormap = eval(answer{1});
                catch
                    uialert(fig, 'Invalid colormap expression', 'Error', 'Icon', 'error');
                    src.Value = 'jet';
                    current_colormap = 'jet';
                end
            end
        end
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
    
    function thresholdChanged(src, ~)
        % Implementation for threshold functionality
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
                               'Non-zero elements: %d'], ...
                               mat2str(size(brain_data)), ...
                               min(brain_data(:)), ...
                               max(brain_data(:)), ...
                               mean(brain_data(:)), ...
                               std(brain_data(:)), ...
                               sum(brain_data(:) ~= 0));
        end
        textarea.Value = info_text;
    end
    
    function generatePlot(~, ~)
        if isempty(brain_data)
            uialert(fig, 'Please load weight data first!', 'No Data', 'Icon', 'warning');
            return;
        end
        
        try
            progress_bar.Visible = 'on';
            progress_bar.Value = 0.1;
            progress_bar.Message = 'Initializing plot generation...';
            
            % Call the improved plotting function
            plotBrainSurface();
            
            progress_bar.Visible = 'off';
            uialert(fig, 'Brain surface plot generated successfully!', 'Success', 'Icon', 'success');
            
        catch ME
            progress_bar.Visible = 'off';
            uialert(fig, ['Error generating plot: ' ME.message], 'Error', 'Icon', 'error');
        end
    end
    
    function plotBrainSurface()
        % Initialize paths and load surface data
        init_paths();
        
        progress_bar.Value = 0.3;
        progress_bar.Message = 'Loading surface data...';
        
        % Load atlas and surface data
        atlas_name = atlas_dropdown.Value;
        switch atlas_name
            case 'Schaefer 200'
                path_annot_lh = '../data/lh.Schaefer2018_200Parcels_7Networks_order.annot';
                path_annot_rh = '../data/rh.Schaefer2018_200Parcels_7Networks_order.annot';
            case 'HCPMMP1'
                path_annot_lh = '../data/lh.HCPMMP1.annot';
                path_annot_rh = '../data/rh.HCPMMP1.annot';
            case 'Custom'
                % Handle custom atlas
                if isempty(atlas_file_field.Value)
                    error('Please specify custom atlas file');
                end
        end
        
        % Load surface data
        load('../data/mySurface_data.mat');
        
        progress_bar.Value = 0.5;
        progress_bar.Message = 'Processing brain data...';
        
        % Process the brain data
        cortical_thickness_weight = brain_data;
        [regions, maps] = size(cortical_thickness_weight);
        if regions < maps
            cortical_thickness_weight = cortical_thickness_weight';
        end
        
        % Handle missing data
        mask = find(cortical_thickness_weight == -999);
        cortical_thickness_weight(mask) = -0.5;
        
        progress_bar.Value = 0.7;
        progress_bar.Message = 'Converting to vertex data...';
        
        % Convert to vertex data
        i_cortical_thickness_weight = cortical_thickness_weight(:, 1);
        i_cortical_thickness_weight = invalidateNonSurfaceRegions(i_cortical_thickness_weight);
        
        % Set color limits
        if auto_range_cb.Value
            cmin = min(i_cortical_thickness_weight(:));
            cmax = max(i_cortical_thickness_weight(:));
        else
            cmin = min_value_field.Value;
            cmax = max_value_field.Value;
        end
        
        % Generate colormap
        if ischar(current_colormap)
            switch current_colormap
                case 'viridis'
                    cmap = viridis(64);
                case 'plasma'
                    cmap = plasma(64);
                otherwise
                    cmap = eval([current_colormap '(64)']);
            end
        else
            cmap = current_colormap;
        end
        
        progress_bar.Value = 0.9;
        progress_bar.Message = 'Rendering brain surface...';
        
        % Convert cortical thickness to vertex data
        [left_cdata, lh_vertex_id, right_cdata, rh_vertex_id, final_cdata, vertex_id] = ...
            convertCorticalThickness2VertexData(path_annot_lh, path_annot_rh, i_cortical_thickness_weight);
        
        % Prepare data structure
        data_all.both = final_cdata;
        data_all.lh = left_cdata;
        data_all.rh = right_cdata;
        climits = [cmin, cmax];
        
        % Clear previous plot and create new figure
        cla(brain_axes);
        
        % Create the main visualization
        MyExampleSurfacePlotFunction(surface_all, id_all, data_all, cmap, '', climits);
        
        progress_bar.Value = 1.0;
        progress_bar.Message = 'Complete!';
    end
    
    function saveFigures(~, ~)
        if isempty(brain_data)
            uialert(fig, 'No data to save!', 'No Data', 'Icon', 'warning');
            return;
        end
        
        try
            formats = format_checkgroup.Value;
            timestamp = datestr(now, 'yyyymmdd_HHMMSS');
            
            for i = 1:length(formats)
                format = lower(formats{i});
                filename = fullfile(output_dir, ['brain_surface_' timestamp '.' format]);
                
                switch format
                    case 'png'
                        print(gcf, filename, '-dpng', ['-r' num2str(dpi_field.Value)]);
                    case 'svg'
                        print(gcf, filename, '-dsvg');
                    case 'pdf'
                        print(gcf, filename, '-dpdf');
                end
            end
            
            uialert(fig, ['Figures saved to: ' output_dir], 'Success', 'Icon', 'success');
            
        catch ME
            uialert(fig, ['Error saving figures: ' ME.message], 'Error', 'Icon', 'error');
        end
    end
    
    function clearAll(~, ~)
        brain_data = [];
        weight_file_field.Value = '';
        atlas_file_field.Value = '';
        info_textarea.Value = 'No data loaded';
        cla(brain_axes);
        title(brain_axes, 'Load data to begin visualization');
    end
    
    function init_paths()
        % Add necessary paths
        addpath(genpath('../src/functions'));
        addpath(genpath('../src/utils'));
        addpath(genpath('../data'));
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