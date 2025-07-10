clc
clear all;

% Search agent parameters
SearchAgents_no = 300;
Max_iteration = 100;
for i =1:13
    if i==10
        continue;
    end
    % Define test function details (replace with your implementation)
    %Function_name = sprintf('F%d', i);

   [dim,lb,ub,vio,glomin,fobj]=ProbInfo(i);

% Run original SCS
% OA

    [~, ~, GOA_curve] = GOA2_eng(SearchAgents_no, Max_iteration, lb, ub, dim, fobj,vio);

% Run modified SCSO
    k = max(1, floor(0.25 * SearchAgents_no));
    [~,~, FHO_curve] = FHO_eng(SearchAgents_no, Max_iteration, lb, ub, dim, fobj,vio);
     [~,~,SCSO_curve]=SCSO_eng(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,vio);
    [~,~,AOA_curve]=AOA_eng(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,2,0.5,vio);
    [~,~,WOA_curve]=WOA_eng(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,vio);
    [~,~,GOA_curve_mod]=GOA16_2_eng(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,vio);
    [~,~,GWO_curve]=GWO_eng(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,vio);
    [~,~,COA_curve,~] = COA_eng(SearchAgents_no,Max_iteration,lb,ub,dim,fobj,vio);
    
    % Plot convergence curves


    % Plot convergence curves
    algorithm_name=num2str(i);
    filename = [algorithm_name, '_', '.png'];
    plot(1:Max_iteration, GOA_curve, 'b-',1:Max_iteration, GOA_curve_mod,1:Max_iteration, FHO_curve, 'g-',1:Max_iteration, SCSO_curve, 'c-',1:Max_iteration, WOA_curve, 'm-',1:Max_iteration, AOA_curve, 'k-',1:Max_iteration, GWO_curve, 'y-',1:Max_iteration, COA_curve, 'bo');  % AOA curve
    xlabel('Iteration');
    ylabel('Fitness');
    legend('GOA', 'MGOA','FHO','SCSO','WOA','AOA','GWO','COA');

    title(fprintf('EngProb%d', i));  % Use sprintf for dynamic title
    % Adjust spacing and appearance (optional)
    set(gca, 'XLim', [1 Max_iteration]);  % Set x-axis limits for consistency
    % tightfig;  % Reduce whitespace around the plot (optional)
    saveas(gcf, ['engallAlgoCurves/', filename]);

end
