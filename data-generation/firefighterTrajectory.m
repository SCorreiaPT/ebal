function target = firefighterTrajectory(speed)

dt=1;
t = 50:dt:950;
car(:,1) = t;

car(:,2) = 10^-5.*(car(:,1)-520).^3 - (car(:,1)-300)+800;

target = car';

end

