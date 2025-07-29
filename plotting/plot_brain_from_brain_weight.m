function plot_brain_from_brain_weight(varargin)
    % Create an inputParser object
    parser = inputParser;
    % Define expected arguments
    addParameter(parser, 'weight', @isnumeric);
    addParameter(parser, 'name', @isstr);
    addParameter(parser, 'dir',  @isstr);
    addParameter(parser, 'colormap', @ischar); % Add colormap parameter
    addParameter(parser, 'max', inf, @isnumeric);
    addParameter(parser, 'min',-inf,@isnumeric);
    addParameter(parser, 'plot_full',false, @islogical);
    addParameter(parser, 'atlas', 'schaefer200', @ischar); % Add atlas parameter
    
    % Parse the inputs first to get atlas
    parse(parser, varargin{:});
    args = parser.Results;
    
    % Ensure output directory exists
    output_dir = args.dir;
    if ~isempty(output_dir)
        % Handle relative paths by making them relative to current directory
        if ~ischar(output_dir) || isempty(output_dir)
            output_dir = 'output';
        end
        
        % If it's a relative path, make it relative to current directory
        if ~isfolder(output_dir) && ~contains(output_dir, filesep)
            output_dir = fullfile(pwd, output_dir);
        end
        
        % Create directory if it doesn't exist
        if ~exist(output_dir, 'dir')
            mkdir(output_dir);
        end
        
        % Update args.dir with the full path
        args.dir = output_dir;
    end
    
    % Get atlas configuration
    atlas_key = args.atlas;
    
    % Get the data directory path - check multiple possible locations
    data_dir = '';
    current_dir = pwd;
    possible_data_dirs = {
        fullfile(current_dir, 'data'),
        fullfile(fileparts(current_dir), 'data'),
        fullfile(fileparts(which(mfilename)), '..', 'data'),
        fullfile(fileparts(fileparts(which(mfilename))), 'data')
    };
    
    for i = 1:length(possible_data_dirs)
        if exist(possible_data_dirs{i}, 'dir')
            data_dir = possible_data_dirs{i};
            break;
        end
    end
    
    if isempty(data_dir)
        error('Could not find data directory containing annotation files');
    end
    
    try
        atlas_config = get_brain_atlas_config();
        if isfield(atlas_config, atlas_key)
            atlas_info = atlas_config.(atlas_key);
            path_annot_lh = fullfile(data_dir, atlas_info.lh_annot);
            path_annot_rh = fullfile(data_dir, atlas_info.rh_annot);
            fprintf('Using atlas: %s (%d regions)\n', atlas_info.name, atlas_info.num_regions);
            fprintf('Annotation files: %s, %s\n', path_annot_lh, path_annot_rh);
        else
            % Fallback to default
            fprintf('Unknown atlas "%s", using default Schaefer 200\n', atlas_key);
            path_annot_lh = fullfile(data_dir, 'lh.Schaefer2018_200Parcels_7Networks_order.annot');
            path_annot_rh = fullfile(data_dir, 'rh.Schaefer2018_200Parcels_7Networks_order.annot');
        end
    catch
        % Fallback if atlas config function not found
        fprintf('Atlas config not available, using default Schaefer 200\n');
        path_annot_lh = fullfile(data_dir, 'lh.Schaefer2018_200Parcels_7Networks_order.annot');
        path_annot_rh = fullfile(data_dir, 'rh.Schaefer2018_200Parcels_7Networks_order.annot');
    end
    
    % Load surface data from data directory (only surface_all, not id_all)
    surface_data_path = fullfile(data_dir, 'mySurface_data.mat');
    if ~exist(surface_data_path, 'file')
        error('Surface data file not found: %s', surface_data_path);
    end
    load(surface_data_path, 'surface_all'); % Only load surface_all, not id_all

    data = args.weight;
    colormap_name = args.colormap; % Get colormap name


    cortical_thickness_weight = data;
    
    [regions, maps] = size(cortical_thickness_weight);
    if regions < maps
        [regions, maps] = deal(maps, regions);
        cortical_thickness_weight = cortical_thickness_weight';
    end

    mask = find(cortical_thickness_weight == -999);
    cortical_thickness_weight(mask) = -0.5;

    for i = 1:maps
        i_cortical_thickness_weight = cortical_thickness_weight(:, i);
        i_cortical_thickness_weight = invalidateNonSurfaceRegions(i_cortical_thickness_weight);
        
        % Global color min, max
        cmin = min(i_cortical_thickness_weight(:));
        cmax = max(i_cortical_thickness_weight(:));
        if args.max ~= inf && args.min ~= -inf
            cmin = args.min;
            cmax = args.max;
        end

        range_thresh = 0.1;
        
        if cmin >= 0 || (-cmin < range_thresh * cmax)
            cmap = mycolormap_blue(cmin, cmax);
        else
            cmap = mycolormap(0, range_thresh, cmin, cmax);
        end
        
        % Apply custom colormap if provided
        if ~isempty(colormap_name)
            if class(colormap_name) == "double" 
            cmap = colormap_name;   
            end
        end
        
        [left_cdata, lh_vertex_id, right_cdata, rh_vertex_id, final_cdata, vertex_id] = convertCorticalThickness2VertexData(path_annot_lh, path_annot_rh, i_cortical_thickness_weight);
        
        % Construct id_all from annotation files instead of loading from mySurface_data.mat
        % Read annotation files to get atlas IDs for each hemisphere
        [~, gg_lh_cdata, a_lh] = read_annotation(path_annot_lh);
        lh_atlas_id = a_lh.table(:,5);
        lh_vertex_id_annot = gg_lh_cdata;
        
        [~, gg_rh_cdata, a_rh] = read_annotation(path_annot_rh);
        rh_atlas_id = a_rh.table(:,5);
        rh_vertex_id_annot = gg_rh_cdata;
        
        % Construct id_all structure from annotation data
        id_all.lh = lh_vertex_id_annot;
        id_all.rh = rh_vertex_id_annot;
        id_all.both = [lh_vertex_id_annot; rh_vertex_id_annot];
        
        data_label = "";
        middleValue = (cmin + cmax) / 2;

        data_all.both = final_cdata;
        data_all.lh = left_cdata;
        data_all.rh = right_cdata;
        climits = [cmin, cmax];

        if args.plot_full
            lh_lateral(surface_all,id_all,data_all,cmap,data_label,climits)
            save_path = fullfile(args.dir, sprintf("lh_lateral_%s_%i.svg", args.name, i - 1));
            saveas(gcf, save_path);
            save_path = fullfile(args.dir, sprintf("lh_lateral_%s_%i.png", args.name, i - 1));
            saveas(gcf, save_path);

            lh_medial(surface_all,id_all,data_all,cmap,data_label,climits)
            save_path = fullfile(args.dir, sprintf("lh_medial_%s_%i.svg", args.name, i - 1));
            saveas(gcf, save_path);
            save_path = fullfile(args.dir, sprintf("lh_medial_%s_%i.png", args.name, i - 1));
            saveas(gcf, save_path);

            rh_lateral(surface_all,id_all,data_all,cmap,data_label,climits)
            save_path = fullfile(args.dir, sprintf("rh_lateral_%s_%i.svg", args.name, i - 1));
            saveas(gcf, save_path);
            save_path = fullfile(args.dir, sprintf("rh_lateral_%s_%i.png", args.name, i - 1));
            saveas(gcf, save_path);

            rh_medial(surface_all,id_all,data_all,cmap,data_label,climits)
            save_path = fullfile(args.dir, sprintf("rh_medial_%s_%i.svg", args.name, i - 1));
            saveas(gcf, save_path);
            save_path = fullfile(args.dir, sprintf("rh_medial_%s_%i.png", args.name, i - 1));
            saveas(gcf, save_path);


            both_hemisphere_dorsal(surface_all,id_all,data_all,cmap,data_label,climits)
            save_path = fullfile(args.dir, sprintf("both_hemis_%s_%i.svg", args.name, i - 1));
            saveas(gcf, save_path);
            save_path = fullfile(args.dir, sprintf("both_hemis_%s_%i.png", args.name, i - 1));
            saveas(gcf, save_path);
        end
        MyExampleSurfacePlotFunction(surface_all, id_all, data_all, cmap, data_label, climits);
        
        % Hide color bar
        colorbar off;

        % Save file into the specified directory
        save_path = fullfile(args.dir, sprintf("%s_%i.svg", args.name, i - 1));
        saveas(gcf, save_path);

        save_path = fullfile(args.dir, sprintf("%s_%i.png", args.name, i - 1));
        saveas(gcf, save_path);
    end

    MyExampleSurfacePlotFunction(surface_all, id_all, data_all, cmap, data_label, climits);
    save_path = fullfile(args.dir, sprintf("%s_color_bar.svg", args.name));
    saveas(gcf, save_path);
    save_path = fullfile(args.dir, sprintf("%s_color_bar.png", args.name));
    saveas(gcf, save_path);
end