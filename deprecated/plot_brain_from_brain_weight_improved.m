function plot_brain_from_brain_weight_improved(varargin)
    % Improved brain surface plotting function with enhanced features
    % 
    % Usage:
    %   plot_brain_from_brain_weight_improved('weight', data, 'name', 'example', ...)
    %
    % Parameters:
    %   weight - Numeric array of brain region weights
    %   name - String, name for output files
    %   dir - String, output directory path
    %   colormap - String or array, colormap to use
    %   atlas - String, atlas type ('schaefer200', 'schaefer400', 'hcpmmp1')
    %   hemisphere - String, which hemisphere to plot ('both', 'left', 'right')
    %   views - Cell array, which views to generate ({'lateral', 'medial', 'dorsal'})
    %   surface_type - String, surface type ('inflated', 'pial', 'white')
    %   threshold - Numeric, threshold value for masking
    %   smooth_iterations - Numeric, number of smoothing iterations
    %   figure_size - Array, [width, height] in inches
    %   dpi - Numeric, resolution for saved figures
    %   formats - Cell array, output formats ({'png', 'svg', 'pdf'})
    %   show_colorbar - Logical, whether to show colorbar
    %   lighting - String, lighting type ('cam', 'gouraud', 'flat')
    %   verbose - Logical, whether to display progress messages

    % Parse input arguments
    parser = inputParser;
    
    % Required parameters
    addParameter(parser, 'weight', [], @isnumeric);
    addParameter(parser, 'name', 'brain_surface', @ischar);
    addParameter(parser, 'dir', pwd, @ischar);
    
    % Visualization parameters
    addParameter(parser, 'colormap', 'jet', @(x) ischar(x) || isnumeric(x));
    addParameter(parser, 'atlas', 'schaefer200', @ischar);
    addParameter(parser, 'hemisphere', 'both', @ischar);
    addParameter(parser, 'views', {'lateral', 'medial', 'dorsal'}, @iscell);
    addParameter(parser, 'surface_type', 'inflated', @ischar);
    
    % Data processing parameters
    addParameter(parser, 'max', inf, @isnumeric);
    addParameter(parser, 'min', -inf, @isnumeric);
    addParameter(parser, 'threshold', [], @isnumeric);
    addParameter(parser, 'smooth_iterations', 0, @isnumeric);
    addParameter(parser, 'auto_range', true, @islogical);
    
    % Output parameters
    addParameter(parser, 'figure_size', [12, 8], @isnumeric);
    addParameter(parser, 'dpi', 300, @isnumeric);
    addParameter(parser, 'formats', {'png', 'svg'}, @iscell);
    addParameter(parser, 'show_colorbar', true, @islogical);
    addParameter(parser, 'lighting', 'cam', @ischar);
    
    % Control parameters
    addParameter(parser, 'verbose', true, @islogical);
    addParameter(parser, 'plot_individual_views', false, @islogical);
    
    parse(parser, varargin{:});
    args = parser.Results;
    
    % Validate inputs
    if isempty(args.weight)
        error('Weight data is required');
    end
    
    if args.verbose
        fprintf('Starting brain surface plotting...\n');
    end
    
    % Initialize paths and load surface data
    try
        init_plotting_environment();
        [surface_data, atlas_data] = load_brain_data(args.atlas, args.surface_type);
    catch ME
        error('Failed to initialize plotting environment: %s', ME.message);
    end
    
    % Process weight data
    cortical_thickness_weight = process_weight_data(args.weight, args);
    
    % Generate plots for each data column
    num_maps = size(cortical_thickness_weight, 2);
    
    for map_idx = 1:num_maps
        if args.verbose
            fprintf('Processing map %d of %d...\n', map_idx, num_maps);
        end
        
        current_weight = cortical_thickness_weight(:, map_idx);
        current_weight = invalidateNonSurfaceRegions(current_weight);
        
        % Determine color limits
        [cmin, cmax, cmap] = determine_color_settings(current_weight, args);
        
        % Convert to vertex data
        [vertex_data, climits] = convert_to_vertex_data(current_weight, atlas_data, cmin, cmax);
        
        % Generate visualizations
        generate_brain_plots(surface_data, vertex_data, cmap, climits, args, map_idx);
    end
    
    if args.verbose
        fprintf('Brain surface plotting completed successfully!\n');
    end
end

function init_plotting_environment()
    % Initialize the plotting environment
    if ~exist('plotSurfaceROIBoundary', 'file')
        addpath(genpath('functions'));
        addpath(genpath('utils'));
        addpath(genpath('../data'));
    end
end

function [surface_data, atlas_data] = load_brain_data(atlas_type, surface_type)
    % Load brain surface and atlas data
    
    % Define atlas paths
    atlas_paths = struct();
    atlas_paths.schaefer200.lh = 'lh.Schaefer2018_200Parcels_7Networks_order.annot';
    atlas_paths.schaefer200.rh = 'rh.Schaefer2018_200Parcels_7Networks_order.annot';
    atlas_paths.hcpmmp1.lh = 'lh.HCPMMP1.annot';
    atlas_paths.hcpmmp1.rh = 'rh.HCPMMP1.annot';
    
    % Get atlas paths
    if isfield(atlas_paths, atlas_type)
        atlas_data.lh_path = atlas_paths.(atlas_type).lh;
        atlas_data.rh_path = atlas_paths.(atlas_type).rh;
    else
        error('Unsupported atlas type: %s', atlas_type);
    end
    
    % Load surface data
    surface_file = 'mySurface_data.mat';
    if exist(surface_file, 'file')
        surface_data = load(surface_file);
    else
        error('Surface data file not found: %s', surface_file);
    end
end

function processed_weight = process_weight_data(weight_data, args)
    % Process and validate weight data
    
    processed_weight = weight_data;
    [regions, maps] = size(processed_weight);
    
    % Ensure proper orientation (regions x maps)
    if regions < maps
        processed_weight = processed_weight';
        [regions, maps] = deal(maps, regions);
    end
    
    % Handle missing data markers
    missing_mask = (processed_weight == -999);
    processed_weight(missing_mask) = NaN;
    
    % Apply threshold if specified
    if ~isempty(args.threshold)
        threshold_mask = abs(processed_weight) < args.threshold;
        processed_weight(threshold_mask) = 0;
    end
    
    % Apply smoothing if requested
    if args.smooth_iterations > 0
        processed_weight = apply_spatial_smoothing(processed_weight, args.smooth_iterations);
    end
end

function [cmin, cmax, cmap] = determine_color_settings(weight_data, args)
    % Determine color limits and colormap
    
    % Calculate color limits
    if args.auto_range || (args.max == inf && args.min == -inf)
        valid_data = weight_data(~isnan(weight_data) & weight_data ~= 0);
        if isempty(valid_data)
            cmin = -1;
            cmax = 1;
        else
            cmin = min(valid_data);
            cmax = max(valid_data);
        end
    else
        cmin = args.min;
        cmax = args.max;
    end
    
    % Generate colormap
    if ischar(args.colormap)
        switch lower(args.colormap)
            case 'jet'
                cmap = jet(64);
            case 'parula'
                cmap = parula(64);
            case 'viridis'
                cmap = generate_viridis(64);
            case 'plasma'
                cmap = generate_plasma(64);
            case 'hot'
                cmap = hot(64);
            case 'cool'
                cmap = cool(64);
            case 'diverging'
                cmap = generate_diverging_colormap(64);
            otherwise
                try
                    cmap = eval([args.colormap '(64)']);
                catch
                    warning('Unknown colormap %s, using jet', args.colormap);
                    cmap = jet(64);
                end
        end
    else
        cmap = args.colormap;
    end
    
    % Apply intelligent colormap selection based on data
    range_thresh = 0.1;
    if cmin >= 0 || (-cmin < range_thresh * cmax)
        % Positive values only, use sequential colormap
        if ischar(args.colormap) && strcmp(args.colormap, 'jet')
            cmap = generate_sequential_colormap(64);
        end
    elseif cmax <= 0 || (cmax < range_thresh * (-cmin))
        % Negative values only, use reverse sequential colormap
        if ischar(args.colormap) && strcmp(args.colormap, 'jet')
            cmap = flipud(generate_sequential_colormap(64));
        end
    else
        % Both positive and negative values, use diverging colormap
        if ischar(args.colormap) && strcmp(args.colormap, 'jet')
            cmap = generate_diverging_colormap(64);
        end
    end
end

function [vertex_data, climits] = convert_to_vertex_data(weight_data, atlas_data, cmin, cmax)
    % Convert region weights to vertex data
    
    [left_cdata, lh_vertex_id, right_cdata, rh_vertex_id, final_cdata, vertex_id] = ...
        convertCorticalThickness2VertexData(atlas_data.lh_path, atlas_data.rh_path, weight_data);
    
    vertex_data.both = final_cdata;
    vertex_data.lh = left_cdata;
    vertex_data.rh = right_cdata;
    
    climits = [cmin, cmax];
end

function generate_brain_plots(surface_data, vertex_data, cmap, climits, args, map_idx)
    % Generate brain surface plots
    
    % Create main combined view
    fig = figure('Position', [100, 100, args.figure_size(1)*100, args.figure_size(2)*100], ...
                 'Color', [1 1 1], 'Visible', 'on');
    
    % Plot main brain surface visualization
    MyExampleSurfacePlotFunction(surface_data.surface_all, surface_data.id_all, ...
                                vertex_data, cmap, '', climits);
    
    % Configure colorbar
    if args.show_colorbar
        c = colorbar;
        c.FontSize = 12;
        c.Label.String = 'Weight';
        c.Label.FontSize = 14;
    else
        colorbar off;
    end
    
    % Apply lighting
    apply_lighting(args.lighting);
    
    % Save main figure
    save_figure(fig, args, sprintf('%s_%d', args.name, map_idx - 1));
    
    % Generate individual view plots if requested
    if args.plot_individual_views
        generate_individual_views(surface_data, vertex_data, cmap, climits, args, map_idx);
    end
    
    % Save colorbar reference
    if map_idx == 1
        save_figure(fig, args, sprintf('%s_colorbar', args.name));
    end
end

function generate_individual_views(surface_data, vertex_data, cmap, climits, args, map_idx)
    % Generate individual view plots
    
    views_to_plot = args.views;
    hemisphere = args.hemisphere;
    
    for view_idx = 1:length(views_to_plot)
        view_name = views_to_plot{view_idx};
        
        % Create figure for this view
        fig = figure('Position', [100, 100, 800, 600], 'Color', [1 1 1]);
        
        switch lower(view_name)
            case 'lateral'
                if strcmp(hemisphere, 'both') || strcmp(hemisphere, 'left')
                    lh_lateral(surface_data.surface_all, surface_data.id_all, vertex_data, cmap, '', climits);
                    save_figure(fig, args, sprintf('lh_lateral_%s_%d', args.name, map_idx - 1));
                end
                if strcmp(hemisphere, 'both') || strcmp(hemisphere, 'right')
                    rh_lateral(surface_data.surface_all, surface_data.id_all, vertex_data, cmap, '', climits);
                    save_figure(fig, args, sprintf('rh_lateral_%s_%d', args.name, map_idx - 1));
                end
                
            case 'medial'
                if strcmp(hemisphere, 'both') || strcmp(hemisphere, 'left')
                    lh_medial(surface_data.surface_all, surface_data.id_all, vertex_data, cmap, '', climits);
                    save_figure(fig, args, sprintf('lh_medial_%s_%d', args.name, map_idx - 1));
                end
                if strcmp(hemisphere, 'both') || strcmp(hemisphere, 'right')
                    rh_medial(surface_data.surface_all, surface_data.id_all, vertex_data, cmap, '', climits);
                    save_figure(fig, args, sprintf('rh_medial_%s_%d', args.name, map_idx - 1));
                end
                
            case 'dorsal'
                both_hemisphere_dorsal(surface_data.surface_all, surface_data.id_all, vertex_data, cmap, '', climits);
                save_figure(fig, args, sprintf('both_hemis_%s_%d', args.name, map_idx - 1));
        end
        
        close(fig);
    end
end

function apply_lighting(lighting_type)
    % Apply lighting to the current figure
    
    switch lower(lighting_type)
        case 'cam'
            camlight(80, -10);
            camlight(-80, -10);
        case 'gouraud'
            lighting gouraud;
        case 'flat'
            lighting flat;
        case 'none'
            lighting none;
    end
end

function save_figure(fig, args, filename)
    % Save figure in specified formats
    
    formats = args.formats;
    
    for fmt_idx = 1:length(formats)
        format = lower(formats{fmt_idx});
        filepath = fullfile(args.dir, [filename '.' format]);
        
        switch format
            case 'png'
                print(fig, filepath, '-dpng', sprintf('-r%d', args.dpi));
            case 'svg'
                print(fig, filepath, '-dsvg', '-painters');
            case 'pdf'
                print(fig, filepath, '-dpdf', '-painters');
            case 'eps'
                print(fig, filepath, '-depsc', '-painters');
            case 'tiff'
                print(fig, filepath, '-dtiff', sprintf('-r%d', args.dpi));
        end
    end
end

function smoothed_data = apply_spatial_smoothing(data, iterations)
    % Apply spatial smoothing to the data
    % This is a placeholder - implement actual spatial smoothing based on atlas connectivity
    smoothed_data = data;
    
    for i = 1:iterations
        % Simple smoothing - in practice, use atlas-based connectivity
        smoothed_data = smoothdata(smoothed_data, 1, 'gaussian');
    end
end

% Custom colormap functions
function cmap = generate_viridis(n)
    % Generate viridis-like colormap
    if nargin < 1, n = 256; end
    
    % Viridis key colors
    colors = [
        68, 1, 84;      % Dark purple
        59, 82, 139;    % Blue-purple
        33, 144, 140;   % Teal
        90, 200, 100;   % Green
        253, 231, 37    % Yellow
    ] / 255;
    
    x = linspace(0, 1, size(colors, 1));
    xi = linspace(0, 1, n);
    
    cmap = interp1(x, colors, xi);
end

function cmap = generate_plasma(n)
    % Generate plasma-like colormap
    if nargin < 1, n = 256; end
    
    % Plasma key colors
    colors = [
        13, 8, 135;     % Dark blue
        84, 2, 163;     % Purple
        139, 10, 165;   % Magenta
        185, 50, 137;   % Pink
        219, 92, 104;   % Red-orange
        244, 136, 73;   % Orange
        254, 188, 43;   % Yellow
        240, 249, 33    % Bright yellow
    ] / 255;
    
    x = linspace(0, 1, size(colors, 1));
    xi = linspace(0, 1, n);
    
    cmap = interp1(x, colors, xi);
end

function cmap = generate_diverging_colormap(n)
    % Generate a diverging colormap (blue-white-red)
    if nargin < 1, n = 64; end
    
    half_n = ceil(n/2);
    
    % Blue to white
    blue_to_white = [linspace(0, 1, half_n)', linspace(0.4, 1, half_n)', ones(half_n, 1)];
    
    % White to red
    white_to_red = [ones(half_n, 1), linspace(1, 0, half_n)', linspace(1, 0, half_n)'];
    
    cmap = [blue_to_white; white_to_red(2:end, :)];
    
    % Trim to exact size
    if size(cmap, 1) > n
        cmap = cmap(1:n, :);
    end
end

function cmap = generate_sequential_colormap(n)
    % Generate a sequential colormap (white to blue)
    if nargin < 1, n = 64; end
    
    cmap = [linspace(1, 0, n)', linspace(1, 0.4, n)', ones(n, 1)];
end