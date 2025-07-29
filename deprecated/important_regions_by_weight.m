function important_feature = important_regions_by_weight(cortical_thickness_weight,range_thresh)

[regions,maps] = size(cortical_thickness_weight);


important_feature = zeros(size(cortical_thickness_weight));
for i =1:maps
    weight = cortical_thickness_weight(:,i);
    abs_weight = abs(weight);
    cmin = min(weight(:));
    cmax = max(weight(:));
    abs_max = max(abs_weight(:));  
    if cmin <0
         
        important_feature(:,i) = (abs_weight > (1-range_thresh)/2*abs_max);
        
    else
        important_feature(:,i) = (weight > (1-range_thresh)*(cmax-cmin));
        
    end

    
    

end
end