function P=RandCircle(x1,y1,rc)
%the function, must be on a folder in matlab path
a=2*pi*rand;
r=sqrt(rand);
x=(rc*r)*cos(a)+x1;
y=(rc*r)*sin(a)+y1;

P(1)=x;
P(2)=y;
end