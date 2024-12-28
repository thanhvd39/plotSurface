function plot_brain_from_mat_file(varargin)




    % Create an inputParser object
    parser = inputParser;
    % Define expected arguments
    addParameter(parser, 'weight_mat_file', @isstr);
    addParameter(parser, 'name', @isstr);
    addParameter(parser, 'dir',"./", @isstr);
    
    run('init.m')
    path_annot_lh = 'lh.Schaefer2018_200Parcels_7Networks_order.annot';
    path_annot_rh = 'rh.Schaefer2018_200Parcels_7Networks_order.annot';
    load('mySurface_data.mat')
    % Parse the inputs
    parse(parser, varargin{:});

    args = parser.Results;

    data = load(args.weight_mat_file);
    fields = fieldnames(data);
    cortical_thickness_weight = data.(fields{1});
    
    [regions,maps] = size(cortical_thickness_weight);
    if regions < maps
        [regions,maps] = deal(maps,regions);
        cortical_thickness_weight = cortical_thickness_weight';
    end

    mask = find(cortical_thickness_weight==-999);
    cortical_thickness_weight(mask) = -0.5;

    for i=1:maps
  
        i_cortical_thickness_weight = cortical_thickness_weight(:,i);
        i_cortical_thickness_weight = invalidateNonSurfaceRegions(i_cortical_thickness_weight);
        %global color min, max
        cmin = min(i_cortical_thickness_weight(:));
        cmax = max(i_cortical_thickness_weight(:));
        range_thresh = 0.1;
        if cmin >= 0 || (-cmin < range_thresh*cmax)
            
            cmap = mycolormap_blue(cmin,cmax);
        else
            cmap = mycolormap(0,range_thresh,cmin,cmax);
        end
        
        idx = important_regions_by_weight(i_cortical_thickness_weight,range_thresh);
        i_cortical_thickness_weight(~idx) = 0;
        i_cortical_thickness_weight(1) = nan;
        i_cortical_thickness_weight(2) = nan;


        [left_cdata, lh_vertex_id, right_cdata, rh_vertex_id,final_cdata,vertex_id]  = convertCorticalThickness2VertexData(path_annot_lh,path_annot_rh,i_cortical_thickness_weight);
        data_label = "";
        
        % Rank the weights based on their absolute value (descending order)
        % threshold_percentage = 20;
        % weights = i_cortical_thickness_weight;
        % abs_weights = abs(weights);
        % [sorted_abs_weights, rank_indices] = sort(abs_weights, 'descend');
        % num_top_weights = ceil((threshold_percentage / 100) * length(weights));
        % top_weights = weights(rank_indices(1:num_top_weights));
        % top_indices = rank_indices(1:num_top_weights);
        % 
        % cmap = mycolormap(middleValue,range_thresh,cmin,cmax)
        % 

       
        % % Get the top weights and their indices
        % top_weights = weights(rank_indices(1:num_top_weights));
        % top_indices = rank_indices(1:num_top_weights);
        % range_thresh = 0.15;
        % % %%
        
        
        %%
        data_all.both = final_cdata;
        data_all.lh = left_cdata;
        data_all.rh = right_cdata;
        climits = [cmin, cmax];
        MyExampleSurfacePlotFunction(surface_all,id_all,data_all,cmap,data_label,climits);
        
      

        % colorbar('hide') 
        % exportgraphics(gcf,sprintf("%s/%s_%i_2.svg",args.dir,args.name,i-1), 'ContentType', 'vector');
        saveas(gcf,sprintf("%s/%s_%i_2.svg",args.dir,args.name,i-1))  
        saveas(gcf,sprintf("%s/%s_%i_2.png",args.dir,args.name,i-1))  

    end
% MyExampleSurfacePlotFunction(surface_all,id_all,data_all,cmap,data_label,climits);
% colormap(cmap)
% saveas(gcf,sprintf("%s/%s_color_bar.svg",args.dir,args.name))

