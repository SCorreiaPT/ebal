function prefix = resultprefix(options)

if strcmp(options.method, 'mle')
    prefix = sprintf("N%dV%d", options.N, abs(options.V));
else
    prefix = sprintf("N%dV%dq%.6f", options.N, abs(options.V), options.q);
end

% if isfield(options, 'ftype')
%    prefix = sprintf("%s.%s", prefix, options.ftype); 
% end

end

