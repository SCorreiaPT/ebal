function f = plotTrajectory(data, methods, trajectories)

arguments
    data
end
arguments (Repeating)
    methods string
    trajectories (:,2) double
end

FONT_SIZE = 12;
LINE_WIDTH = 1;

target = data.target;
anchors = data.sensors;

f = figure;
plot(target(1,:), target(2,:), '-k');
hold on
xlim([0 1000]);
ylim([0 1000]);
legend('Discretized Trajetory','Location','southeast')
grid

   
% Sensors/Anchors Placement
% N = length(anchors);
% anchorsCenter = sum(anchors, 1) ./ N;
% anchorsRadius = vecnorm(anchors(1,:) - anchorsCenter);
%   
% anchorsColor = [0.3 0.3 0.3];
% h = plot(anchors(:,1), anchors(:,2), 'sg', 'MarkerEdgeColor', anchorsColor, ...
%     'MarkerFaceColor', anchorsColor, 'MarkerSize', 10);
% h.Annotation.LegendInformation.IconDisplayStyle = 'off';
% c = circle(anchorsCenter(1), anchorsCenter(2), anchorsRadius);
% h = plot(c(1,:), c(2,:), '--', 'Color', [0.3 0.3 0.3]);
% h.Annotation.LegendInformation.IconDisplayStyle = 'off';


% anchorsLegendPos = anchors + 2.5 .* (anchorsCenter - anchors) ./ anchorsRadius - [1 0];
% anchorsLegend = "{\boldmath$s$}$_" + compose("%d", 1:N) + "$";
% text(anchorsLegendPos(:,1), anchorsLegendPos(:,2), anchorsLegend, 'Color', [0 0 0], 'Interpreter', 'latex', 'FontSize', FONT_SIZE);
      


colors = hsv(length(methods));
% markers = ['o','+','*','.','x','s','d','^','v','>','<','p','h'];
markers = ["o", "d", "s"];
h = nan(length(methods), 1); % Plots
for i = 1:length(methods)
    methods{i} = upper(methods{i});
    trajectory = trajectories{i};
    h(i) = plot(trajectory(:,1), trajectory(:,2), '-', ... 'Marker', markers(i), ...
        'Color', colors(i,:), 'LineWidth', LINE_WIDTH);
end

legend([{'{\boldmath$x$}$_t$'}, ...
    methods(:)'], 'Interpreter', 'latex', 'FontSize', FONT_SIZE);

ylabel('$y$ (m)', 'Interpreter', 'latex', 'FontSize', FONT_SIZE);
xlabel('$x$ (m)', 'Interpreter', 'latex', 'FontSize', FONT_SIZE);

end
  