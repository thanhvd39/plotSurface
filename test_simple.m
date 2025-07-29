% Simple test for different atlases
clear; clc;

% Add necessary paths
addpath('utils');
addpath('plotting');
addpath('main');

try
    % Test data generation for different atlas sizes
    fprintf('Testing atlas data compatibility...\n');
    
    % Generate test data for Schaefer 100 (100 regions)
    test_data_100 = randn(100, 1);
    test_data_100(1:20) = test_data_100(1:20) + 2;  % Strong positive regions
    test_data_100(21:40) = test_data_100(21:40) - 1.5;  % Negative regions
    
    % Generate test data for Schaefer 200 (200 regions)  
    test_data_200 = randn(200, 1);
    test_data_200(1:40) = test_data_200(1:40) + 2;  % Strong positive regions
    test_data_200(41:80) = test_data_200(41:80) - 1.5;  % Negative regions
    
    % Save test files
    writematrix(test_data_100, 'data/test_schaefer100.csv');
    writematrix(test_data_200, 'data/test_schaefer200.csv');
    
    fprintf('Test data generated:\n');
    fprintf('  test_schaefer100.csv (100 regions)\n');
    fprintf('  test_schaefer200.csv (200 regions)\n');
    
    % Test if GUI can load
    fprintf('\nTesting GUI...\n');
    if exist('BrainGUI_Simple.m', 'file')
        fprintf('✓ BrainGUI_Simple.m found\n');
    else
        fprintf('✗ BrainGUI_Simple.m not found\n');
    end
    
    fprintf('\nYou can now:\n');
    fprintf('1. Run: BrainGUI_Simple\n');
    fprintf('2. Load test_schaefer100.csv and select Schaefer 100 atlas\n');
    fprintf('3. Load test_schaefer200.csv and select Schaefer 200 atlas\n');
    fprintf('4. Try different colormaps\n');
    
catch ME
    fprintf('Error: %s\n', ME.message);
end
