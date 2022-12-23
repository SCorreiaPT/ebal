%% Enhanced Elephant Herding Optimization
% Finds a _solution_ that minimizes the _problem_.
function [solution, cost] = eeho(problem, options)
%% Data initialization
% Default options
nDim = problem.nDim;        % Problem dimensions
cost = problem.cost;        % Cost function
bounds = problem.bounds;    % Matrix with problem bounds: [dim0Lower dim0Upper; dim1Lower dim1Upper; ...]
nPopulation = 120;                    % Population size
nClans = 4;                 % Number of clans
alpha = 0.25;
beta = 0.05;
gamma = 0.015;
elitism = true;

% Replace default options by provided ones
if exist('options', 'var')
   if isfield(options, 'nPopulation')
       nPopulation = options.nPopulation;
   end
   if isfield(options, 'nClans')
       nClans = options.nClans;
   end
   if isfield(options, 'initialPopulation')
      population = options.initialPopulation; 
   end
   if isfield(options, 'iterations')
      iterations = options.iterations; 
   end
   if isfield(options, 'elitism')
      elitism = options.elitism; 
   end
end

if mod(nPopulation, nClans) ~= 0
   error("The defined population size is not divisible by the defined number of clans");  
end

clanSize = nPopulation / nClans;
if ~exist('iterations', 'var')
    iterations = nDim * nPopulation * 20;          % Number of EEHO iterations
end

searchSpaceRange = bounds(:, 2) - bounds(:, 1);
if ~exist('population', 'var')
    population = bounds(:, 1) + rand(nDim, nPopulation) .* searchSpaceRange;
end

% Keep population in bounds
below = population < bounds(:,1);
population = ~below .* population + below .* bounds(:,1);
above = population > bounds(:,2);
population = ~above .* population + above .* bounds(:,2);

%% Loop
converged = false;
i = 1;
while i <= iterations
    for c = 1:nClans
        range = (c-1)*clanSize+1 : c*clanSize;
        clan = population(:, range);
        costs = cost(clan');
        [costs, indexes] = sort(costs);
        clan = clan(:, indexes);
        matriarch = clan(:, 1);
        center = sum(clan, 2) ./ clanSize;
        
        % Convergence test...
        converged = costs(2) - costs(1) < 2 * 0.00005;
        
        % Updating operator
        clan = clan + ...
                alpha * (matriarch - clan) + ...
                beta * (center -clan) + ...
                gamma * (2 * rand(nDim, clanSize) -1) .* searchSpaceRange;
            
        % Separating operator
        clan(:, clanSize) = bounds(:, 1) + rand(nDim, 1) .* searchSpaceRange;
        
        % Keep population in bounds
        below = clan < bounds(:,1);
        clan = ~below .* clan + below .* bounds(:,1);
        above = clan > bounds(:,2);
        clan = ~above .* clan + above .* bounds(:,2);
        
        if elitism
            clan(:, 1) = matriarch;
        end
        
        population(:, range) = clan;
    end
    
    i = i + 1;
end

costs = cost(population');
[cost, index] = min(costs);
solution = population(:, index);

end