% Assume 'results1' and 'results2' are two 30x1 matrices representing the
% performance of two different algorithms on the same set of problems.

% Combine the results into a single matrix
results_combined = [results1, results2];

% Perform Friedman rank test
[p, tbl, stats] = friedman(results_combined);

% Display the p-value
fprintf('P-value of the Friedman test: %f\n', p);

% Get the critical value for significance level 0.05
q = icdf('F', 0.95, 2-1, (2-1)*(30-1)); % for two algorithms and 30 datasets/problems

% Compare the test statistic with the critical value
if stats.chisq > q
    fprintf('The Friedman test indicates significant differences between the two algorithms.\n');
else
    fprintf('The Friedman test does not indicate significant differences between the two algorithms.\n');
end

% If significant differences are found, perform post-hoc analysis (e.g., Nemenyi test)
if p < 0.05
    % Perform post-hoc analysis (e.g., Nemenyi test)
    [~, ~, c] = multcompare(stats);
    % Display the comparison results
    fprintf('Pairwise comparison results:\n');
    disp(c);
end

