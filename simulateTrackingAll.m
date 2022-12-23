addpath('optimizers');
addpath('smart-init');
addpath('utils');

IN_DATA_DIR='/home/joaompfe/MatlabProjects/Fire/data/datasets/100';
OUT_DATA_DIR='/home/joaompfe/MatlabProjects/Fire/data/results/100';

method = 'ekf'; % mle, map, kalman, or ekf

N = [3 4 5];
V = 105:5:120;
q = [0.6];

for iq = q
    for n = N
        for v = V
            dataFile = sprintf("%s/TrajectoryN%dV%d.mat", IN_DATA_DIR, n, abs(v));
            load(dataFile, 'data');

            data.q = iq;
            data.Q = procovm(data.q, data.movementPeriod);
            results = runMonteCarlo(data, str2func(method));

            options.dir = OUT_DATA_DIR;
            options.method = method;
            options.N = n;
            options.V = v;
            options.q = iq;
            options.M = data.Mc;
            saveResult(results, options);

            n
            v
        end
    end
end