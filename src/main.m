
clc,close all;

init;




% plot_brain_from_mat_file("weight_mat_file", ...
%     "/Users/tth/Thanh/ADNI-rePLS/figures/figure5/results/mean_P.mat")


load("/Users/tth/Thanh/ADNI-rePLS/figures/figure6/results/common_unique_ADNI_OASIS/common_unique_ADNI_OASIS_MMSE.mat")
P = P';
P = P(3:end);
plot_brain_from_brain_weight_discrete("weight", P, "name", "MMSE")