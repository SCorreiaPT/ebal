function track = kalman(data)
%EKF Tracking of $cycles$ steps through kalman-filter (EKF).
bounds = [];
unpack(data);
cycles = movementCycles;
sensors = sensors';
p = P;
P = [];
var = 10^(var/10); % convertion from dB
% q = 3;      % State process noise intensity. $q$
% Q = procovm(q, movementPeriod);
            

track = nan(cycles, 2);

problem.nDim = 2;
problem.bounds = bounds;
options.iterations = 30; % 3600 function evaluations
options.nPopulation = 120;
options.nClans = N / 3 + 1;
    
initParams.bounds = bounds;
initParams.sensors = sensors;
initParams.g = g;
initParams.P = p;
initParams.nPopulation = 120;
initParams.nClans = N / 3 + 1;    

% 1st cycle
problem.cost = @(solutions) costFunc2DWeights(solutions, ...
        energies(1,:), g, p, sensors);
    
initParams.energies = energies(1,:);
options.initialPopulation = acousticInit(initParams)';
X = eeho(problem, options);
track(1,:) = X;
theta = [X', 0, 0]';


R = [12.2551 0; 0 11.7871];     % Measurement noise covariance matrix
P = eye(4);                     % Process covariance matrix
H = [eye(2, 2) zeros(2, 2)];    % Observation model
    
for i = 2:cycles
    
    % Prediction stage
    thetaPrediction = S * theta;
    P = S * P * S' + Q;

    % Update stage 
    K = P*H' * (H*P*H' + R)^-1;
    problem.cost = @(solutions) costFunc2DWeights(solutions, ...
        energies(i,:), g, p, sensors);
    initParams.energies = energies(i,:);
    options.initialPopulation = acousticInit(initParams)';
    X = eeho(problem, options);
    
    
    theta = thetaPrediction + K * (X - H*thetaPrediction);
    P = (eye(4) - K*H) * P;

    % Bounds
    bounds = [0 50; 0 50; -5 5; -5 5];
    theta = (theta < bounds(:,1)) .* bounds(:,1) + (theta >= bounds(:,1)) .* theta;
    theta = (theta > bounds(:,2)) .* bounds(:,2) + (theta <= bounds(:,2)) .* theta;

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