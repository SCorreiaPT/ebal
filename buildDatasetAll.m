addpath('data-generation');
addpath('utils');

OUT_DIR = "/home/joaompfe/MatlabProjects/Fire/data/datasets/100";


if ~exist('Mc', 'var')
   Mc = 100;            % Monte Carlo runs
end

vN = [3 4 5];
var = 100:5:120; % SNR

for iN=vN
    for ivar=var
        data = buildDataset(Mc, iN, ivar, @firefighterTrajectory);
        filename = "TrajectoryN" + num2str(iN) + "V" + num2str(abs(ivar));
        save(OUT_DIR + "/" + filename + ".mat", 'data', '-v7.3');
    end
end