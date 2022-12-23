function S = transitionm(dim)
%TRANSICTIONM Creates a transition matrix. 
%   Creates a transition matrix for the $dim$ dimensional space. If no
%   argument if passed, it is assumed a 2D space.

if ~exist('dim', 'var')
    dim = 2;
end

S = eye(dim * 2);

for i = 1:dim
    S(i,i+dim) = 1;
end

end

