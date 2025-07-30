# Plot Brain Surface

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->


<!-- /code_chunk_output -->


This project demonstrates a tool for plotting brain surface data using MATLAB. Users can download and select different atlases (e.g., those compatible with FreeSurfer/fsaverage) to visualize weights within the brain space. 


**Launch the system:**
   ```matlab
   launch_brain_gui()
   ```

**Using the GUI:**

1. Load Data:
Select your CSV file containing brain atlas weights.

2.  Select Atlas:
Choose the atlas option from the dropdown.

3. Plot:
Click the plot button to visualize your brain surface data


<!-- add an image -->
![demo](https://img001.prntscr.com/file/img001/DKmdHNvAS8WWhX8kY6zCPQ.png)

**Example Usage**
```matlab
% Load 200-region data and plot with Schaefer 200 atlas
data = randn(202, 1);  % Your brain data first and second indices are for medial wall in Schaefer atlas
writematrix(data, 'my_data.csv');

% Launch GUI
launch_brain_gui;
% Then, follow the GUI steps: Browse to my_data.csv, select "Schaefer 200 Parcels",
% choose colormap, and plot.
```
