
clc,close all;

init;

file_path = "/Users/tth/Thanh/ADNI-rePLS/figures/figure6/results/common_unique_ADNI_OASIS/mean_P_OASIS_rePLS_n_splits10_n_repeats200.mat";
range_thresh = 0.10;
important_feature_OASIS = important_regions(file_path,range_thresh);
file_path = "/Users/tth/Thanh/ADNI-rePLS/figures/figure6/results/common_unique_ADNI_OASIS/mean_P_ADNI_rePLS_n_splits10_n_repeats200.mat";
important_feature_ADNI = important_regions(file_path,range_thresh);



i = 1;
common_region = (important_feature_ADNI(:,i) == 1 & important_feature_OASIS(:,i) == 1); % Common regions
ADNI_unique = (important_feature_ADNI(:,i) == 1 & common_region == 0) ; % ADNI unique regions
OASIS_unique = (important_feature_OASIS(:,i) ==1 & common_region==0) ; % OASIS unique regions
% length(find(common_region>0)) + length(find(common_region>0))
common_unique_combine = common_region*2.5+ ADNI_unique*1.5+OASIS_unique*0.5;
%
display("common: " + string(length(find(common_region >0))))

plot_brain_from_brain_weight_discrete("weight", ...
    common_unique_combine, "name", "P0")
% 

i = 2;
common_region = (important_feature_ADNI(:,i) == 1 & important_feature_OASIS(:,i) == 1); % Common regions
ADNI_unique = (important_feature_ADNI(:,i) == 1 & common_region ~= 1) ; % ADNI unique regions
OASIS_unique = (important_feature_OASIS(:,i) ==1 & common_region~=1) ; % OASIS unique regions

common_unique_combine = common_region*2.5+ ADNI_unique*1.5+OASIS_unique*0.5;
%
display("common: " + string(length(find(common_region >0))))

plot_brain_from_brain_weight_discrete("weight", ...
    common_unique_combine, "name", "P1")

% load("/Users/tth/Thanh/ADNI-rePLS/figures/figure6/results/common_unique_ADNI_OASIS/common_unique_ADNI_OASIS_CDR.mat")
% P = P';
% P = P(1:end);
% plot_brain_from_brain_weight_discrete("weight", ...
%     P, "name", "P0")