
clc, close all;

init;

for test_size= [0.1:-0.1:0]

plot_brain_from_mat_file("name","P_test_"+ string(test_size) ,"weight_mat_file", ...
    "/Users/tth/Thanh/ADNI-rePLS/figures/figure4/results/supplementary/mean_P_test_size"+ string(test_size) + ".mat")
end
% plot_brain_from_mat_file("name","P" ,"weight_mat_file", ...
%     "/Users/tth/Thanh/ADNI-rePLS/figures/figure4/figures/mean_P.mat")


% load("/Users/tth/Thanh/ADNI-rePLS/figures/figure6/results/common_unique_ADNI_OASIS/common_unique_ADNI_OASIS_MMSE.mat")
% P = P';
% P = P(3:end);
% plot_brain_from_brain_weight_discrete("weight", ...
%     P, "name", "P1")