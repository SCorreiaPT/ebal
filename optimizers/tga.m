function solution = tga(problem, options)

% Parameters setup

N = 100; N1 = 20; N2 = 20; N3 = 60; N4 = 40; theta = 0.2; lambda = 0.5;
nDim = problem.nDim;
maxIterations = N * nDim * 10; 

if exist('options', 'var')
    N = options.N;           % Population total size
    N1 = options.N1;         % Best trees group size
    N2 = options.N2;         % Competition trees group size
    N3 = N - N1 - N2;           % Remove trees group size
    N4 = options.N4;         % Reproduction group size
    theta = options.theta;
    lambda = options.lambda;
end

% Ranges to simplify access to trees matrix.
iN1 = 1 : N1;
iN2 = N1+1 : N1+N2;
iN3 = N1+N2+1 : N1+N2+N3;

% Begin of the optimiaztion procedure
wb = waitbar(0, 'Optimizing...');

trees = initializeTrees(problem, N);
costs = problem.cost(trees);
[~,iBest] = sort(costs);
trees = trees(iBest,:);

bestCostOverIterations = zeros(maxIterations, 1);

iterations = 0; %TODO usar max func evals
while iterations < maxIterations
    
    % Update N1 best trees by Eq. 1
    newBestTrees = trees(iN1,:) ./ theta + rand(N1,1) .* trees(iN1,:);
    newBestTrees = keepInBounds(problem, newBestTrees);
    newBestTreesCosts = problem.cost(newBestTrees);
    isBetter = costs(iN1) > newBestTreesCosts;
    trees(iN1,:) = isBetter .* newBestTrees + (1-isBetter) .* trees(iN1,:);
    costs(iN1) = isBetter .* newBestTreesCosts + (1-isBetter) .* costs(iN1);
    
    % Update N2 competition trees
    y = zeros(N2, nDim);
    for iTree = iN2
        tree = trees(iTree);
        distances = sum((trees(iN1,:) - tree) .^2, 2) .^ 0.5;
        [~, iClosest] = min(distances);
        x1 = trees(iClosest);         % Closest tree from best trees group
        distances(iClosest) = inf;
        [~, iClosest] = min(distances);
        x2 = trees(iClosest);         % 2nd closest tree from best trees group
        
        y(iTree-N1, :) = lambda * x1 + (1-lambda) * x2; % Eq. 3
    end
    newCompetitionTrees = trees(iN2,:) + rand(N2,1) .* y; % Eq. 4
    newCompetitionTrees = keepInBounds(problem, newCompetitionTrees);
    newCTCosts = problem.cost(newCompetitionTrees);
    isBetter = costs(iN2) > newCTCosts;
    trees(iN2,:) = isBetter .* newCompetitionTrees + ....
                   (1-isBetter) .* trees(iN2,:);
    costs(iN2) = isBetter .* newCTCosts + ....
                   (1-isBetter) .* costs(iN2);
    
    % Upadate N3 by randomly generate new solutions in the search space.
    trees(iN3,:) = randomTrees(problem.bounds, nDim, N3);
    costs(iN3) = problem.cost(trees(iN3,:));
    
    % Reproduction group, N4
    reprod = randomTrees(problem.bounds, nDim, N4);
    mask = rand(N4, nDim);
    [~,iBest] = min(costs);
    best = trees(iBest);
    reprod = mask .* reprod + (1-mask) .* best;
    reprodCosts = problem.cost(reprod);
    
    % Create new population of trees
    allTrees = [trees; reprod];
    allCosts = [costs; reprodCosts];
    [~,iBest] = sort(allCosts);
    trees = allTrees(iBest(1:N),:);
    costs = allCosts(iBest(1:N),:);
    
    iterations = iterations + 1;
    bestCostOverIterations(iterations) = costs(1);
    waitbar(iterations/maxIterations, wb, 'Optimizing...');
end

close(wb);

plot(1:maxIterations, bestCostOverIterations);

solution = trees(1,:);

end % End tga

function trees = keepInBounds(problem, trees)

bounds = problem.bounds;
belowBounds = trees < bounds(:,1)';
aboveBounds = trees > bounds(:,2)';

trees = ~(belowBounds | aboveBounds) .* trees + ... 
        belowBounds .* bounds(:,1)' + aboveBounds .* bounds(:,2)';

end

function trees = randomTrees(bounds, nDimensions, nTrees)
% 'trees' will be a nTrees * nDimensions matrix, where the dimensions are
% randomly initialized following uniform distribuition between the bounds.
trees = rand(nTrees, nDimensions) .* (bounds(:,2) - bounds(:,1))' + ...
        bounds(:,1)';
end

function trees = initializeTrees(problem, nTrees)
% 'bounds' must be a N * 2 matrix, where N means the number of dimensions.
% The lower bounds must be in the first column, and the upper bounds in the
% second column.

nDimensions = problem.nDimensions;
bounds = problem.bounds;

trees = randomTrees(bounds, nDimensions, nTrees);
end