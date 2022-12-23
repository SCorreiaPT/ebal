function saveResult(results, options)
%SAVERESULT Saves the result in the file system.
%   Detailed explanation goes here

dir = sprintf("%s/%s", options.dir, options.method);
if ~exist(dir, 'dir')
   mkdir(dir); 
end

if strcmp(options.method, 'mle')
    resultsFile = sprintf("%s/TrajectoryResultsN%dV%dM%d.mat", ...
        dir, options.N, abs(options.V), options.M);
else
    resultsFile = sprintf("%s/TrajectoryResultsN%dV%dq%.6fM%d.mat", ...
        dir, options.N, abs(options.V), options.q, options.M);
end

save(resultsFile, 'results'); 

end

