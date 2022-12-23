function target = squaredTrajectory(speed)

leftBottom = [10, 15];
rightBottom = [40, 15];
rightTop = [40, 35];
leftTop = [10, 35];

if mod(20, speed) ~= 0 || mod(30, speed) ~= 0
    error('invalid speed')
end


nsteps = (rightBottom(1) - leftBottom(1)) / speed + 1;
target = [leftBottom(1):speed:rightBottom(1); zeros(1, nsteps) + leftBottom(2)]';

nsteps = (rightTop(2) - rightBottom(2)) / speed;
target = [target; [zeros(1, nsteps) + target(end,1); rightBottom(2)+speed:speed:rightTop(2)]'];

nsteps = - (leftTop(1) - rightTop(1)) / speed;
target = [target; [rightTop(1)-speed:-speed:leftTop(1); zeros(1, nsteps) + target(end, 2)]'];

nsteps = - (leftBottom(2) - rightTop(2)) / speed;
target = [target; [zeros(1, nsteps) + target(end,1); rightTop(2)-speed:-speed:leftBottom(2)]'];

target = target(1:end-1, :)';

end

