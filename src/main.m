
clc, close all;
init;

%% load csv and set name for image
data_path = '/Users/tth/Thanh/rePLS/rePLS-figures/figures/figure4/4a/mean_P.csv';
image_name = "group4_cortical_thickness";
color_map = jet(64);
color_map = flipud(color_map);

dir = '/Users/tth/Thanh/rePLS/rePLS-figures/dev/';
%% read data and plot


data = readtable(data_path);
data = table2array(data);

plot_brain_from_brain_weight("weight", ...
    data, "name", image_name, "colormap", color_map,"dir", dir);

init;


