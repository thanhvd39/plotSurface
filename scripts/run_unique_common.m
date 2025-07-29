clc;
clear;
close all;

% Define the variables with appropriate values
intersection_perc = 0.7; % Example value, adjust as needed
thresh_per = 0.25;       % Example value, adjust as needed;
n_repeated = 50;

for intersection_perc=[0.7,0.8,0.9,1]
    for thresh_per=[0.05 0.1 0.15 0.25 0.3]
        for n_repeated=[2 10 50]

            try
% script_path = '/path/to/your/script'; % Define the actual script path
dir = '/Users/tth/Thanh/ADNI-rePLS/results';     % Define the actual directory path
name = sprintf("P_intersection_perc%g_thresh_per%g_n_repeated%g",intersection_perc,thresh_per,n_repeated );          % Define a specific name for the plot
name = char(string(name));
% Call the function with the updated parameters
plot_common_unique_regions('weight_mat_file', ...
    sprintf("/Users/tth/Thanh/ADNI-rePLS/results/common_unique_ADNI_OASIS_thresh_per%g_intersection_perc%g_n_repeats%i",thresh_per,intersection_perc,n_repeated), ...
    'dir', dir, ...
    'name', name);
    
            catch
                continue
        end
    end
end
end