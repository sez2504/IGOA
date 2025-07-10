% Define directory paths (modify as needed)
data_dir = '/Users/saazgupta/Desktop/Projects/gazzelle/comparison/Results_cec14';  % Replace with your directory containing MAT files
output_dir = fullfile(data_dir, 'csv_converted');  % Creates a new folder named "csv_converted"

% Create the output directory if it doesn't exist
if ~exist(output_dir, 'dir')
  mkdir(output_dir);
end

% Get a list of all MAT files in the data directory
mat_files = dir(fullfile(data_dir, '*.mat'));

% Loop through each MAT file
for i = 1:length(mat_files)
  filename = mat_files(i).name;
  
  % Load data from the MAT file
  data = load(fullfile(data_dir, filename));
  
  % Get the variable names from the MAT file (assuming a single variable)
  var_name = fieldnames(data);
  data_to_save = data.(var_name{1});
  
  % Save data to CSV file
  csvwrite(fullfile(output_dir, [filename(1:end-4), '.csv']), data_to_save);
  
  fprintf('Converted %s to %s.csv\n', filename, filename(1:end-4));
end

disp('All MAT files converted to CSV and saved to csv_converted folder!');