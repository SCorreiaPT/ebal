addpath('plot');
addpath('utils');
addpath('data-generation');


IN_DATA_DIR='/home/joaompfe/MatlabProjects/Fire/data/datasets/100';
RESULTS_DIR='/home/joaompfe/MatlabProjects/Fire/data/results/100';
FILE_TYPE = 'mat'; % mat or h5
IMG_TYPES = ["png"];

method = 'ekf'; % mle, map, kalman, or ekf

N = [3 4 5];
V = 105:5:120;
q = [0.6];

for iq = q
    for n = N
        for v = V
            % Data processing
            dataFile = sprintf("%s/TrajectoryN%dV%d.mat", IN_DATA_DIR, n, abs(v));
            load(dataFile, 'data');

            options.dir = RESULTS_DIR;
            options.ftype = FILE_TYPE;
            options.method = method;
            options.N = n;
            options.V = v;
            options.q = iq;
            options.M = data.Mc;
            result = loadResult(options);

            resultPos = result(:,1:2);

            target = repmat(data.target', data.Mc, 1);
            targetPos = target(:,1:2);

            error = vecnorm(resultPos - targetPos, 2, 2);
            errorCycles = reshape(error, data.movementCycles, data.Mc)';

            % Mean error
%             meanError = sum(errorCycles) ./ data.Mc;
% 
%             figure = plotError(data, method, meanError);
%             meanErrorPlotFile = sprintf("%s/%s/MeanError%s", RESULTS_DIR, method, resultprefix(options));
%             for imgType = IMG_TYPES
%                 saveas(figure, meanErrorPlotFile + "." + imgType, imgType);
%             end

            % RMSE
%             rmse = sqrt(sum(errorCycles.^2) ./ data.Mc)';
% 
%             figure = plotError(data, method, rmse);
%             rmsePlotFile = sprintf("%s/%s/RMSE%s", RESULTS_DIR, method, resultprefix(options));
%             for imgType = IMG_TYPES
%                 saveas(figure, rmsePlotFile + "." + imgType, imgType);
%             end

            % Mean trajectory
            resultX = result(:,1);
            resultY = result(:,2);
            resultX = reshape(resultX, data.movementCycles, data.Mc)';
            resultY = reshape(resultY, data.movementCycles, data.Mc)';
            meanResultX = mean(resultX)';
            meanResultY = mean(resultY)';
            meanResult = [meanResultX, meanResultY];


%             figure = plotTrajectory(data, method, meanResult);
%             trajectoryPlotFile = sprintf("%s/%s/MeanTrajectory%s", RESULTS_DIR, method, resultprefix(options));
%             for imgType = IMG_TYPES
%                 saveas(figure, trajectoryPlotFile + "." + imgType, imgType);
%             end
            
            figure = plotTrajectoryStd(data, method, resultX, resultY);
            trajectoryPlotFile = sprintf("%s/%s/TrajectoryFrequency%s", RESULTS_DIR, method, resultprefix(options));
            for imgType = IMG_TYPES
                saveas(figure, trajectoryPlotFile + "." + imgType, imgType);
            end
        end
    end
end
