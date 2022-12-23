function ofs = optimizationFunctions()

    % Ackley function
    Ackley.cost = @ackleyCost;
    Ackley.bounds = [-5.12 5.12; -5.12 5.12];
    Ackley.nDim = 2;
    
    ofs.Ackley = Ackley; % Global minimum at (0,0)
    
    % Rastrigin 20 dimensions
    Rastrigin.cost = @rastriginCost;
    Rastrigin.bounds = ones(20,2) .* [-5.12 5.12];
    Rastrigin.nDim = 20;
    
    ofs.Rastrigin = Rastrigin; % Global minimum at (0,0,...,0)
    
    % Eddholder
    Eddholder.cost = @eggholderCost;
    Eddholder.bounds = ones(2,2) .* [-512 512];
    Eddholder.nDim = 2;
    
    ofs.Eddholder = Eddholder; % Global minimum at (512,404.2319), f = -959.6407
end

function cost = ackleyCost(solutions)

x = solutions(:,1);
y = solutions(:,2);

cost = -20 * exp(-0.2 * (0.5 * (x.^2 + y.^2)).^0.5) ...
       -exp(0.5 * (cos(2*pi*x) + cos(2*pi*y))) + exp(1) + 20;
     
end

function cost = rastriginCost(solutions)

A = 10;
n = size(solutions, 2);
cost = sum(solutions.^2 - A*cos(2*pi.*solutions), 2) + A*n;
end

function cost = eggholderCost(solutions)

x = solutions(:,1);
y = solutions(:,2);

cost = -(y+47) .* sin(abs(x/2 + (y+47)) .^ 0.5) - ...
       x .* sin(abs(x + (y+47)) .^ 0.5);
end