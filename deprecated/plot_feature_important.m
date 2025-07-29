function plot_feature_important(varargin)
    % Create an inputParser object
    parser = inputParser;

    % Define expected arguments
    addParameter(parser, 'csv_file', @isstr);
    addParameter(parser, 'name',"test", @isstr);
    addParameter(parser, 'dir',"./", @isstr);
    

    path_annot_lh = 'h.Schaefer2018_200Parcels_17Networks_order.annot';
    path_annot_rh = 'rh.Schaefer2018_200Parcels_17Networks_order.annot';

    load('/Users/tth/Thanh/plotSurface/mySurface_data.mat')
    % Parse the inputs
    parse(parser, varargin{:});

    args = parser.Results;

    data = readtable(args.csv_file);

    feature_important = table2array(sum(data(:,:),2));


    
   
    feature_important_left = feature_important(1:100);
    feature_important_right = feature_important(101:end);
    i_cortical_thickness_weight = []
    for ii=1:100
        i_cortical_thickness_weight =[feature_important_left(ii);feature_important_right(ii) ;i_cortical_thickness_weight]
    end

    i_cortical_thickness_weight = [nan;nan;i_cortical_thickness_weight];
    % i_cortical_thickness_weight = feature_important;

    %global color min, max
    cmin = min(feature_important);
    cmax = max(feature_important);
 
    
     
    
    [left_cdata, lh_vertex_id, right_cdata, rh_vertex_id,final_cdata,vertex_id]  = convertCorticalThickness2VertexData(path_annot_lh,path_annot_rh,feature_important);
    data_label = "";
    middleValue = (cmin+ cmax)/2;
    % middleValue = 0;
    range_thresh = 0.1;
    % cmap = mycolormap(middleValue,range_thresh,cmin,cmax);
    % cmap = zeros(3,3);
    % cmap(2,:) = [247,218,218]/255; %red
    % cmap(3,:) = [164,46,42]/255;   %gray
    % cmap(1,:) = [228,246,249]/255;   %gray

    
    cmap =turbo(4);
    cmap = [[1,1,1];cmap];
    
    data_all.both = final_cdata;
    data_all.lh = left_cdata;
    data_all.rh = right_cdata;
    climits = [cmin, cmax];
    MyExampleSurfacePlotFunction(surface_all,id_all,data_all,cmap,data_label,climits);
    saveas(gcf,sprintf("%s/%s_%i.png",args.dir,args.name,maps))    

end
