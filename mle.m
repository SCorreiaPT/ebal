function track = mle(data)
%MLE Tracking of $cycles$ steps through maximum likelihood estimation (MLE).
bounds = [];
unpack(data);
cycles = movementCycles;
p = P;
P = [];

track = nan(cycles, 2);

problem.nDim = 2;
problem.bounds = bounds;
options.iterations = 30; % 3600 function evaluations
options.nPopulation = 120;
options.nClans = fix(N / 3) + 1;
    
initParams.bounds = bounds;
initParams.g = g;
initParams.P = p;
initParams.nPopulation = 120;
initParams.nClans = fix(N / 3) + 1;    


for t = 1:cycles
    
    s = nan(2, N);
    for iN = 1:N
        s(:,iN) = sensors{iN}(t,:)';
    end
    initParams.sensors = s;
    problem.cost = @(solutions) costFunc2DWeights(solutions, ...
        energies(t,:), g, p, s);
    
    initParams.energies = energies(t,:);
    options.initialPopulation = acousticInitAnyN(initParams)';
    track(t,:) = eeho(problem, options);
    
end

end

function cost = costFunc2DWeights(x, y, g, p, s)
    N = size(s, 2);
    cost = zeros(size(x, 1), 1);
    dy = sqrt(g*p ./ y');
    w = (dy.^-1 ./ sum(dy.^-1));
    for i = 1:N
        d = vecnorm(x - s(:,i)', 2, 2);
        cost = cost + w(i) .* abs(dy(i) - d); 
    end
end