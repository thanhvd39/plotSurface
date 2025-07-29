function corticalThicknesses = invalidateNonSurfaceRegions(corticalThicknesses)
%INVALIDATENONSURFACEREGIONS Sets NaN for non-surface regions in cortical thickness data.
%   This function updates the first two elements of the input array 
%   to NaN, indicating non-surface regions.

corticalThicknesses(1) = NaN; % Mark non-surface region 1
corticalThicknesses(2) = NaN; % Mark non-surface region 2

end
