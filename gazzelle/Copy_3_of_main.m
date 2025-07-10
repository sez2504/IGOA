clear all
clc
format long

% Define parameters
SearchAgents_no = 50; % Number of search agents
Max_iteration = 1000; % Maximum number of iterations
Num_iterations = 5; % Number of iterations to average over

% Initialize variables to store average results and standard deviations
average_results_GOA6 = zeros(23, 1);
std_dev_GOA6 = zeros(23, 1);
average_results_GOA2 = zeros(23, 1);
std_dev_GOA2 = zeros(23, 1);

% Loop through each function
for k = 1:Num_iterations
    
    random_int = randi([0, SearchAgents_no]);
    disp(random_int);
    % Initialize variables to store results for each iteration
    results_GOA6 = zeros(23, 1);
    
    for j = 1:23
        if j == 2
            continue
        end
        % Get function details
        Function_name = ['F', num2str(j)];
        [lb, ub, dim, fobj] = CEC2017(Function_name);

        % Run GOA6 algorithm
        [Best_score_6, ~, ~] = GOA8(random_int, Max_iteration, lb, ub, dim, fobj);
        results_GOA6(j) = Best_score_6;

    end
    % Initialize a string to store the results
    result_string = '';

    for i = 1:23
    % Concatenate the function index and its result to the result string
        result_string = [result_string, sprintf('%s\t',num2str(results_GOA6(i)))];
    end

    % Display the result string
    disp(result_string);
end

% Display results in tabular form

