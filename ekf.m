function track = ekf(data)
%EKF Tracking of $cycles$ steps through extended kalman-filter (EKF).
bounds = [];
unpack(data);
cycles = movementCycles;
p = P;
P = [];
% var = 10^(var/10); % convertion from dB
std = (g*p) / ( 10^(var / 20) );
var = std^2;
% q = 3;      % State process noise intensity. $q$
% Q = procovm(q, movementPeriod);
            

track = nan(cycles, 2);

problem.nDim = 2;
problem.bounds = bounds;
options.iterations = 30; % 3600 function evaluations
options.nPopulation = 120;
options.nClans = fix(N / 3) + 1;
    
initParams.bounds = bounds;
s = nan(2, N);
for iN = 1:N
    s(:,iN) = sensors{iN}(1,:)';
end
initParams.sensors = s;
initParams.g = g;
initParams.P = p;
initParams.nPopulation = 120;
initParams.nClans = fix(N / 3) + 1;    

% 1st cycle
problem.cost = @(solutions) costFunc2DWeights(solutions, ...
        energies(1,:), g, p, s);
    
initParams.energies = energies(1,:);
options.initialPopulation = acousticInitAnyN(initParams)';
X = eeho(problem, options);
track(1,:) = X;
theta = [X', 0, 0]';


R = eye(N) .* var;                 % Measurement noise covariance matrix
P = eye(4);                    % Process covariance matrix
    
for i = 2:cycles
    previousTheta = theta;
    
    s = nan(2, N);
    for iN = 1:N
        s(:,iN) = sensors{iN}(i,:)';
    end
    initParams.sensors = s;
    
    if any(energies(i,:) > 300)
        theta(1:2) = s(:, energies(i,:) > 300);
        %theta = thetaPrediction;
        track(i,:) = theta(1:2)';
        continue
    end
    
    % Prediction stage
    thetaPrediction = S * theta;
    P = S * P * S' + Q;
    
%     if any(energies(i,:) > 300)
%         %theta(1:2) = s(:, energies(i,:) > 80);
%         theta = thetaPrediction;
%         track(i,:) = theta(1:2)';
%         continue
%     end

    % Calculation of Jacobian matrix
    X = thetaPrediction(1:2);
    diff = X - s;
    d = vecnorm(diff)';
    J = [(-2*g*p .* diff') ./ (d.^4), zeros(N, 2)];

    % Update stage 
    K = P*J' * pinv(J*P*J' + R);
    theta = thetaPrediction + K * (energies(i,:) - (g*p ./ d.^2)')';
%     if any(energies(i,:) > 300)
%         theta = thetaPrediction;
%     end
    P = (eye(4) - K*J) * P;

    % Bounds
    maxSpeed = [-30 30; -30 30];
    maxAcc = [-30 30; -30 30];
    fieldLimits = [0 1000; 0 1000];
    
    bounds = [fieldLimits; maxAcc];
    theta = (theta < bounds(:,1)) .* bounds(:,1) + (theta >= bounds(:,1)) .* theta;
    theta = (theta > bounds(:,2)) .* bounds(:,2) + (theta <= bounds(:,2)) .* theta;
    
    bounds = previousTheta + [maxSpeed; maxAcc];
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