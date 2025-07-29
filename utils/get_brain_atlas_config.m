function atlas_config = get_brain_atlas_config()
% Get configuration for all supported brain atlases
% Each atlas has specific parameters like file names, region counts, etc.

% Define all supported atlases
atlas_config = struct();

%% Schaefer 2018 - 200 Parcels (7 Networks)
atlas_config.schaefer200 = struct();
atlas_config.schaefer200.name = 'Schaefer 200 Parcels (7 Networks)';
atlas_config.schaefer200.short_name = 'Schaefer200';
atlas_config.schaefer200.num_regions = 200;
atlas_config.schaefer200.lh_annot = 'lh.Schaefer2018_200Parcels_7Networks_order.annot';
atlas_config.schaefer200.rh_annot = 'rh.Schaefer2018_200Parcels_7Networks_order.annot';
atlas_config.schaefer200.description = '200 cortical parcels organized into 7 canonical networks';
atlas_config.schaefer200.reference = 'Schaefer et al. (2018) Cerebral Cortex';

%% HCP Multi-Modal Parcellation (MMP) 
atlas_config.hcp_mmp = struct();
atlas_config.hcp_mmp.name = 'HCP Multi-Modal Parcellation (MMP)';
atlas_config.hcp_mmp.short_name = 'HCP-MMP';
atlas_config.hcp_mmp.num_regions = 360; % 180 per hemisphere
atlas_config.hcp_mmp.lh_annot = 'lh.HCPMMP1.annot';
atlas_config.hcp_mmp.rh_annot = 'rh.HCPMMP1.annot';
atlas_config.hcp_mmp.description = '360 cortical areas based on multi-modal neuroimaging';
atlas_config.hcp_mmp.reference = 'Glasser et al. (2016) Nature';

%% Schaefer 2018 - 100 Parcels (7 Networks) - if files exist
atlas_config.schaefer100 = struct();
atlas_config.schaefer100.name = 'Schaefer 100 Parcels (7 Networks)';
atlas_config.schaefer100.short_name = 'Schaefer100';
atlas_config.schaefer100.num_regions = 100;
atlas_config.schaefer100.lh_annot = 'lh.Schaefer2018_100Parcels_7Networks_order.annot';
atlas_config.schaefer100.rh_annot = 'rh.Schaefer2018_100Parcels_7Networks_order.annot';
atlas_config.schaefer100.description = '100 cortical parcels organized into 7 canonical networks';
atlas_config.schaefer100.reference = 'Schaefer et al. (2018) Cerebral Cortex';

%% Schaefer 2018 - 400 Parcels (7 Networks) - if files exist
atlas_config.schaefer400 = struct();
atlas_config.schaefer400.name = 'Schaefer 400 Parcels (7 Networks)';
atlas_config.schaefer400.short_name = 'Schaefer400';
atlas_config.schaefer400.num_regions = 400;
atlas_config.schaefer400.lh_annot = 'lh.Schaefer2018_400Parcels_7Networks_order.annot';
atlas_config.schaefer400.rh_annot = 'rh.Schaefer2018_400Parcels_7Networks_order.annot';
atlas_config.schaefer400.description = '400 cortical parcels organized into 7 canonical networks';
atlas_config.schaefer400.reference = 'Schaefer et al. (2018) Cerebral Cortex';

%% Desikan-Killiany Atlas - if files exist
atlas_config.desikan = struct();
atlas_config.desikan.name = 'Desikan-Killiany Atlas';
atlas_config.desikan.short_name = 'DK';
atlas_config.desikan.num_regions = 68; % 34 per hemisphere
atlas_config.desikan.lh_annot = 'lh.aparc.annot';
atlas_config.desikan.rh_annot = 'rh.aparc.annot';
atlas_config.desikan.description = '68 cortical regions based on gyral/sulcal anatomy';
atlas_config.desikan.reference = 'Desikan et al. (2006) NeuroImage';

%% Destrieux Atlas - if files exist
atlas_config.destrieux = struct();
atlas_config.destrieux.name = 'Destrieux Atlas';
atlas_config.destrieux.short_name = 'Destrieux';
atlas_config.destrieux.num_regions = 148; % 74 per hemisphere
atlas_config.destrieux.lh_annot = 'lh.aparc.a2009s.annot';
atlas_config.destrieux.rh_annot = 'rh.aparc.a2009s.annot';
atlas_config.destrieux.description = '148 cortical regions with detailed sulcal/gyral parcellation';
atlas_config.destrieux.reference = 'Destrieux et al. (2010) NeuroImage';

end
