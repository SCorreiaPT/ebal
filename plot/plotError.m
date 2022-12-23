function f = plotError(data, methods, errors)

arguments
    data
end
arguments (Repeating)
    methods string
    errors (:,1) double
end

FONT_SIZE = 12;
LINE_WIDTH = 1;

cycles = data.movementCycles;

f = figure;
colors = ["b" "g"];
h = nan(length(methods), 1); % Plots

for i = 1:length(methods)
    error = errors{i};
    methods{i} = upper(methods{i});
    

    h(i) = plot(1:cycles, error, '-', 'Color', colors(i), 'LineWidth', LINE_WIDTH);
    hold on;
    plot(1:cycles, ones(cycles) .* mean(error), '--', 'Color', colors(i), 'LineWidth', LINE_WIDTH);
    text(1, mean(error) + 0.02 * diff(ylim), num2str(mean(error)), 'Color', 'black');
end
%set(gca, 'YScale', 'log');

grid minor;

% xline(31,'--b');
% xline(51,'--b');
% xline(56,'--b');
% xline(66,'--b');
% xline(76,'--b');
% xline(81,'--b');
% xline(86,'--b');
% xline(96,'--b');

xlim([0 cycles]);

% dim2 = [0.13 0.11 .775 .815]; %All area
% 
% % ZONE 1
% dim2 = [0.13 0.11 .22 .815];
% annotation(f,'rectangle',dim2,'FaceColor','blue','FaceAlpha',.1,'LineStyle','none');
% text(.01,.95,'Zone 1','Color','b','Units','normalized');
% 
% % ZONE 2
% dim2 = [0.35 0.11 .143 .815];
% annotation(f,'rectangle',dim2,'FaceColor','green','FaceAlpha',.1,'LineStyle','none');
% text(.3,.95,'Zone 2','Color','g','Units','normalized');
% 
% % ZONE 3
% dim2 = [0.49 0.11 .415 .815];
% annotation(f,'rectangle',dim2,'FaceColor','red','FaceAlpha',.1,'LineStyle','none');
% text(.48,.95,'Zone 3','Color','r','Units','normalized');


% Anchors annotation
anchors = data.sensors;
target = data.target;
% for iAnchors = 1:length(anchors)
%     anchor = anchors(iAnchors, :);
%     distance = vecnorm(target(1:2,:) - anchor');
%     [~, i] = min(distance);
%     anno = annotation('textarrow','String', " S" + iAnchors);
%     anno.Parent = gca;
%     x = i; % TODO se o x proximo de 0 meter a reta obliqua para o texto entrar no plot
%     yd = 0.1 * diff(ylim);
%     y = error(i) + 1.5 * yd;
%     anno.Position = [x y 0 -yd];
% end

% yyaxis right;
% distance = ones(1, cycles) .* inf;
% for iAnchors = 1:length(anchors)
%     anchor = anchors(iAnchors, :);
%     distance = min(vecnorm(target(1:2,:) - anchor'), distance);
%     %[~, i] = min(distance);
%     %xline(i, 'd--');
%     
% end
% plot(1:cycles, distance, '--', 'Color', [0 0 0]);
legend(h, methods{:}, 'Interpreter', 'latex', 'FontSize', FONT_SIZE,...
    'Orientation', 'horizontal');

ylabel('ME (m)', 'Interpreter', 'latex', 'FontSize', FONT_SIZE);
xlabel('$t$ (s)', 'Interpreter', 'latex', 'FontSize', FONT_SIZE);

end