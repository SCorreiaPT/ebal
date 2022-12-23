% *************************************************************************
% Criação do posicionamento das ancoras segundo:
%  J.  Ash  and  R.  Moses,  “On  optimal  anchor  node  placement  in  sensor
%  localization by optimization of subspace principal angles,” in Acoustics,
%  Speech and Signal Processing, 2008. ICASSP 2008. IEEE International
%  Conference on, 31 2008-April 4 2008, pp. 2289–2292.
%
% *************************************************************************
function anchors = anchors(n, radius, xc, yc)

i = 0:n-1;
X = (radius * cos(i*2*pi()/n) + xc)';
Y = (radius * sin(i*2*pi()/n) + yc)';
anchors = [X, Y];

end