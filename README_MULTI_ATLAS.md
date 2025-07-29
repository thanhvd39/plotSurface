# Multi-Atlas Brain Surface Plotting System

## 🎯 **NEW FEATURE: Multiple Brain Atlas Support**

The system now supports multiple brain atlases with automatic detection and selection!

---

## 🧠 **Supported Brain Atlases**

### Currently Available:
1. **Schaefer 200 Parcels (7 Networks)** - 200 regions
   - File: `lh/rh.Schaefer2018_200Parcels_7Networks_order.annot`
   - Description: 200 cortical parcels organized into 7 canonical networks
   - Reference: Schaefer et al. (2018) Cerebral Cortex

2. **HCP Multi-Modal Parcellation (MMP)** - 360 regions
   - File: `lh/rh.HCPMMP1.annot`
   - Description: 360 cortical areas based on multi-modal neuroimaging
   - Reference: Glasser et al. (2016) Nature

### Potentially Supported (if annotation files are available):
- Schaefer 100 Parcels (7 Networks) - 100 regions
- Schaefer 400 Parcels (7 Networks) - 400 regions
- Desikan-Killiany Atlas - 68 regions
- Destrieux Atlas - 148 regions

---

## 🎮 **How to Use Multi-Atlas System**

### 1. Launch GUI with Atlas Detection
```matlab
launch_brain_gui()
```
The system automatically:
- Detects available atlases in `data/` directory
- Shows atlas dropdown in GUI
- Validates data compatibility

### 2. Select Your Atlas
- **GUI**: Use the "Brain Atlas" dropdown menu
- **Shows**: Atlas name and number of regions
- **Updates**: Expected region count in data info

### 3. Load Compatible Data
- **Schaefer 200**: Load 200-element data vectors
- **HCP-MMP**: Load 360-element data vectors
- **Auto-validation**: GUI warns if data size doesn't match atlas

### 4. Generate Atlas-Specific Plots
- Click "PLOT BRAIN SURFACE"
- System uses correct annotation files for selected atlas
- Output files are labeled with atlas name

---

## 📊 **Test Data for Each Atlas**

Test data is available in `data/atlas_test_data/`:

```matlab
% Schaefer 200 test data
plot_brain_with_atlas(readmatrix('data/atlas_test_data/schaefer200_test_data.csv'), ...
                     'schaefer200', 'test_schaefer200');

% HCP-MMP test data  
plot_brain_with_atlas(readmatrix('data/atlas_test_data/hcp_mmp_test_data.csv'), ...
                     'hcp_mmp', 'test_hcp_mmp');
```

---

## 🔧 **Atlas Configuration System**

### Adding New Atlases
1. Add annotation files to `data/` directory:
   - `lh.{atlas_name}.annot`
   - `rh.{atlas_name}.annot`

2. Update `utils/get_brain_atlas_config.m`:
```matlab
atlas_config.new_atlas = struct();
atlas_config.new_atlas.name = 'New Atlas Name';
atlas_config.new_atlas.short_name = 'NewAtlas';
atlas_config.new_atlas.num_regions = 100;
atlas_config.new_atlas.lh_annot = 'lh.new_atlas.annot';
atlas_config.new_atlas.rh_annot = 'rh.new_atlas.annot';
atlas_config.new_atlas.description = 'Description of new atlas';
atlas_config.new_atlas.reference = 'Citation for new atlas';
```

3. Restart GUI - new atlas will be auto-detected!

### Atlas Information Functions
```matlab
% Get all configured atlases
atlas_config = get_brain_atlas_config();

% Get available atlases (with existing files)
[available_atlases, atlas_info] = get_available_atlases();

% Check specific atlas
if isfield(atlas_config, 'schaefer200')
    fprintf('Atlas: %s\n', atlas_config.schaefer200.name);
    fprintf('Regions: %d\n', atlas_config.schaefer200.num_regions);
end
```

---

## 🎯 **Advanced Usage**

### Direct Atlas-Aware Plotting
```matlab
% Load your data
brain_data = readmatrix('your_data.csv');

% Plot with specific atlas
plot_brain_with_atlas(brain_data, 'hcp_mmp', 'my_hcp_plot');
plot_brain_with_atlas(brain_data, 'schaefer200', 'my_schaefer_plot');
```

### Batch Processing Multiple Atlases
```matlab
data_file = 'your_brain_data.csv';
brain_data = readmatrix(data_file);

[available_atlases, ~] = get_available_atlases();

for i = 1:length(available_atlases)
    atlas_key = available_atlases{i};
    
    % Generate different data sizes if needed
    if strcmp(atlas_key, 'schaefer200') && length(brain_data) == 200
        plot_brain_with_atlas(brain_data, atlas_key, sprintf('plot_%s', atlas_key));
    elseif strcmp(atlas_key, 'hcp_mmp') && length(brain_data) == 360
        plot_brain_with_atlas(brain_data, atlas_key, sprintf('plot_%s', atlas_key));
    end
end
```

---

## ✅ **GUI Features Enhanced**

### Atlas Selection Dropdown
- **Location**: Visualization Options section
- **Shows**: Atlas name and region count
- **Updates**: Real-time data validation

### Smart Data Validation
- **Region Count Check**: Warns if data size ≠ expected regions
- **Atlas Info Display**: Shows current atlas in data information
- **Status Indicators**: ✓ for matching data, ⚠️ for mismatches

### Enhanced File Naming
- **Auto-naming**: Includes atlas name in output files
- **Format**: `brain_plot_{atlas}_{timestamp}`
- **Example**: `brain_plot_hcp_mmp_20250730_143022.png`

---

## 🚀 **Benefits of Multi-Atlas System**

1. **Flexibility**: Support for different parcellation schemes
2. **Validation**: Automatic data size checking
3. **Organization**: Clear atlas-specific file naming
4. **Extensibility**: Easy to add new atlases
5. **User-Friendly**: Dropdown selection with region counts
6. **Research-Ready**: Support for major brain atlases used in neuroscience

---

## 📋 **Quick Reference**

| Atlas | Regions | Best For |
|-------|---------|----------|
| Schaefer 200 | 200 | Standard network analysis |
| HCP-MMP | 360 | High-resolution cortical analysis |
| Schaefer 100 | 100 | Coarse network analysis |
| Schaefer 400 | 400 | Fine-grained analysis |
| Desikan-Killiany | 68 | Clinical applications |
| Destrieux | 148 | Detailed anatomical analysis |

**The multi-atlas system makes brain surface plotting flexible and research-ready! 🧠✨**
