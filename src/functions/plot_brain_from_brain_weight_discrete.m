function plot_brain_from_brain_weight_discrete(varargin)
    % Create an inputParser object
    parser = inputParser;
    % Define expected arguments
    addParameter(parser, 'weight', @isnumeric);
    addParameter(parser, 'name', @isstr);
    addParameter(parser, 'dir',"./", @isstr);
    
    run('init.m')
    path_annot_lh = 'lh.Schaefer2018_200Parcels_7Networks_order.annot';
    path_annot_rh = 'rh.Schaefer2018_200Parcels_7Networks_order.annot';
    load('mySurface_data.mat')
    % Parse the inputs
    parse(parser, varargin{:});

    args = parser.Results;

    data = args.weight;

    cortical_thickness_weight = data;
    
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
        cmin = min(cortical_thickness_weight(:));
        cmax = max(cortical_thickness_weight(:));
     
        
         
        
        [left_cdata, lh_vertex_id, right_cdata, rh_vertex_id,final_cdata,vertex_id]  = convertCorticalThickness2VertexData(path_annot_lh,path_annot_rh,i_cortical_thickness_weight);
        data_label = "";
        middleValue = (cmin+ cmax)/2;
        % middleValue = 0;
        range_thresh = 0.15;
        cmap = createCustomColormap();
        
        data_all.both = final_cdata;
        data_all.lh = left_cdata;
        data_all.rh = right_cdata;
        climits = [cmin, cmax];
        MyExampleSurfacePlotFunction(surface_all,id_all,data_all,cmap,data_label,climits);
        
        colorbar('hide') 
        saveas(gcf,sprintf("%s/%s_%i_2.svg",args.dir,args.name,i-1))    

    end
MyExampleSurfacePlotFunction(surface_all,id_all,data_all,cmap,data_label,climits);
colormap(cmap)
saveas(gcf,sprintf("%s/%s_color_bar.svg",args.dir,args.name))

