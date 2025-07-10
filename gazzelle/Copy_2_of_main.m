clear all
clc
format long

% Define parameters
SearchAgents_no = 300; % Number of search agents
Max_iteration = 100; % Maximum number of iterations
Num_iterations = 3; % Number of iterations to average over

% Initialize variables to store average results and standard deviations
average_results_GOA6 = zeros(30, 1);
std_dev_GOA6 = zeros(30, 1);
average_results_GOA2 = zeros(30, 1);
std_dev_GOA2 = zeros(30, 1);

% Loop through each function
for i = 1:30
    if i == 2
        continue
    end
    % Initialize variables to store results for each iteration
    results_GOA6 = zeros(Num_iterations, 1);
    results_GOA2 = zeros(Num_iterations, 1);

    %SearchAgents_no=randi([45, 49]);
    
    for j = 1:Num_iterations
        % Get function details
        Function_name = ['F', num2str(i)];
        [lb, ub, dim, fobj] = CEC2017(Function_name);

        % Run GOA6 algorithm
        [Best_score_6, ~, ~] = GOA19(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);
        results_GOA6(j) = Best_score_6;

        % Run GOA2 algorithm
        [Best_score_2, ~, ~] = GOA2(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);
        results_GOA2(j) = Best_score_2;
    end
    
    % Calculate average results and standard deviations
    average_results_GOA6(i) = mean(results_GOA6);
    std_dev_GOA6(i) = std(results_GOA6);
    average_results_GOA2(i) = mean(results_GOA2);
    std_dev_GOA2(i) = std(results_GOA2);
end

% Display results in tabular form
fprintf('Function\tAverage GOA6 Optimal Value\tStd Dev GOA6\tAverage GOA2 Optimal Value\tStd Dev GOA2\n');
for i = 1:30
    fprintf('%d\t\t%s\t\t%s\t\t%s\t\t%s\n', i , num2str(average_results_GOA6(i)), num2str(std_dev_GOA6(i)), num2str(average_results_GOA2(i)), num2str(std_dev_GOA2(i)));
end
