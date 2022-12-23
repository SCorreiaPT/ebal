function f = plotTrajectoryStd(data, methods, resultX, resultY)


FONT_SIZE = 12;
LINE_WIDTH = 1;

target = data.target;
drones = data.sensors;

for m = 1:length(methods)
    meanX(m,:) = mean(resultX{m});
    meanY(m,:) = mean(resultY{m});
    stdX(m,:) = std(resultX{m});
    stdY(m,:) = std(resultY{m});
end

colors = ["b" "g"];

f = figure;

% band
ellipses(length(methods), data.movementCycles) = polyshape(); % preallocation
for m = 1:length(methods)
    for i = 1:data.movementCycles
        ellipses(m,i) = plotEllipses([meanX(m,i) meanY(m,i)], [stdX(m,i) stdY(m,i)], [0.7 0.7 1]);
    end
    band(m) = fastUnion(ellipses(m,:));

    plot(band(m), 'FaceColor', colors(m), 'LineStyle', 'none');
    hold on;
end

% drones
for i = 1:data.N
    h(2) = plot(drones{i}(:,1), drones{i}(:,2), '-.', 'Color', [0.5 0.5 0.5], 'LineWidth', LINE_WIDTH);
    hold on;
end

% mean trajectory
for m = 1:length(methods)
    h(m+2) = plot(meanX(m,:), meanY(m,:), colors(m), 'LineWidth', LINE_WIDTH);
    hold on;
end
% true trajectory
h(1) = plot(target(1,:), target(2,:), '--k', 'LineWidth', LINE_WIDTH);
hold on
xlim([0 1000]);
ylim([0 1000]);
legend('Discretized Trajetory','Location','southeast')
grid

legend(h, [{'{\boldmath$x$}$_t$'}, {'{\boldmath$D$}$_i$'}, upper(methods(:)')], 'Interpreter', 'latex', 'FontSize', FONT_SIZE);

ylabel('$y$ (m)', 'Interpreter', 'latex', 'FontSize', FONT_SIZE);
xlabel('$x$ (m)', 'Interpreter', 'latex', 'FontSize', FONT_SIZE);

end

function h = plotEllipses(cnt, rads, color)

llc = cnt - rads;
wh = 2*rads; 
% Draw rectangle 
% h = rectangle('Position', [llc(:).',wh(:).'], 'Curvature', [1,1], 'EdgeColor', color, 'FaceColor', color); 

t = -pi:0.02:pi;
x = cnt(1) + rads(1)*cos(t);
y = cnt(2) + rads(2)*sin(t);
shape = polyshape(x, y);
h = shape;

end

function u = fastUnion(bands)

l = length(bands);
if l == 1
    u = bands;
elseif l == 2
    u = union(bands);
else
    firstHalf = bands(1:fix(l/2));
    secondHalf = bands(fix(l/2)+1:end);
    u = union(fastUnion(firstHalf), fastUnion(secondHalf));
end

end