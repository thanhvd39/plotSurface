
clc,close all;

init;

file_path = "/Users/tth/Thanh/ADNI-rePLS/figures/figure6/results/common_unique_ADNI_OASIS/mean_P_OASIS_rePLS_n_splits10_n_repeats200.mat";

top_k = 50;
important_feature_OASIS = important_regions_top_k(file_path,top_k);

file_path = "/Users/tth/Thanh/ADNI-rePLS/figures/figure6/results/common_unique_ADNI_OASIS/mean_P_ADNI_rePLS_n_splits10_n_repeats200.mat";

top_k = 50;
important_feature_ADNI = important_regions_top_k(file_path,top_k);



i = 1;
common_region = intersect(important_feature_OASIS{i}, important_feature_ADNI{i});
ADNI_unique = setdiff(important_feature_ADNI{i},important_feature_OASIS{i} ) ; 
OASIS_unique = setdiff(important_feature_OASIS{i},important_feature_ADNI{i} );


common_unique_combine = zeros(202,1);
common_unique_combine(common_region) = 2.5;
common_unique_combine(ADNI_unique) = 1.5;
common_unique_combine(OASIS_unique) = 0.5;

plot_brain_from_brain_weight_discrete("weight", ...
    common_unique_combine, "name", "P0")
%%
i = 2;
common_region = intersect(important_feature_OASIS{i}, important_feature_ADNI{i});
ADNI_unique = setdiff(important_feature_ADNI{i},important_feature_OASIS{i} ) ; 
OASIS_unique = setdiff(important_feature_OASIS{i},important_feature_ADNI{i} );


common_unique_combine = zeros(202,1);
common_unique_combine(common_region) = 2.5;
common_unique_combine(ADNI_unique) = 1.5;
common_unique_combine(OASIS_unique) = 0.5;

plot_brain_from_brain_weight_discrete("weight", ...
    common_unique_combine, "name", "P1")

