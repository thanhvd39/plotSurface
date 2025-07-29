function plot_common_unique_regions(varargin)
    % Create an inputParser object
    parser = inputParser;
    % Define expected arguments
    addParameter(parser, 'weight_mat_file', @isstr);
    addParameter(parser, 'name',"test", @isstr);
    addParameter(parser, 'dir',"./", @isstr);
    addParameter(parser, 'path_annot_lh', @isstr);
    addParameter(parser, 'path_annot_rh', @isstr);
    

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

        %global color min, max
        cmin = min(cortical_thickness_weight(:));
        cmax = max(cortical_thickness_weight(:));
     
        
         
        
        [left_cdata, lh_vertex_id, right_cdata, rh_vertex_id,final_cdata,vertex_id]  = convertCorticalThickness2VertexData(path_annot_lh,path_annot_rh,i_cortical_thickness_weight);
        data_label = "";
        middleValue = (cmin+ cmax)/2;
        % middleValue = 0;
        range_thresh = 0.1;
        cmap = createCustomColormap()
        
        
        data_all.both = final_cdata;
        data_all.lh = left_cdata;
        data_all.rh = right_cdata;
        climits = [cmin, cmax];
        MyExampleSurfacePlotFunction(surface_all,id_all,data_all,cmap,data_label,climits);
        saveas(gcf,sprintf("%s/%s_%i.png",args.dir,args.name,maps))    

end
