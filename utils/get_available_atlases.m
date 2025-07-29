function [available_atlases, atlas_info] = get_available_atlases()
% Check which brain atlases are available based on existing annotation files
% Returns list of available atlas keys and their information

% Get all atlas configurations
all_atlases = get_brain_atlas_config();
atlas_names = fieldnames(all_atlases);

available_atlases = {};
atlas_info = struct();

% Check which atlases have the required files
data_dir = fullfile(pwd, 'data');

for i = 1:length(atlas_names)
    atlas_key = atlas_names{i};
    atlas = all_atlases.(atlas_key);
    
    % Check if both hemisphere annotation files exist
    lh_file = fullfile(data_dir, atlas.lh_annot);
    rh_file = fullfile(data_dir, atlas.rh_annot);
    
    if exist(lh_file, 'file') && exist(rh_file, 'file')
        available_atlases{end+1} = atlas_key;
        atlas_info.(atlas_key) = atlas;
        
        fprintf('✓ Found atlas: %s (%d regions)\n', atlas.name, atlas.num_regions);
        fprintf('  LH: %s\n', atlas.lh_annot);
        fprintf('  RH: %s\n', atlas.rh_annot);
        fprintf('  Description: %s\n\n', atlas.description);
    else
        fprintf('✗ Missing files for atlas: %s\n', atlas.name);
        if ~exist(lh_file, 'file')
            fprintf('  Missing: %s\n', atlas.lh_annot);
        end
        if ~exist(rh_file, 'file')
            fprintf('  Missing: %s\n', atlas.rh_annot);
        end
        fprintf('\n');
    end
end

if isempty(available_atlases)
    warning('No complete brain atlases found! Please check your data directory.');
else
    fprintf('Total available atlases: %d\n', length(available_atlases));
end

end
