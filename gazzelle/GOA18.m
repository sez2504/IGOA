function [Top_gazelle_fit,Top_gazelle_pos,Convergence_curve]=GOA18(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

% Determine the number of available workers
numWorkers = gcp('KnowWorkers');

% Define function for gazelle update (can be vectorized for efficiency)
function updatedGazelle = gazelleUpdate(gazelle_i, Elite_i, RL_i, RB_i, S, mu, spredator, R, ub, lb, dim)
    stepsize = zeros(1, dim);
    for j = 1:dim
        r = rand();
        if r > 0.5
            stepsize(j) = sign(RL_i(j) * (RL_i(j) * gazelle(i, j) - Elite_i(j)));
            gazelle_i(j) = gazelle_i(j) + spredator * R * stepsize(j);
        else
            stepsize(j) = sign(RB_i(j) * (RB_i(j) * gazelle(i, j) - Elite_i(j)));
            gazelle_i(j) = gazelle_i(j) + S * mu * R * stepsize(j);
        end
    end
    % Handle boundary violations
    updatedGazelle = gazelle_i;
    updatedGazelle(updatedGazelle > ub) = ub(updatedGazelle > ub);
    updatedGazelle(updatedGazelle < lb) = lb(updatedGazelle < lb);
    return;
end

% Initialize population
Total = SearchAgents_no;
SearchAgents_no = 0.8 * Total;
Top_gazelle_pos = zeros(1, dim);
Top_gazelle_fit = inf;
Convergence_curve = zeros(1, Max_iter);

% Create parallel pool (adjust numWorkers if needed)
pool = parpool(numWorkers);

% Initialize gazelle population (consider vectorized initialization)
gazelle = initialization(Total, dim, ub, lb);
indices = randperm(Total, Total - SearchAgents_no);

Xmin = repmat(ones(1, dim) .* lb, Total, 1);
Xmax = repmat(ones(1, dim) .* ub, Total, 1);

Iter = 0;
PSRs = 0.34;
S = 0.88;
spredator = 0.6;

while Iter < Max_iter

    % Evaluate fitness (vectorize if fobj allows)
    fitness = zeros(Total, 1);
    spmd
        gazelle_local = gazelle(labindex:Total:end, :);
        fitness_local = zeros(numel(gazelle_local(:, 1)), 1);
        for i = 1:size(gazelle_local, 1)
            fitness_local(i) = fobj(gazelle_local(i, :));
        end
        fitness = fitness_local;
    end
    fitness = reshape(fitness, [], 1);

    % Update top gazelle
    [Top_gazelle_fit, bestIdx] = min(fitness);
    Top_gazelle_pos = gazelle(bestIdx, :);

    % Elite selection
    Elite = repmat(Top_gazelle_pos, Total, 1);

    % Update gazelle positions in parallel
    gazelle_updated = zeros(size(gazelle));
    spmd
        i = labindex:Total:end;
        gazelle_local = gazelle(i, :);
        Elite_local = Elite(i, :);
        RL_local = 0.05 * levy(numel(gazelle_local(:, 1)), dim, 1.5);
        RB_local = randn(numel(gazelle_local(:, 1)), dim);
        S_local = S;
        mu_local = 1;
        spredator_local = spredator;
        for gazelle_idx = 1:size(gazelle_local, 1)
            R = rand();
            if ismember(i(gazelle_idx), indices)
                gazelle_updated(i(gazelle_idx), :) = gazelleUpdate(gazelle_local(gazelle_idx, :),Elite_local(gazelle_idx, :),RL_local(gazelle_idx, :), RB_local(gazelle_idx, :),S_local, mu_local, spredator_local, R, ub, lb, dim);
            else
                mu_local = ifelse(mod(Iter, 2) == 0, 1, -1);
                gazelle_updated(i(gazelle_idx), :) = gazelleUpdate(gazelle_local(gazelle_idx, :), ...
                                                                   Elite_local(gazelle_idx, :), ...
                                                                   RL_local(gazelle_idx, :), RB_local(gazelle_idx, :), ...
                    S_local, mu_local, spredator_local, R, ub, lb, dim);
            end
        end
    end
    gazelle = gazelle_updated;

    % PSR update
    if rand() < PSRs
        U = rand(Total, dim) < PSRs;
        gazelle = gazelle + CF * ((Xmin + rand(Total, dim) .* (Xmax - Xmin)) .* U);
    else
        r = rand();
        Rs = size(gazelle, 1);
        stepsize = (PSRs * (1 - r) + r) * (gazelle(randperm(Rs), :) - gazelle(randperm(Rs), :));
        gazelle = gazelle + stepsize;
    end

    Iter = Iter + 1;
    Convergence_curve(Iter) = Top_gazelle_fit;

end

% Shutdown parallel pool
delete(pool);

end

                               
