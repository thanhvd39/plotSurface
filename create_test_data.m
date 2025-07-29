% Create a simple test data file for demonstration
rng(42); % Fixed seed for reproducibility

% Generate test data for Schaefer 200 atlas
test_data = randn(200, 1) * 0.8;

% Add some structure to make visualization more interesting
test_data(1:50) = test_data(1:50) + 2.0;      % Strong positive regions
test_data(51:100) = test_data(51:100) - 1.5;  % Strong negative regions
test_data(101:150) = test_data(101:150) * 0.2; % Weak signals
test_data(151:200) = test_data(151:200) + 0.5; % Moderate positive

% Save to CSV file for testing
output_dir = fullfile(pwd, 'data', 'simulated');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

csv_file = fullfile(output_dir, 'colormap_test_data.csv');
writematrix(test_data, csv_file);

fprintf('Test data created: %s\n', csv_file);
fprintf('Data characteristics:\n');
fprintf('  Regions: %d\n', length(test_data));
fprintf('  Range: %.3f to %.3f\n', min(test_data), max(test_data));
fprintf('  Mean: %.3f ± %.3f\n', mean(test_data), std(test_data));
fprintf('  Non-zero: %d/%d\n', sum(test_data ~= 0), length(test_data));

fprintf('\nYou can now:\n');
fprintf('1. Run BrainGUI_Simple\n');
fprintf('2. Click "Load Simulated Data"\n');
fprintf('3. Select "colormap_test_data.csv"\n');
fprintf('4. Choose different colormaps from the dropdown\n');
fprintf('5. Click "Preview" to see colormap visualization\n');
fprintf('6. Click "PLOT BRAIN SURFACE" to generate brain plots\n');
