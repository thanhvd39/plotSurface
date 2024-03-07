
clc,
close all;
clear;

% load('/Users/tth/Thanh/plotSurface/gender_test.mat')
% load('/Users/tth/Thanh/plotSurface/AD_MCI_test.mat')

load('mySurface_data.mat')
PQ = rand(202,1)';

corticalThicknesses = reshape(PQ,[202,1]);
cmin = min(corticalThicknesses(:));
cmax = max(corticalThicknesses(:));
% cmin = 2;
% cmax =0 ;
corticalThicknesses(1) = NaN;
corticalThicknesses(2) = NaN;


[left_cdata, lh_vertex_id, right_cdata, rh_vertex_id,final_cdata,vertex_id]  = convertCorticalThickness2VertexData(corticalThicknesses);
data_label = "";
middleValue = 0;
range_thresh = 0.05;
%cmap = mycolormap(middleValue,range_thresh,cmin,cmax);
cmap = jet(100);

% surface_all.both = g_mesh;
% surface_all.lh = g_lh;
% surface_all.rh = g_rh;
% 
% id_all.both = vertex_id;
% id_all.lh = lh_vertex_id;
% id_all.rh = rh_vertex_id;

data_all.both = final_cdata;
data_all.lh = left_cdata;
data_all.rh = right_cdata;
climits = [cmin, cmax];
MyExampleSurfacePlotFunction(surface_all,id_all,data_all,cmap,data_label,climits);
% ExampleSurfacePlotFunction(g_lh,lh_vertex_id,left_cdata,cmap,data_label);
% ExampleSurfacePlotFunction(g_rh,rh_vertex_id,right_cdata,cmap,data_label);
% ExampleSurfacePlotFunction(g_mesh,vertex_id,final_cdata,cmap,data_label);
% if i == 1
%     saveas(gcf,sprintf("PQ_MCI_HC.png", i))
% elseif i ==2
%     saveas(gcf,sprintf("PQ_AD_MCI.png", i))
% elseif i==3 
%     saveas(gcf,sprintf("PQ_AD_HC.png", i))
% end
% % break
% end