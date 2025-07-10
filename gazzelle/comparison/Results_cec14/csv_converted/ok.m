% Load the CSV file
csv_data = csvread('./mgoa_scores.csv');

% Transpose the matrix
transposed_data = csv_data';

% Save the transposed matrix to a new CSV file
csvwrite('./mgoa_scores.csv', transposed_data);
