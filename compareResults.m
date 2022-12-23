addpath('plot');
addpath('utils');


IN_DATA_DIR='/home/joaompfe/MatlabProjects/Fire/data/datasets/100';
RESULTS_DIR='/home/joaompfe/MatlabProjects/Fire/data/results/100';
FILE_TYPE = 'mat'; % mat or h5
IMG_TYPES = ["png"];

methods = ["mle", "ekf"];

N = [3 4 5];
V = 105:5:120;
q = [0.6];


errorResume = nan(length(N) * length(V), length(methods));

for iq = q
    for n = N
        for v = V
            dataFile = sprintf("%s/TrajectoryN%dV%d.mat", IN_DATA_DIR, n, abs(v));
            load(dataFile, 'data');
            
            m = length(methods);
            cycles = data.movementCycles;
            meanError = cell(2, m);
            rmse = cell(2, m);
            meanTrajectory = cell(2, m);
            resultX = cell(m, 1);
            resultY = cell(m, 1);
            
            for m = 1:length(methods)
                method = methods(m);
                meanError{1,m} = method;
                rmse{1,m} = method;
                meanTrajectory{1,m} = method;

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
                meanError{2,m} = sum(errorCycles) ./ data.Mc;
                errorResume((find(N==n)-1)*length(V)+find(V==v),m) = mean(meanError{2,m});

                % RMSE
                rmse{2,m} = sqrt(sum(errorCycles.^2) ./ data.Mc)';

                % Mean trajectory
                x = result(:,1);
                y = result(:,2);
                x = reshape(x, data.movementCycles, data.Mc)';
                y = reshape(y, data.movementCycles, data.Mc)';
                resultX{m} = x;
                resultY{m} = y;
                meanX = mean(x)';
                meanY = mean(y)';
                meanTrajectory{2,m} = [meanX, meanY];
            end
            
%             figure = plotError(data, meanError{:});
%             meanErrorPlotFile = sprintf("%s/MeanErrorComparison%s", RESULTS_DIR, resultprefix(options));
%             for imgType = IMG_TYPES
%                 extType = imgType;
%                 if strcmp(imgType, 'epsc')
%                     extType = 'eps';
%                 end
%                 saveas(figure, meanErrorPlotFile + "." + extType, imgType);
%             end
            
%             figure = plotError(data, rmse{:});
%             rmsePlotFile = sprintf("%s/RMSEComparison%s", RESULTS_DIR, resultprefix(options));
%             for imgType = IMG_TYPES
%                 extType = imgType;
%                 if strcmp(imgType, 'epsc')
%                     extType = 'eps';
%                 end
%                 saveas(figure, rmsePlotFile + "." + extType, imgType);
%             end
            
%             figure = plotTrajectory(data, meanTrajectory{:});
%             trajectoryPlotFile = sprintf("%s/MeanTrajectoryComparison%s", RESULTS_DIR, resultprefix(options));
%             for imgType = IMG_TYPES
%                 extType = imgType;
%                 if strcmp(imgType, 'epsc')
%                     extType = 'eps';
%                 end
%                 saveas(figure, trajectoryPlotFile + "." + extType, imgType);
%             end
            
            figure = plotTrajectoryStd(data, methods, resultX, resultY);
            trajectoryPlotFile = sprintf("%s/MeanTrajectoryComparison%s", RESULTS_DIR, resultprefix(options));
            for imgType = IMG_TYPES
                extType = imgType;
                if strcmp(imgType, 'epsc')
                    extType = 'eps';
                end
                saveas(figure, trajectoryPlotFile + "." + extType, imgType);
            end
            
        end
    end
end

writematrix(errorResume, [RESULTS_DIR '/mean-error-resume.csv']);

