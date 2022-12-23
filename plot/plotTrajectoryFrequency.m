function f = plotTrajectoryFrequency(data, method, resultX, resultY)


FONT_SIZE = 12;
LINE_WIDTH = 1;

target = data.target;
anchors = data.sensors;

f = figure;
for i = 1:length(resultX)
    plot(resultX(i,:), resultY(i,:), 'Color', [1 0 0 0.01]);
    hold on;
end
  
h(1) = plot(target(1,:), target(2,:), '-r'); % just for legend
hold on
h(2) = plot(target(1,:), target(2,:), '--k');
hold on
xlim([0 1000]);
ylim([0 1000]);
legend('Discretized Trajetory','Location','southeast')
grid


markers = ["o", "d", "s"];
% h = nan(length(methods), 1); % Plots
% for i = 1:length(methods)
%     methods{i} = upper(methods{i});
%     trajectory = trajectories{i};
%     h(i) = plot(trajectory(:,1), trajectory(:,2), '-', ... 'Marker', markers(i), ...
%         'Color', colors(i,:), 'LineWidth', LINE_WIDTH);
% end

legend(flip(h), [{'{\boldmath$x$}$_t$'}, {upper(method)}], 'Interpreter', 'latex', 'FontSize', FONT_SIZE);

ylabel('$y$ (m)', 'Interpreter', 'latex', 'FontSize', FONT_SIZE);
xlabel('$x$ (m)', 'Interpreter', 'latex', 'FontSize', FONT_SIZE);

end
  