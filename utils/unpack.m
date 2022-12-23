function unpack(arg)
%UNPACK Unpacks fields within $arg$ to the caller workspace.
%   It is usefll to unpack variables from function arguments.

fn = fieldnames(arg);
    
    for i = 1:numel(fn)
        var = string(fn(i));
        val = arg.(var);
        assignin('caller', var, val);
    end
    
end

