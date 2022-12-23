%% ************************************************************************
close all
clc
clear

%% ************************************************************************
LINE_WIDTH = 1.2;
DRONE_SIZE = 80;
FONT_SIZE = 12;
N = 6;
dt = 10;

%% ************************************************************************
t = 50:dt:950;
car(:,1) = t;

car(:,2) = 10^-5.*(car(:,1)-520).^3 - (car(:,1)-300)+800;


d{1}.pos(:,1) = t;
d{1}.pos(:,2) = -4e-4 .* t.^2 +0.2 .* t + 900;
d{1}.color = [0.6 0 0.6];
d{1}.dist = vecnorm(d{1}.pos'-car');

d{2}.pos(:,1) = t;
d{2}.pos(:,2) = 9e-4 .* t.^2 -0.7 .* t + 400;
d{2}.color = [0.2 0.9 0.2];
d{2}.dist = vecnorm(d{2}.pos'-car');

d{3}.pos(:,1) = t;
d{3}.pos(:,2) = 7e-4 .* t.^2 - 0.5 .* t + 125; 
d{3}.color = [0.2 0.2 0.9];
d{3}.dist = vecnorm(d{3}.pos'-car');

d{4}.pos(:,1) = t;
d{4}.pos(:,2) = -4e-4 .* t.^2 + 0.65 .* t + 665;
d{4}.color = [0.2 0.6 0.9];
d{4}.dist = vecnorm(d{4}.pos'-car');

d{5}.pos(:,1) = t;
d{5}.pos(:,2) = -15e-4 .* t.^2 +1.* t + 500;
d{5}.color = [0.2 0.6 0.2];
d{5}.dist = vecnorm(d{5}.pos'-car');

d{6}.pos(:,1) = t;
d{6}.pos(:,2) = 9e-4 .* t.^2 -0.7 .* t + 500;
d{6}.color = [0.4 0.4 0.6];

%% ************************************************************************
f1 = figure;
plot(t,d{1}.dist,'Color', d{1}.color,'LineWidth', LINE_WIDTH);
hold on
for i=2:6
    d{i}.dist = vecnorm(d{i}.pos'-car');
    plot(t,d{i}.dist,'Color', d{i}.color,'LineWidth', LINE_WIDTH);
end
legend('d_1','d_2','d_3','d_4','d_5','d_6','Location','southoutside','Orientation','horizontal','AutoUpdate','off');
for i=1:6
    plot(t,ones(1,length(t)).*mean(d{i}.dist),'Color', d{i}.color','LineStyle','--');
    text(t(1),d{i}.dist(1),strcat('d',num2str(i)),'Color', d{i}.color);
    text(t(length(t)),mean(d{i}.dist),strcat('d',num2str(i)),'Color', d{i}.color)
end
grid;
xlim([0 1000]);
ylim([0 1000]);
xlabel('$i^{th}$ sample', 'Interpreter', 'latex');
ylabel('$d$ (m)', 'Interpreter', 'latex');


%% ************************************************************************
fig = figure;
plot(car(:,1), car(:,2), '--or', 'LineWidth', LINE_WIDTH+1,'MarkerIndices',1:5:91);
hold on;
drawArrow(car, 1, 3, [1 0 0]);

%% ************************************************************************
for i = 1:N
    plot(d{i}.pos(:,1), d{i}.pos(:,2), '--', 'Color', d{i}.color, 'LineWidth', LINE_WIDTH);
    drawArrow(d{i}.pos, 1, 7, d{i}.color);
end

grid;
xlim([0 1000]);
ylim([0 1000]);
xlabel('$x$ (m)', 'Interpreter', 'latex');
ylabel('$y$ (m)', 'Interpreter', 'latex');

%% Images ***************************************************************** 
[firefighter, ~, alphachannel] = imread('firefighter.png');
firefighter = image([90 170], [210 130], firefighter, 'AlphaData', alphachannel);

[drone, ~, alphachannel] = imread('drone.png');
dronesPosition = [150 900;  % drone 1
                  500 250;  % drone 2
                  600 80;   % drone 3
                  100 700;  % drone 4
                  100 600;  % drone 5
                  360 350]; % drone 5

%% ************************************************************************
for i = 1:N
    droneimg(i) = image([dronesPosition(i,1) dronesPosition(i,1)+DRONE_SIZE], ... 
                        [dronesPosition(i,2)+DRONE_SIZE dronesPosition(i,2)], ...
                        drone, 'AlphaData', alphachannel);
end
anchorsLegend = "{\boldmath$D$}$_" + compose("%d", 1:N) + "$";
anchorsLegendPos = dronesPosition + [DRONE_SIZE DRONE_SIZE/2];
text(anchorsLegendPos(:,1), anchorsLegendPos(:,2), anchorsLegend, ...
    'Color', [0 0 0], 'Interpreter', 'latex', 'FontSize', FONT_SIZE);

%% ************************************************************************
 [wildfire, ~, alphachannel] = imread('wildfire.png');
 L=150;
 px=290; py=470; image([px px+L], [py+L py], wildfire, 'AlphaData', alphachannel);
 px=400; py=700; image([px px+L], [py+L py], wildfire, 'AlphaData', alphachannel);
 px=640; py=600; image([px px+L], [py+L py], wildfire, 'AlphaData', alphachannel);

  
 %% ***********************************************************************
 save('FireData.mat','d');
 saveas(fig,'scenery.png');
 saveas(f1,'distance-ori.png');

 
 
 
 
 

%% ************************************************************************
function drawArrow(line, first, last, c)
    vec = line(last,:) - line(first,:);
    len = norm(vec);
    uvec = vec / len;
    arrow(1,:) = line(first,:) + [-uvec(2) uvec(1)] * 30;
    arrow(2,:) = arrow(1,:) + vec;
    x = [arrow(1,1) arrow(2,1)] / 1000;
    y = [arrow(1,2) arrow(2,2)] / 1000;
    anArrow = annotation('arrow');
    anArrow.Parent = gca;
    anArrow.Color = c;
    anArrow.Position = [arrow(1,1), arrow(1,2), vec(1), vec(2)];
end