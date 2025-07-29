% Test script to verify atlas selection is working correctly
% This script will test different atlases with appropriate test data

clear all; close all;

% Change to the main project directory
cd('/Users/tth/Thanh/plotSurface');

% Add all necessary paths
addpath('./main');
addpath('./plotting'); 
addpath('./utils');

fprintf('Testing multi-atlas brain plotting functionality...\n');

%% Test 1: Schaefer 200 (default)
fprintf('\n=== Test 1: Testing Schaefer 200 atlas ===\n');
try
    % Generate test data for 200 regions
    test_data_200 = randn(200, 1) * 0.5;
    
    plot_brain_from_brain_weight('weight', test_data_200, ...
                               'name', 'test_schaefer200', ...
                               'dir', './output', ...
                               'atlas', 'schaefer200');
    fprintf('✅ Schaefer 200 atlas test passed\n');
catch ME
    fprintf('❌ Schaefer 200 atlas test failed: %s\n', ME.message);
end

%% Test 2: HCP-MMP 360
fprintf('\n=== Test 2: Testing HCP-MMP atlas ===\n');
try
    % Generate test data for 360 regions  
    test_data_360 = randn(360, 1) * 0.5;
    
    plot_brain_from_brain_weight('weight', test_data_360, ...
                               'name', 'test_hcp_mmp', ...
                               'dir', './output', ...
                               'atlas', 'hcp_mmp');
    fprintf('✅ HCP-MMP atlas test passed\n');
catch ME
    fprintf('❌ HCP-MMP atlas test failed: %s\n', ME.message);
end

%% Test 3: Schaefer 100
fprintf('\n=== Test 3: Testing Schaefer 100 atlas ===\n');
try
    % Generate test data for 100 regions
    test_data_100 = randn(100, 1) * 0.5;
    
    plot_brain_from_brain_weight('weight', test_data_100, ...
                               'name', 'test_schaefer100', ...
                               'dir', './output', ...
                               'atlas', 'schaefer100');
    fprintf('✅ Schaefer 100 atlas test passed\n');
catch ME
    fprintf('❌ Schaefer 100 atlas test failed: %s\n', ME.message);
end

fprintf('\n=== Testing completed ===\n');
