
clc, close all;

init;

load("/Users/tth/Thanh/ADNI-rePLS/figures/supplementary/results/compare_rePLS_vs_PLS_method_rePLS.mat")
PQ_rePLS = PQ';
P_rePLS = P;


load("/Users/tth/Thanh/ADNI-rePLS/figures/supplementary/results/compare_rePLS_vs_PLS_method_PLS.mat")
PQ_PLS = PQ';
P_PLS = P;

% range_thresh = 0.5;
% PQ_rePLS_important_feature = important_regions_by_weight(PQ_rePLS,range_thresh);
% PQ_PLS_important_feature = important_regions_by_weight(PQ_PLS,range_thresh);

% % PQ
% for i=1:8
% 
%     common_region = (PQ_rePLS_important_feature(:,i) == 1 & PQ_PLS_important_feature(:,i) == 1); % Common regions
%     rePLS_unique = (PQ_rePLS_important_feature(:,i) == 1 & common_region == 0) ; 
%     PLS_unique = (PQ_PLS_important_feature(:,i) ==1 & common_region==0) ; % 
%     % length(find(common_region>0)) + length(find(common_region>0))
%     common_unique_combine = common_region*2.5+ rePLS_unique*1.5+PLS_unique*0.5;
%     %
%     display("rePLS_unique: " + string(length(find(rePLS_unique >0))))
%     display("PLS_unique: " + string(length(find(PLS_unique >0))))
%     display("common: " + string(length(find(common_region >0))))
% 
%     plot_brain_from_brain_weight_discrete("weight", ...
%         common_unique_combine, "name", "rePLS_PLS_outcome"+ string(i))
% 
% end

% P
range_thresh = 0.05;
P_rePLS_important_feature = important_regions_by_weight(P_rePLS,range_thresh);
P_PLS_important_feature = important_regions_by_weight(P_PLS,range_thresh);

for i=1:5

    common_region = (P_rePLS_important_feature(:,i) == 1 & P_PLS_important_feature(:,i) == 1); % Common regions
    rePLS_unique = (P_rePLS_important_feature(:,i) == 1 & common_region == 0) ; 
    PLS_unique = (P_PLS_important_feature(:,i) ==1 & common_region==0) ; % 
    % length(find(common_region>0)) + length(find(common_region>0))
    common_unique_combine = common_region*2.5+ rePLS_unique*1.5+PLS_unique*0.5;
    %
    display("rePLS_unique: " + string(length(find(rePLS_unique >0))))
    display("PLS_unique: " + string(length(find(PLS_unique >0))))
    display("common: " + string(length(find(common_region >0))))
    
    plot_brain_from_brain_weight_discrete("weight", ...
        common_unique_combine, "name", "P_rePLS_PLS_outcome"+ string(i))

end