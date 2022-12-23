function target = customTrajectory(speed)

S = transitionm(2);
x0 = 15;
y0 = 5;

target = [x0; y0; 0; 0];     % Initial target state

% Rectilinear Trajectory
for nn = 1 : 1 : 19
   target(3:4,end) = [speed; 0];
   target = [target, S * target(:,nn)]; 
end

% Curvy Smooth Trajectory
for mm = pi/2 : -pi/20 : -pi/2
    target = [target, [35; 0; 0; 0] -  [-10*cos(mm); 20*sin(mm)-25; 0; 0]];
end

% Steady Horizontal
for nn = 41 : 1 : 45
    target(3:4,end) = [-speed; 0];
    target = [target, S * target(:,nn)];
end

% Diagonal 1
for nn = 46 : 1 : 55
    target(3:4,end) = [-speed; -speed];
    target = [target, S * target(:,nn)];
end

% Diagonal 2
for nn = 56 : 1 : 65
    target(3:4,end) = [-speed; speed];
    target = [target, S * target(:,nn)];
end

% Diagonal 3
for nn = 66 : 1 : 70
    target(3:4,end) = [-speed; -speed];
    target = [target, S * target(:,nn)];
end

% Steady Vertical
for nn = 71 : 1 : 75
    target(3:4,end) = [0; -speed];
    target = [target, S * target(:,nn)];
end

% Diagonal 4
for nn = 76 : 1 : 85
    target(3:4,end) = [speed; -speed];
    target = [target, S * target(:,nn)];
end

% Diagonal 5
for nn = 86 : 1 : 95
    target(3:4,end) = [-speed; -speed];
    target = [target, S * target(:,nn)];
end

% Steady Vertical
for nn = 96 : 1 : 99
    target(3:4,end) = [0; -speed];
    target = [target, S * target(:,nn)];
end