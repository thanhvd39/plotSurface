clc;
clear;
close all;

% Initialize the data cell array. The first row will be the headers (subject names).
data = {};

% Loop over all discs
for j = 1:11 
    % Loop over all subjects (assuming 500 subjects per disc)
    for i = 1:500
        % Prepare the file path
        tmp = "/media/localadmin/KIOXIA/Thanh/OASIS/disc1/OAS1_0001_MR1/label/catROIs_lh.thickness.mat";
        tmp = strrep(tmp, "disc1", sprintf('disc%i', j));
        tmp = strrep(tmp, "0001", sprintf('%04.0f', i));
        
        % Check if the file exists
        if ~exist(tmp, 'file')
            continue; % Skip this iteration if the file does not exist
        end
        
        % Load the .mat file
        load(tmp)
        
        % Extract the thickness data
        thickness = S.Schaefer2018_200Parcels_17Networks_order.data.thickness;
        
        % Store the subject name as 'OAS1_xxxx_MR1'
        subjectName = sprintf('OAS1_%04.0f_MR1', i);
        
        % If this is the first subject, initialize the data cell array with headers
        if isempty(data)
            % Initialize the first row with the header 'Subject' and subject name
            % Initialize the first column with indices (1:202) and corresponding thickness values
            data = [{'Index'}, subjectName; num2cell((1:length(thickness))'), num2cell(thickness)];
        else
            % Add the subject name as a new header in the first row
            data(1, end + 1) = {subjectName};
            
            % Add the thickness data as a new column (ensure consistent column lengths)
            data(2:end, end) = num2cell(thickness);
        end
    end
    
    % Uncomment this line if you want to break after the first disc
    % break;
end

% Convert the cell array to a table for easier handling and saving (if needed)
T = cell2table(data(2:end, :), 'VariableNames', data(1, :));

% Display the table
disp(T);

% Optionally, save the table to a CSV file
% writetable(T, 'thickness_data.csv');
