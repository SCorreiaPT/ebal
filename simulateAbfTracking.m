function results = simulateAbfTracking(data)
% Alpha-beta filter

%% Enviornement Inicialization
tic
PLOT = false;

addpath('optimizers');
addpath('smart-init');
addpath('utils');

% data = load('Dataset.mat');
Mc = data.Mc;                   % Monte Carlo runs
bounds = data.bounds;           % Search area bounds
sensors = data.sensors;         % Sensors/anchors
cycles = data.movementCycles;   % The number of target moving steps
period = data.movementPeriod;   % delta T
g = data.g;
P = data.P;
target = data.target;
N = data.N;
sensors = sensors'; % Sensors/Anchors Placement
alpha = 0.7;
beta = 0.01;
Q = data.Q;     % Process noise covariance matrix
S = data.S;     % State transition matrix
sigNoise = data.sigNoise;


%% Plot Trajetory
if PLOT
    fig = figure;
    
    plot(target(1,:), target(2,:), '+r-');
    hold on
    plot(target(1,1), target(2,1), 'ob');
    xlim([0 60]);
    ylim([0 60]);
    legend('Discretized Trajetory','Location','southeast')
    grid
    
    ai_X = sensors(1, :)';
    ai_Y = sensors(2, :)';
    plot(ai_X,ai_Y,'sg','MarkerEdgeColor',[0.4660 0.6740 0.1880],'MarkerFaceColor',[0.4660 0.6740 0.1880],'MarkerSize',10);
    circle(30, 30, 30,'-.g');
    legend('Discretized Trajetory','Inicial Coordinate','Sensors','Sensors Region','Location','southoutside','NumColumns',2)
    a = annotation('arrow',[0.15 0.25],[0.3 0.3]);
    a.Color = 'blue';
    saveas(fig,strcat('Trajetory_',num2str(N)),'png');
end
    
%% Mc Monte Carlo Runs of the method

problem.nDim = 2;
problem.bounds = bounds;
options.iterations = 30; % 3600 function evaluations
options.nPopulation = 120;
options.nClans = N / 3 + 1;
    
initParams.bounds = bounds;
initParams.sensors = sensors;
initParams.g = g;
initParams.P = P;
initParams.nPopulation = 120;
initParams.nClans = N / 3 + 1;

results = nan(Mc * cycles, 2);

for iMc = 1:Mc
    
    iMcEnergies = data.energies((iMc-1)*cycles+1 : iMc*cycles, :);
    track = zeros(2, cycles);
    C = zeros(4, 4);                 % Process covariance matrix
    
    %% t = 1
    
    % Using EEHO to estimate the target initial position
    energies = iMcEnergies(1,:);
    problem.cost = @(solutions) costFunc2DWeights(solutions, energies, g, P, sensors);
    initParams.energies = energies;
    options.initialPopulation = acousticInit(initParams)';
    X = eeho(problem, options);
    theta = [X', 1, 0]';
    
    track(:,1) = theta(1:2);
    

    for t = 2:cycles
        energies = iMcEnergies(t,:);
        
        % Prediction stage
        thetaPred = S * theta;
        C = S .* C;
        C = S * C * S' + Q;
        
        % Update stage
        problem.nDim = 2;
        problem.bounds = bounds;        
        problem.cost = @(solutions) costFunc2DWeights(solutions, energies,...
            g, P, sensors);
        initParams.energies = energies;
        options.initialPopulation = acousticInit(initParams)';
        
        X = eeho(problem, options);
        
        error = X - thetaPred(1:2); % position error
        gamma = sqrt([C(1,1); C(2,2)]) .* t^2 / sqrt(P * g / sigNoise);
        r = (4 + gamma - sqrt(8*gamma + gamma.^2)) / 4;
        alpha = 1 - r.^2;
        beta = 2 * (2 - alpha) - 4 * sqrt(1 - alpha);
        
        theta(1:2) = thetaPred(1:2) + alpha .* error; % position
        theta(3:4) = thetaPred(3:4) + (beta / period) .* error; % velocity
        
        C = (theta - thetaPred) * (theta - thetaPred)';
        
        track(:,t) = theta(1:2);
    end

    % trajectory plot
    if PLOT
        plot(track(1,:), track(2,:));
    end
    
    if PLOT
        rmse = sqrt((track(1:2,:) - target(1:2,:)).^2);
        figure;
        plot(1:cycles, rmse);
    end
    
    results((iMc-1)*cycles+1 : iMc*cycles, :) = track';
    
%     iMc
end


end

function cost = costFunc2D(x, y, g, P, s)
    N = size(s, 2);
    cost = zeros(size(x, 1), 1);
    for i = 1:N
        d = vecnorm(x - s(:,i)', 2, 2);
        cost = cost + (y(i) - g*P ./ d.^2).^2; 
    end
end

function cost = costFunc2DWeights(x, y, g, P, s)
    N = size(s, 2);
    cost = zeros(size(x, 1), 1);
    dy = sqrt(g*P ./ y');
    w = (dy ./ sum(dy)).^-1;
    for i = 1:N
        d = vecnorm(x - s(:,i)', 2, 2);
        cost = cost + w(i) .* (y(i) - g*P ./ d.^2).^2; 
    end
end

