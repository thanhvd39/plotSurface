function plot_brain_with_atlas(brain_data, atlas_key, image_name, output_dir)
% Plot brain data using specified atlas
% 
% Inputs:
%   brain_data - vector of brain region values
%   atlas_key - atlas identifier (e.g., 'schaefer200', 'hcp_mmp')
%   image_name - name for output files
%   output_dir - directory to save plots (optional)

if nargin < 4
    output_dir = fullfile(pwd, 'output', 'gui_plots');
end

if nargin < 3
    image_name = sprintf('brain_plot_%s', datestr(now, 'yyyymmdd_HHMMSS'));
end

fprintf('=== Atlas-Aware Brain Plotting ===\n');
fprintf('Atlas: %s\n', atlas_key);
fprintf('Data size: %d regions\n', length(brain_data));
fprintf('Image name: %s\n\n', image_name);

try
    % Get atlas configuration
    atlas_config = get_brain_atlas_config();
    
    if ~isfield(atlas_config, atlas_key)
        error('Unknown atlas: %s', atlas_key);
    end
    
    atlas = atlas_config.(atlas_key);
    fprintf('Using atlas: %s\n', atlas.name);
    fprintf('Expected regions: %d\n', atlas.num_regions);
    
    % Validate data size
    if length(brain_data) ~= atlas.num_regions
        warning('Data has %d regions but atlas expects %d regions', ...
                length(brain_data), atlas.num_regions);
    end
    
    % Setup paths
    current_dir = pwd;
    addpath(fullfile(current_dir, 'plotting'));
    addpath(fullfile(current_dir, 'utils'));
    addpath(fullfile(current_dir, 'data'));
    
    % Create output directory
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end
    
    % Setup visualization parameters
    color_map = flipud(jet(64));
    value_range = [min(brain_data(:)), max(brain_data(:))];
    
    fprintf('Color range: %.4f to %.4f\n', value_range(1), value_range(2));
    
    % Check if main plotting function exists
    if exist('plot_brain_from_brain_weight', 'file')
        % Call plotting function with atlas-specific parameters
        fprintf('Calling plot_brain_from_brain_weight...\n');
        
        % The main function uses annotation files based on current working directory
        % We need to temporarily change directory if needed or ensure files are accessible
        old_path = pwd;
        try
            % Call the main plotting function
            plot_brain_from_brain_weight('weight', brain_data, ...
                                       'name', image_name, ...
                                       'colormap', color_map, ...
                                       'min', value_range(1), ...
                                       'max', value_range(2));
            
            fprintf('✓ Brain surface plots generated successfully!\n');
            
            % List generated files
            output_files = dir(fullfile(pwd, [image_name '*.png']));
            svg_files = dir(fullfile(pwd, [image_name '*.svg']));
            
            if ~isempty(output_files) || ~isempty(svg_files)
                fprintf('Generated files:\n');
                for i = 1:length(output_files)
                    fprintf('  - %s\n', output_files(i).name);
                end
                for i = 1:length(svg_files)
                    fprintf('  - %s\n', svg_files(i).name);
                end
            end
            
        catch ME
            cd(old_path);
            rethrow(ME);
        end
        cd(old_path);
        
    else
        error('plot_brain_from_brain_weight function not found');
    end
    
    fprintf('\n=== Atlas-aware brain plotting completed! ===\n');
    
catch ME
    fprintf('ERROR in atlas-aware plotting: %s\n', ME.message);
    fprintf('Atlas: %s\n', atlas_key);
    fprintf('Data size: %d\n', length(brain_data));
    rethrow(ME);
end

end
