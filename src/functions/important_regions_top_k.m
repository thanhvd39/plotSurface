function ranking_feature = important_regions_top_k(file_path,k_regions)
data = load(file_path);
fields = fieldnames(data);
cortical_thickness_weight = data.(fields{1});

[regions,maps] = size(cortical_thickness_weight);


ranking_feature = {};
for i =1:maps
    weight = cortical_thickness_weight(:,i);
    abs_weight = abs(weight);
    cmin = min(weight(:));
    cmax = max(weight(:));
    abs_max = max(abs_weight(:));  

    % Sort the list based on absolute values in descending order
    [~, idx] = sort(abs(weight), 'descend');
    
    % Select the indices of the top 50 elements (or fewer if the list has less than 50 elements)
    top_indices = idx(1:min(k_regions, length(weight)));
    
    % Extract the top 50 elements based on absolute values
    ranking_feature{length(ranking_feature)+1} = top_indices;


    
 


    
    

end
end