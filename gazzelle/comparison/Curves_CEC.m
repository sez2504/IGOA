clc
clear all;

% Search agent parameters
SearchAgents_no = 300;
Max_iteration = 100;
for i =1:30
    % if i==2
    %     continue;
    % end
    % Define test function details (replace with your implementation)
    Function_name = sprintf('F%d', i);
    [lb, ub, dim, fobj] = CEC2014(Function_name);

% Run original SCS
% OA

    [~, ~, GOA_curve] = GOA2(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);

% Run modified SCSO
    k = max(1, floor(0.25 * SearchAgents_no));
    [~,~, FHO_curve] = FHO(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);
     [~,~,SCSO_curve]=SCSO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
    [~,~,AOA_curve]=AOA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,2,0.5);
    [~,~,WOA_curve]=WOA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
    [~,~,GOA_curve_mod]=GOA16_2(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
    [~,~,GWO_curve]=GWO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
    [~,~,COA_curve,~] = COA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
    
    % Plot convergence curves


    % Plot convergence curves
    algorithm_name=num2str(i);
    filename = [algorithm_name, '_', '.png'];
    plot(1:Max_iteration, GOA_curve, 'b-',1:Max_iteration, GOA_curve_mod,1:Max_iteration, FHO_curve, 'g-',1:Max_iteration, SCSO_curve, 'c-',1:Max_iteration, WOA_curve, 'm-',1:Max_iteration, AOA_curve, 'k-',1:Max_iteration, GWO_curve, 'y-',1:Max_iteration, COA_curve, 'bo');  % AOA curve
    xlabel('Iteration');
    ylabel('Fitness');
    legend('GOA', 'MGOA','FHO','SCSO','WOA','AOA','GWO','COA');

    title(fprintf('Suite2014_Function%d', i));  % Use sprintf for dynamic title
    % Adjust spacing and appearance (optional)
    set(gca, 'XLim', [1 Max_iteration]);  % Set x-axis limits for consistency
    % tightfig;  % Reduce whitespace around the plot (optional)
    saveas(gcf, ['cec14allAlgoCurves/', filename]);

end
