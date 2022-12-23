LINE_WIDTH = 1.2;
DRONE_SIZE = 80;
FONT_SIZE = 12;
N = 6;

car(:,1) = 50:950;
car(:,2) = 10^-5.*(car(:,1)-520).^3 - (car(:,1)-300)+800;

d{1}.pos(:,1) = 50:950;
d{1}.pos(:,2) = -4e-4 .* d3(:,1).^2 +0.2 .* d3(:,1) + 900;
d{1}.color = [0.6 0 0.6];

d{2}.pos(:,1) = 50:950;
d{2}.pos(:,2) = 9e-4 .* d3(:,1).^2 -0.7 .* d3(:,1) + 400;
d{2}.color = [0.2 0.9 0.2];

d{3}.pos(:,1) = 50:950;
d{3}.pos(:,2) = 7e-4 .* d2(:,1).^2 - 0.5 .* d2(:,1) + 125; 
d{3}.color = [0.2 0.2 0.9];

d{4}.pos(:,1) = 50:950;
d{4}.pos(:,2) = -4e-4 .* d1(:,1).^2 + 0.65 .* d1(:,1) + 665;
d{4}.color = [0.2 0.6 0.9];

d{5}.pos(:,1) = 50:950;
d{5}.pos(:,2) = -15e-4 .* d3(:,1).^2 +1.* d3(:,1) + 500;
d{5}.color = [0.2 0.6 0.2];

d{6}.pos(:,1) = 50:950;
d{6}.pos(:,2) = 9e-4 .* d6(:,1).^2 -0.7 .* d6(:,1) + 500;
d{6}.color = [0.4 0.4 0.6];

plot(car(:,1), car(:,2), 'Color', [1 0 0], 'LineWidth', LINE_WIDTH);
hold on;
drawArrow(car, 10, 30);
for i = 1:N
    plot(d{i}.pos(:,1), d{i}.pos(:,2), '--', 'Color', d{i}.color, 'LineWidth', LINE_WIDTH);
    drawArrow(d{i}.pos, 1, 70);
end
% X = [0.5 0.5];
% Y = [0   0.5];
% annotation('arrow',X,Y);

grid;
xlim([0 1000]);
ylim([0 1000]);
xlabel('$x$ (m)', 'Interpreter', 'latex');
ylabel('$y$ (m)', 'Interpreter', 'latex');


%% Images
[firefighter, ~, alphachannel] = imread('firefighter.png');
firefighter = image([100 240], [240 100], firefighter, 'AlphaData', alphachannel);

[drone, ~, alphachannel] = imread('drone.png');
dronesPosition = [150 900;  % drone 1
                  500 250;  % drone 2
                  600 80;   % drone 3
                  100 700;  % drone 4
                  100 600;   % drone 5
                  360 350];

for i = 1:N
    droneimg(i) = image([dronesPosition(i,1) dronesPosition(i,1)+DRONE_SIZE], ... 
                        [dronesPosition(i,2)+DRONE_SIZE dronesPosition(i,2)], ...
                        drone, 'AlphaData', alphachannel);
end
anchorsLegend = "{\boldmath$D$}$_" + compose("%d", 1:N) + "$";
anchorsLegendPos = dronesPosition + [DRONE_SIZE DRONE_SIZE/2];
text(anchorsLegendPos(:,1), anchorsLegendPos(:,2), anchorsLegend, ...
    'Color', [0 0 0], 'Interpreter', 'latex', 'FontSize', FONT_SIZE);

% [wildfire, ~, alphachannel] = imread('wildfire.png');
% image([3 240], [240 100], wildfire, 'AlphaData', alphachannel);
% image([100 240], [240 100], wildfire, 'AlphaData', alphachannel);
% image([100 240], [240 100], wildfire, 'AlphaData', alphachannel);

function drawArrow(line, first, last)
    vec = line(last,:) - line(first,:);
    len = norm(vec);
    uvec = vec / len;
    arrow(1,:) = line(first,:) + [-uvec(2) uvec(1)] * 30;
    arrow(2,:) = arrow(1,:) + vec;
    x = [arrow(1,1) arrow(2,1)] / 1000;
    y = [arrow(1,2) arrow(2,2)] / 1000;
    anArrow = annotation('arrow');
    anArrow.Parent = gca;
    anArrow.Position = [arrow(1,1), arrow(1,2), vec(1), vec(2)];
end