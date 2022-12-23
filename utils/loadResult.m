function result = loadResult(options)

dir = sprintf("%s/%s", options.dir, options.method);

if strcmp(options.method, 'mle')
    filepath = sprintf("%s/TrajectoryResultsN%dV%dM%d.%s", dir, options.N, ...
        abs(options.V), options.M, options.ftype);
    if ~exist(filepath, 'file')
        filepath = sprintf("%s/TrajectoryResultsN%dV%d.%s", dir, options.N, ...
        abs(options.V), options.ftype);
    end
else
    filepath = sprintf("%s/TrajectoryResultsN%dV%dq%.6fM%d.%s", dir, ...
        options.N, abs(options.V), options.q, options.M, options.ftype);
    if ~exist(filepath, 'file')
       filepath = sprintf("%s/TrajectoryResultsN%dV%dq%.6f.%s", dir, ...
        options.N, abs(options.V), options.q, options.ftype); 
    end
end

parts = split(filepath, '.');
fileType = parts(end);

if strcmp(fileType, 'h5')
    result = h5read(filepath, '/result')';
end
if strcmp(fileType, 'mat')
    load(filepath, 'results');
    result = results;
end
end