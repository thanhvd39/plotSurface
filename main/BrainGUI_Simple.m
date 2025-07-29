function BrainGUI_Simple()
% Simple and Robust Brain Surface Plot GUI
% Fixed version that actually works without errors

    % Global variables accessible to all functions
    brain_data = [];
    current_file = '';
    current_atlas = 'schaefer200'; % Default atlas
    available_atlases = {};
    atlas_info = struct();
    
    % UI controls (declared here so all functions can access them)
    file_display = [];
    info_display = [];
    min_edit = [];
    max_edit = [];
    auto_range_check = [];
    atlas_popup = [];
    colormap_popup = [];
    
    % Initialize
    setupPaths();
    createSimpleGUI();
    
    function setupPaths()
        current_dir = pwd;
        
        % Add organized paths
        if exist(fullfile(current_dir, 'plotting'), 'dir')
            addpath(fullfile(current_dir, 'plotting'));
        end
        if exist(fullfile(current_dir, 'utils'), 'dir')
            addpath(fullfile(current_dir, 'utils'));
        end
        if exist(fullfile(current_dir, 'data'), 'dir')
            addpath(fullfile(current_dir, 'data'));
        end
        
        % Create output directory
        output_dir = fullfile(current_dir, 'output');
        if ~exist(output_dir, 'dir')
            mkdir(output_dir);
        end
        
        % Initialize atlas information
        try
            [available_atlases, atlas_info] = get_available_atlases();
            if isempty(available_atlases)
                warning('No brain atlases found! GUI will have limited functionality.');
            else
                current_atlas = available_atlases{1}; % Set first available as default
            end
        catch ME
            warning('Could not load atlas information: %s', ME.message);
            available_atlases = {'schaefer200'};
            current_atlas = 'schaefer200';
        end
    end
    
    function createSimpleGUI()
        % Create main figure
        fig = figure('Name', 'Brain Surface Plot - Simple GUI', ...
                    'Position', [200, 200, 800, 600], ...
                    'MenuBar', 'none', ...
                    'ToolBar', 'none', ...
                    'NumberTitle', 'off', ...
                    'Resize', 'off');
        
        % Create UI elements using absolute positioning (more reliable)
        
        % Title
        uicontrol('Style', 'text', ...
                 'String', 'Brain Surface Plot Tool', ...
                 'Position', [250, 550, 300, 30], ...
                 'FontSize', 16, 'FontWeight', 'bold', ...
                 'BackgroundColor', get(fig, 'Color'));
        
        % Data Loading Section
        uicontrol('Style', 'text', ...
                 'String', 'DATA LOADING', ...
                 'Position', [50, 500, 200, 20], ...
                 'FontSize', 12, 'FontWeight', 'bold', ...
                 'BackgroundColor', get(fig, 'Color'), ...
                 'HorizontalAlignment', 'left');
        
        % File display
        file_display = uicontrol('Style', 'text', ...
                               'String', 'No file selected', ...
                               'Position', [50, 470, 500, 25], ...
                               'BackgroundColor', 'white', ...
                               'HorizontalAlignment', 'left');
        
        % Browse file button
        uicontrol('Style', 'pushbutton', ...
                 'String', 'Browse CSV File', ...
                 'Position', [50, 440, 150, 30], ...
                 'Callback', @browseFile);
        
        % Load simulated data button
        uicontrol('Style', 'pushbutton', ...
                 'String', 'Load Simulated Data', ...
                 'Position', [220, 440, 150, 30], ...
                 'BackgroundColor', [0.9, 0.7, 0.3], ...
                 'Callback', @loadSimulatedData);
        
        % Visualization Section
        uicontrol('Style', 'text', ...
                 'String', 'VISUALIZATION OPTIONS', ...
                 'Position', [50, 390, 200, 20], ...
                 'FontSize', 12, 'FontWeight', 'bold', ...
                 'BackgroundColor', get(fig, 'Color'), ...
                 'HorizontalAlignment', 'left');
        
        % Atlas selection
        uicontrol('Style', 'text', ...
                 'String', 'Brain Atlas:', ...
                 'Position', [50, 360, 80, 20], ...
                 'BackgroundColor', get(fig, 'Color'), ...
                 'HorizontalAlignment', 'left');
        
        % Create atlas dropdown options
        atlas_options = {};
        for i = 1:length(available_atlases)
            atlas_key = available_atlases{i};
            if isfield(atlas_info, atlas_key)
                atlas_name = atlas_info.(atlas_key).name;
                regions = atlas_info.(atlas_key).num_regions;
                atlas_options{i} = sprintf('%s (%d regions)', atlas_name, regions);
            else
                atlas_options{i} = atlas_key;
            end
        end
        
        if isempty(atlas_options)
            atlas_options = {'Schaefer 200 (200 regions)'};
        end
        
        atlas_popup = uicontrol('Style', 'popupmenu', ...
                               'String', atlas_options, ...
                               'Position', [140, 360, 280, 25], ...
                               'Callback', @atlasSelectionCallback);
        
        % Colormap selection
        uicontrol('Style', 'text', ...
                 'String', 'Colormap:', ...
                 'Position', [50, 330, 80, 20], ...
                 'BackgroundColor', get(fig, 'Color'), ...
                 'HorizontalAlignment', 'left');
        
        colormap_options = {'Auto (Default)', 'Jet', 'Hot', 'Cool', 'Spring', 'Summer', ...
                           'Autumn', 'Winter', 'Gray', 'Bone', 'Copper', 'Pink', ...
                           'Lines', 'Parula', 'Viridis', 'Plasma', 'Inferno', 'Magma'};
        
        colormap_popup = uicontrol('Style', 'popupmenu', ...
                                  'String', colormap_options, ...
                                  'Position', [140, 330, 180, 25], ...
                                  'Callback', @colormapSelectionCallback);
        
        % Show colormap preview button
        colormap_preview_btn = uicontrol('Style', 'pushbutton', ...
                                        'String', 'Preview', ...
                                        'Position', [330, 330, 60, 25], ...
                                        'Callback', @showColormapPreview);
        
        % Value range
        uicontrol('Style', 'text', ...
                 'String', 'Min Value:', ...
                 'Position', [50, 290, 80, 20], ...
                 'BackgroundColor', get(fig, 'Color'), ...
                 'HorizontalAlignment', 'left');
        
        min_edit = uicontrol('Style', 'edit', ...
                           'String', '-1', ...
                           'Position', [140, 290, 60, 25]);
        
        uicontrol('Style', 'text', ...
                 'String', 'Max Value:', ...
                 'Position', [220, 290, 80, 20], ...
                 'BackgroundColor', get(fig, 'Color'), ...
                 'HorizontalAlignment', 'left');
        
        max_edit = uicontrol('Style', 'edit', ...
                           'String', '1', ...
                           'Position', [310, 290, 60, 25]);
        
        % Auto range checkbox
        auto_range_check = uicontrol('Style', 'checkbox', ...
                                   'String', 'Auto Range', ...
                                   'Position', [400, 290, 100, 25], ...
                                   'Value', 1, ...
                                   'BackgroundColor', get(fig, 'Color'), ...
                                   'Callback', @autoRangeCallback);
        
        % Action Buttons
        uicontrol('Style', 'text', ...
                 'String', 'ACTIONS', ...
                 'Position', [50, 250, 200, 20], ...
                 'FontSize', 12, 'FontWeight', 'bold', ...
                 'BackgroundColor', get(fig, 'Color'), ...
                 'HorizontalAlignment', 'left');
        
        % Plot brain surface button
        uicontrol('Style', 'pushbutton', ...
                 'String', 'PLOT BRAIN SURFACE', ...
                 'Position', [50, 210, 250, 35], ...
                 'FontSize', 14, 'FontWeight', 'bold', ...
                 'BackgroundColor', [0.2, 0.6, 0.8], ...
                 'ForegroundColor', 'white', ...
                 'Callback', @plotCsvDirect);
        
        % Clear button
        uicontrol('Style', 'pushbutton', ...
                 'String', 'Clear All', ...
                 'Position', [50, 170, 120, 30], ...
                 'Callback', @clearAll);
        
        % Info Display
        uicontrol('Style', 'text', ...
                 'String', 'DATA INFORMATION', ...
                 'Position', [50, 120, 200, 20], ...
                 'FontSize', 12, 'FontWeight', 'bold', ...
                 'BackgroundColor', get(fig, 'Color'), ...
                 'HorizontalAlignment', 'left');
        
        info_display = uicontrol('Style', 'text', ...
                               'String', 'No data loaded', ...
                               'Position', [50, 30, 500, 80], ...
                               'BackgroundColor', 'white', ...
                               'HorizontalAlignment', 'left');
        
        % Status
        status_text = sprintf('Ready | plot_brain_from_brain_weight: %s', ...
                             iif(exist('plot_brain_from_brain_weight', 'file'), 'Available', 'Missing'));
        uicontrol('Style', 'text', ...
                 'String', status_text, ...
                 'Position', [50, 20, 500, 20], ...
                 'BackgroundColor', get(fig, 'Color'), ...
                 'HorizontalAlignment', 'left', ...
                 'FontSize', 10);
    end
    
    % Callback functions
    function atlasSelectionCallback(src, ~)
        try
            selected_index = get(src, 'Value');
            if selected_index <= length(available_atlases)
                current_atlas = available_atlases{selected_index};
                
                % Update expected number of regions info
                if isfield(atlas_info, current_atlas)
                    expected_regions = atlas_info.(current_atlas).num_regions;
                    atlas_name = atlas_info.(current_atlas).name;
                    
                    fprintf('Atlas changed to: %s (%d regions)\n', atlas_name, expected_regions);
                    
                    % Update info display if we have data loaded
                    if ~isempty(brain_data)
                        current_regions = length(brain_data);
                        if current_regions ~= expected_regions
                            msgbox(sprintf(['Warning: Current data has %d regions but %s expects %d regions.\n' ...
                                          'Consider reloading data with correct number of regions.'], ...
                                          current_regions, atlas_name, expected_regions), ...
                                   'Atlas Mismatch', 'warn');
                        end
                        updateInfoDisplay();
                    end
                end
            end
        catch ME
            msgbox(['Error changing atlas: ' ME.message], 'Error', 'error');
        end
    end
    
    function colormapSelectionCallback(src, ~)
        try
            selected_index = get(src, 'Value');
            colormap_options = {'Auto (Default)', 'Jet', 'Hot', 'Cool', 'Spring', 'Summer', ...
                               'Autumn', 'Winter', 'Gray', 'Bone', 'Copper', 'Pink', ...
                               'Lines', 'Parula', 'Viridis', 'Plasma', 'Inferno', 'Magma'};
            
            if selected_index <= length(colormap_options)
                selected_colormap = colormap_options{selected_index};
                fprintf('Colormap changed to: %s\n', selected_colormap);
                
                % Update info display if we have data loaded
                if ~isempty(brain_data)
                    updateInfoDisplay();
                end
            end
        catch ME
            msgbox(['Error changing colormap: ' ME.message], 'Error', 'error');
        end
    end
    
    function showColormapPreview(~, ~)
        try
            % Get selected colormap
            selected_index = get(colormap_popup, 'Value');
            colormap_options = {'Auto (Default)', 'Jet', 'Hot', 'Cool', 'Spring', 'Summer', ...
                               'Autumn', 'Winter', 'Gray', 'Bone', 'Copper', 'Pink', ...
                               'Lines', 'Parula', 'Viridis', 'Plasma', 'Inferno', 'Magma'};
            
            if selected_index > length(colormap_options)
                return;
            end
            
            selected_colormap = colormap_options{selected_index};
            
            % Create preview figure
            preview_fig = figure('Name', sprintf('Colormap Preview: %s', selected_colormap), ...
                               'NumberTitle', 'off', ...
                               'Position', [300, 300, 400, 150]);
            
            % Create colormap data
            if strcmp(selected_colormap, 'Auto (Default)')
                % Show default colormap message
                text(0.5, 0.5, 'Auto colormap will be determined based on data range', ...
                     'HorizontalAlignment', 'center', 'FontSize', 12);
                axis off;
            else
                % Get MATLAB colormap
                colormap_name_lower = lower(strrep(selected_colormap, ' ', ''));
                try
                    cmap_data = eval([colormap_name_lower '(256)']);
                catch
                    % Fallback for custom colormaps
                    cmap_data = jet(256);
                end
                
                % Display colormap as image
                imagesc(1:256, 1, 1:256);
                colormap(cmap_data);
                colorbar('southoutside');
                axis off;
                title(sprintf('Colormap: %s', selected_colormap), 'FontSize', 14);
            end
            
        catch ME
            msgbox(['Error showing colormap preview: ' ME.message], 'Error', 'error');
        end
    end
    
    function browseFile(~, ~)
        try
            [filename, pathname] = uigetfile({
                '*.csv', 'CSV Files (*.csv)';
                '*.mat', 'MATLAB Files (*.mat)';
                '*.txt', 'Text Files (*.txt)';
                '*.*', 'All Files'
            }, 'Select Brain Data File');
            
            if filename == 0
                return; % User cancelled
            end
            
            filepath = fullfile(pathname, filename);
            current_file = filepath;
            
            % Load the data
            [~, ~, ext] = fileparts(filename);
            switch lower(ext)
                case '.csv'
                    brain_data = readmatrix(filepath);
                case '.mat'
                    data_struct = load(filepath);
                    fields = fieldnames(data_struct);
                    % Use first numeric field
                    brain_data = [];
                    for i = 1:length(fields)
                        if isnumeric(data_struct.(fields{i}))
                            brain_data = data_struct.(fields{i});
                            break;
                        end
                    end
                    if isempty(brain_data)
                        error('No numeric data found in MAT file');
                    end
                case '.txt'
                    brain_data = readmatrix(filepath);
                otherwise
                    error('Unsupported file format: %s', ext);
            end
            
            % Ensure column vector
            if size(brain_data, 1) == 1
                brain_data = brain_data';
            end
            
            % Use first column if multiple columns
            if size(brain_data, 2) > 1
                brain_data = brain_data(:, 1);
            end
            
            % Update displays
            set(file_display, 'String', filepath);
            updateInfoDisplay();
            
            % Auto-set range if enabled
            if get(auto_range_check, 'Value')
                set(min_edit, 'String', num2str(min(brain_data(:))));
                set(max_edit, 'String', num2str(max(brain_data(:))));
            end
            
            msgbox(sprintf('Data loaded successfully!\nSize: %dx%d\nRange: %.3f to %.3f', ...
                          size(brain_data, 1), size(brain_data, 2), ...
                          min(brain_data(:)), max(brain_data(:))), 'Success');
            
        catch ME
            msgbox(['Error loading file: ' ME.message], 'Error', 'error');
        end
    end
    
    function loadSimulatedData(~, ~)
        try
            % Check for simulated data directory
            sim_dir = fullfile(pwd, 'data', 'simulated');
            if ~exist(sim_dir, 'dir')
                msgbox('Simulated data directory not found. Use "Generate Test Data" instead.', 'Info');
                return;
            end
            
            % Get list of available files
            files = dir(fullfile(sim_dir, '*.csv'));
            if isempty(files)
                msgbox('No CSV files found in simulated data directory.', 'Info');
                return;
            end
            
            % Let user choose from available files
            file_names = {files.name};
            [selection, ok] = listdlg('PromptString', 'Select simulated data:', ...
                                     'SelectionMode', 'single', ...
                                     'ListString', file_names);
            
            if ~ok
                return; % User cancelled
            end
            
            % Load selected file
            selected_file = fullfile(sim_dir, file_names{selection});
            brain_data = readmatrix(selected_file);
            
            % Ensure column vector
            if size(brain_data, 1) == 1
                brain_data = brain_data';
            end
            if size(brain_data, 2) > 1
                brain_data = brain_data(:, 1);
            end
            
            current_file = selected_file;
            set(file_display, 'String', ['Simulated: ' file_names{selection}]);
            updateInfoDisplay();
            
            % Auto-set range if enabled
            if get(auto_range_check, 'Value')
                set(min_edit, 'String', num2str(min(brain_data(:))));
                set(max_edit, 'String', num2str(max(brain_data(:))));
            end
            
            msgbox(sprintf('Simulated data loaded: %s', file_names{selection}), 'Success');
            
        catch ME
            msgbox(['Error loading simulated data: ' ME.message], 'Error', 'error');
        end
    end
    
    function autoRangeCallback(src, ~)
        if get(src, 'Value') && ~isempty(brain_data)
            set(min_edit, 'String', num2str(min(brain_data(:))));
            set(max_edit, 'String', num2str(max(brain_data(:))));
        end
    end
    
    function updateInfoDisplay()
        if isempty(brain_data)
            info_str = 'No data loaded';
        else
            % Get current atlas info
            atlas_name = 'Unknown';
            expected_regions = 0;
            if isfield(atlas_info, current_atlas)
                atlas_name = atlas_info.(current_atlas).short_name;
                expected_regions = atlas_info.(current_atlas).num_regions;
            end
            
            % Get current colormap info
            selected_colormap_index = get(colormap_popup, 'Value');
            colormap_options = {'Auto (Default)', 'Jet', 'Hot', 'Cool', 'Spring', 'Summer', ...
                               'Autumn', 'Winter', 'Gray', 'Bone', 'Copper', 'Pink', ...
                               'Lines', 'Parula', 'Viridis', 'Plasma', 'Inferno', 'Magma'};
            
            selected_colormap_name = 'Auto';
            if selected_colormap_index <= length(colormap_options)
                selected_colormap_name = colormap_options{selected_colormap_index};
            end
            
            current_regions = length(brain_data);
            region_match = '';
            if expected_regions > 0 && current_regions ~= expected_regions
                region_match = sprintf(' ⚠️ (expects %d)', expected_regions);
            elseif expected_regions > 0 && current_regions == expected_regions
                region_match = ' ✓';
            end
            
            info_str = sprintf(['Atlas: %s\n' ...
                               'Colormap: %s\n' ...
                               'Regions: %d%s\n' ...
                               'Size: %dx%d\n' ...
                               'Range: %.4f to %.4f\n' ...
                               'Mean: %.4f ± %.4f\n' ...
                               'Non-zero: %d/%d'], ...
                               atlas_name, selected_colormap_name, ...
                               current_regions, region_match, ...
                               size(brain_data, 1), size(brain_data, 2), ...
                               min(brain_data(:)), max(brain_data(:)), ...
                               mean(brain_data(:)), std(brain_data(:)), ...
                               sum(brain_data(:) ~= 0), numel(brain_data));
        end
        set(info_display, 'String', info_str);
    end
    
    function plotCsvDirect(~, ~)
        if isempty(brain_data)
            msgbox('Please load data first!', 'No Data', 'warn');
            return;
        end
        
        try
            % Check if we have a real file or generated data
            if strcmp(current_file, 'Generated Test Data')
                % Save generated data as CSV first
                temp_file = fullfile(pwd, 'output', 'temp_generated_data.csv');
                writematrix(brain_data, temp_file);
                csv_file = temp_file;
            else
                csv_file = current_file;
            end
            
            % Generate image name from current time
            image_name = sprintf('brain_plot_%s_%s', current_atlas, datestr(now, 'yyyymmdd_HHMMSS'));
            
            % Call the main plotting function with atlas parameter
            if exist('plot_brain_from_brain_weight', 'file')
                msgbox(sprintf('Generating brain surface plot using %s atlas...', current_atlas), 'Processing');
                
                % Get atlas info for display
                atlas_name = current_atlas;
                if isfield(atlas_info, current_atlas)
                    atlas_name = atlas_info.(current_atlas).name;
                end
                
                % Get selected colormap
                selected_colormap_index = get(colormap_popup, 'Value');
                colormap_options = {'Auto (Default)', 'Jet', 'Hot', 'Cool', 'Spring', 'Summer', ...
                                   'Autumn', 'Winter', 'Gray', 'Bone', 'Copper', 'Pink', ...
                                   'Lines', 'Parula', 'Viridis', 'Plasma', 'Inferno', 'Magma'};
                
                % Setup colormap based on selection
                if selected_colormap_index == 1 || selected_colormap_index > length(colormap_options)
                    % Auto (Default) - let the function decide
                    color_map = '';
                else
                    selected_colormap_name = colormap_options{selected_colormap_index};
                    colormap_name_lower = lower(strrep(selected_colormap_name, ' ', ''));
                    
                    try
                        % Generate colormap with 64 colors
                        switch colormap_name_lower
                            case 'viridis'
                                color_map = viridis(64);
                            case 'plasma'
                                color_map = plasma(64);
                            case 'inferno'
                                color_map = inferno(64);
                            case 'magma'
                                color_map = magma(64);
                            otherwise
                                color_map = eval([colormap_name_lower '(64)']);
                        end
                    catch
                        % Fallback to jet if colormap not available
                        color_map = jet(64);
                        msgbox(sprintf('Colormap %s not available, using Jet instead', selected_colormap_name), 'Colormap Warning', 'warn');
                    end
                end
                
                % Get value range settings
                if get(auto_range_check, 'Value')
                    min_val = -inf;
                    max_val = inf;
                else
                    min_val = str2double(get(min_edit, 'String'));
                    max_val = str2double(get(max_edit, 'String'));
                    if isnan(min_val) || isnan(max_val)
                        min_val = -inf;
                        max_val = inf;
                        msgbox('Invalid range values, using auto range', 'Warning', 'warn');
                    end
                end
                
                % Call main plotting function with atlas parameter
                plot_brain_from_brain_weight('weight', brain_data, ...
                                           'name', image_name, ...
                                           'dir', 'output', ...
                                           'colormap', color_map, ...
                                           'atlas', current_atlas, ...
                                           'min', min_val, ...
                                           'max', max_val);
                
                msgbox(sprintf('Brain surface plot generated successfully using %s!', atlas_name), 'Success');
            else
                msgbox('Brain plotting function not found!', 'Error', 'error');
            end
            
        catch ME
            msgbox(['Error in direct CSV plotting: ' ME.message], 'Error', 'error');
        end
    end
    
    
    function clearAll(~, ~)
        brain_data = [];
        current_file = '';
        set(file_display, 'String', 'No file selected');
        updateInfoDisplay();
        
        % Close plot figures
        all_figs = findall(groot, 'Type', 'figure');
        for i = 1:length(all_figs)
            fig_name = get(all_figs(i), 'Name');
            if ~contains(fig_name, 'Brain Surface Plot - Simple GUI')
                close(all_figs(i));
            end
        end
        
        msgbox('All data and figures cleared!', 'Cleared');
    end

end

% Colormap helper functions for MATLAB versions that don't have them built-in
function cmap = viridis(n)
    if nargin < 1, n = 256; end
    % Viridis colormap approximation
    viridis_data = [
        0.267004, 0.004874, 0.329415;
        0.282623, 0.140926, 0.457517;
        0.253935, 0.265254, 0.529983;
        0.206756, 0.371758, 0.553117;
        0.163625, 0.471133, 0.558148;
        0.127568, 0.566949, 0.550556;
        0.134692, 0.658636, 0.517649;
        0.266941, 0.748751, 0.440573;
        0.477504, 0.821444, 0.318195;
        0.741388, 0.873449, 0.149561;
        0.993248, 0.906157, 0.143936
    ];
    cmap = interp1(linspace(0,1,size(viridis_data,1)), viridis_data, linspace(0,1,n));
end

function cmap = plasma(n)
    if nargin < 1, n = 256; end
    % Plasma colormap approximation
    plasma_data = [
        0.050383, 0.029803, 0.527975;
        0.186213, 0.018803, 0.587228;
        0.287076, 0.010855, 0.627295;
        0.381047, 0.001814, 0.653068;
        0.471457, 0.005678, 0.659897;
        0.558148, 0.042253, 0.644924;
        0.640374, 0.098387, 0.606642;
        0.716387, 0.172719, 0.541106;
        0.784421, 0.266479, 0.445702;
        0.843532, 0.384299, 0.319118;
        0.940015, 0.975158, 0.131326
    ];
    cmap = interp1(linspace(0,1,size(plasma_data,1)), plasma_data, linspace(0,1,n));
end

function cmap = inferno(n)
    if nargin < 1, n = 256; end
    % Inferno colormap approximation
    inferno_data = [
        0.001462, 0.000466, 0.013866;
        0.048691, 0.004135, 0.170838;
        0.109883, 0.010855, 0.300543;
        0.186213, 0.018803, 0.407061;
        0.287076, 0.072911, 0.485077;
        0.417642, 0.163625, 0.529983;
        0.578304, 0.289371, 0.539294;
        0.735683, 0.449540, 0.510637;
        0.864746, 0.630084, 0.429466;
        0.944006, 0.827160, 0.318195;
        0.988362, 0.998364, 0.644924
    ];
    cmap = interp1(linspace(0,1,size(inferno_data,1)), inferno_data, linspace(0,1,n));
end

function cmap = magma(n)
    if nargin < 1, n = 256; end
    % Magma colormap approximation
    magma_data = [
        0.001462, 0.000466, 0.013866;
        0.078815, 0.009605, 0.162629;
        0.155834, 0.025563, 0.278513;
        0.232077, 0.059706, 0.378384;
        0.302436, 0.117570, 0.456550;
        0.384299, 0.200582, 0.508781;
        0.493377, 0.313952, 0.529983;
        0.636902, 0.458219, 0.503410;
        0.784421, 0.619701, 0.426973;
        0.895285, 0.795952, 0.348901;
        0.987053, 0.991438, 0.749504
    ];
    cmap = interp1(linspace(0,1,size(magma_data,1)), magma_data, linspace(0,1,n));
end

% Helper function
function result = iif(condition, true_value, false_value)
    if condition
        result = true_value;
    else
        result = false_value;
    end
end
