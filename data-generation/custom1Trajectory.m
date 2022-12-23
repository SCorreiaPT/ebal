function target = custom1Trajectory(speed)

exmod = false;
if ~exist('speed', 'var')
   exmod = true;
   speed = 1;
end

valid = mod(20, speed) == 0;
valid = valid && mod(15, speed) == 0;
valid = valid && mod(30, speed) == 0;
if ~valid
   error('invalid speed'); 
end

% Rectilinear foward
x = 10:speed:30-speed;
y = 10 * ones(1, 20);
target = [x; y];

% Curve
r = 10;
i = -pi/2 : pi/(30/speed) : pi/2;
x = r * cos(i) + 30;
y = r * sin(i) + 20;
target = [target [x; y]];

% Rectilinear back
x = 30-speed:-speed:10;
y = 30 * ones(1, 20);
target = [target [x; y]];

% Sharp inward
x = 10+speed/1.5:speed/1.5:20;
y = 30-speed/1.5:-speed/1.5:20;
target = [target [x; y]];

% Sharp out
x = 20-speed/1.5:-speed/1.5:10+speed/1.5;
y = 20-speed/1.5:-speed/1.5:10+speed/1.5;
target = [target [x; y]];

% Translation up
target(2,:) = target(2,:) + 5;

% Rotation 45
target = target - 25;
angle = -pi / 4;
matrix = [cos(angle) -sin(angle); sin(angle) cos(angle)];
target = matrix * target;
target = target + 25;


if exmod
   plot(target(1,:), target(2,:)); 
end

end

