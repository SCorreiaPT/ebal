function data = buildDataset(Mc, N, var, buildTrajectory)
%% Inicializations
bounds = [0, 1000; 0, 1000];	% Search space bounds                                     

movementPeriod = 1;         % Time sample in seconds. $\Delta t$
movementCycles = 901;       % Time in seconds. $T = 110$
S = transitionm(2);         % State transition matrix. $S$

P = 20;                  % Power
b = 2;                  % Decay factor
g = 100;                  % Sensor gain

% Covariance Matrix
sigNoise = 3.5e-3;      % State process noise intensity. $q$
Q = sigNoise * [movementPeriod^3/3, 0, movementPeriod^2/2, 0; ...
                0, movementPeriod^3/3, 0, movementPeriod^2/2; ...
                movementPeriod^2/2, 0, movementPeriod, 0; ...
                0, movementPeriod^2/2, 0, movementPeriod];  % State process noise covariance. $Q$

% Sensors/Anchors Placement
sensors = drones();

target = buildTrajectory(movementPeriod);

%% Trajetory Data

% Distance to Sensors
distances = nan(N,movementCycles);
for iN=1:N
    distances(iN,:) = vecnorm(target(1:2, :) - sensors{iN}');
end

% Acoustic energy
energies = g * P ./ (distances'.^2);    % $y$
% std = sqrt(10^(var/10));                % $\sigma$
std = (g*P) / ( 10^(var / 20) );

% Measurement noise
dev = normrnd(0, std, movementCycles*Mc, N);
energies = repmat(energies, Mc, 1) + dev;
energies(energies<0) = 0.05;    % Replace negative measures

%% Save data structure
data.bounds = bounds;
data.movementPeriod = movementPeriod;
data.movementCycles = movementCycles;
data.S = S;
data.N = N;
data.Mc = Mc;
data.P = P;
data.b = b;
data.g = g;
data.var = var;
data.sigNoise = sigNoise;
data.Q = Q;
data.sensors = sensors;
data.target = target;
data.distances = distances;
data.dev = dev;
data.energies = energies;

end
