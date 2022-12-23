function track = map(data)
%MAP Tracking of $cycles$ steps through maximum a posteriori (MAP).
bounds = [];
unpack(data);
cycles = movementCycles;
sensors = sensors';
p = P;
P = [];
var = 10^(var/10); % convertion from dB
% q = 10;      % State process noise intensity. $q$
% Q = procovm(q, movementPeriod);
            

track = nan(cycles, 2);

problem.nDim = 2;
problem.bounds = bounds;
options.iterations = 30; % 3600 function evaluations
options.nPopulation = 120;
options.nClans = fix(N / 3) + 1;
    
initParams.bounds = bounds;
initParams.sensors = sensors;
initParams.g = g;
initParams.P = p;
initParams.nPopulation = 120;
initParams.nClans = fix(N / 3) + 1;    

% 1st cycle
problem.cost = @(solutions) costFunc2DWeights(solutions, ...
        energies(1,:), g, p, sensors);
    
initParams.energies = energies(1,:);
options.initialPopulation = acousticInitAnyN(initParams)';
X = eeho(problem, options);
track(1,:) = X;
theta = [X', 0, 0]';

global firstTermMean;
global secondTermMean;
global ftmCounter; 
global stmCounter;
firstTermMean = zeros(cycles,1);
secondTermMean = zeros(cycles,1);
ftmCounter = 0;
stmCounter = 0;


R = eye(N) .* var;                 % Measurement noise covariance matrix
P = eye(4);                    % Process covariance matrix
    
global t;
for i = 2:cycles
    t = i;
    
    % Prediction stage
    thetaPrediction = S * theta;
    P = S * P * S' + Q;

    % Update stage
    problem.nDim = 4;
    problem.bounds = [bounds; -5, 5; -5, 5];        
    problem.cost = @(solutions) costFunc4D(solutions, thetaPrediction, ...
        R, P, energies(i,:), g, p, sensors);
    initParams.energies = energies(i,:);
    population = acousticInit(initParams); % Initial positions
    population = [population, repmat(theta(3:4)', initParams.nPopulation, 1)]'; % Initial positions and velocities
    options.initialPopulation = population;
    theta = eeho(problem, options);
    
    P = (theta - thetaPrediction) * (theta - thetaPrediction)';
    
    firstTermMean(t) = firstTermMean(t) / ftmCounter;
    secondTermMean(t) = secondTermMean(t) / stmCounter;
    ftmCounter = 0;
    stmCounter = 0;
    
    track(i,:) = theta(1:2)';

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

function cost = costFunc4D(theta, thetaPrediction, R, P, y, g, p, s)
    N = size(s, 2);
    nTheta = size(theta, 1);
    theta = theta';
    x = theta(1:2,:);
    y = y';
    
%     dEstimated = sqrt(g*p ./ y');
%     w = (dEstimated.^-1 ./ sum(dEstimated.^-1));
    
    d = nan(N, nTheta);
    for i = 1:N
        d(i,:) = vecnorm(x - s(:,i));
    end
    yEstimated = g * p ./ d.^2;
    
    firstTerm = diag((y - yEstimated)' * R^-1 * (y - yEstimated));
    secondTerm = diag((theta - thetaPrediction)' * P^-1 * (theta - thetaPrediction));
    
    global firstTermMean;
    global secondTermMean;
    global ftmCounter; 
    global stmCounter;
    global t;
    firstTermMean(t) = firstTermMean(t) + mean(firstTerm);
    secondTermMean(t) = secondTermMean(t) + mean(secondTerm);
    ftmCounter = ftmCounter + 1;
    stmCounter = stmCounter + 1;
    
    cost = firstTerm + secondTerm;
end