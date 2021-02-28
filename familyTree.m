%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% E150 Genetic Algorithm Evolution Visualizer
% Avery Rock, UC Berkeley Mechanical Engineering, avery_rock@berkeley.edu
% Written for E150, Fall 2019.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function familyTree(Orig, parents, pop)
%%

% Inputs: 
%   Orig -- the indices of a sorted GA generation from before sorting (see sort() documentation), 
%   parents -- the number of parents, required for interpreting source
%   pop --  the number of performers to plot. Use pop >= parents. 

% Returns: 
% no variables, plots a representation of the evolution history to the current figure. 

% The function automatically ignores generations where no rank changes
% occur among the parents OR there are any repeated indices (indicating
% incorrect data). 

% Data visualization: This function can be used to visualize and interpret the performance of
% your GA iteration process. Gray lines represent "survival" with or
% without a rank change. Red lines represent breeding (e.g.,  a new string
% will be connected to its parents with red lines). New random strings have
% no connections. A surviving string will be represented with gray, a new
% string generated randomly will be a blue mark and a new string generated
% by breeding will be red.

% Performance interpretation: If your GA is working correctly, there should
% be lots of turnover (i.e., few generations where nothing happens),
% significant numbers of successful offspring and a moderate number of
% successful random strings. You can also spot stagnation (a parent
% surviving for many generations and continually producing offspring that
% stay in the top ranks). 

%%

Orig2 = Orig(:, 1:pop); % trim source to just relevant entries.
row = 0; changes = []; % initialize variables for determining relevant generations
children = parents; % assume nearest-neighbor with two children
rando = zeros(0, 2); inc = zeros(0, 2); kid = zeros(0, 2); % intialize empty storage arrays
G = size(Orig, 1); % total number of generations.
pts = 25; % number of points to plot in connections
c1 = [.6 .6 .6]; c2 = [1 .6 .6]; % line colors for surviving connections and children
lw = 1.5; % connection line weight
mw = 1.5; % marker line weight

incx = zeros(pts, 2); incy = zeros(pts, 2); % empty arrays for connecting line coordinates.
kidx = zeros(pts, 2); kidy = zeros(pts, 2);

for g = 1:G % for every generation
    if ~isequal(Orig2(g, 1:parents), 1:parents) && length(unique(Orig2(g, :))) == pop % if a change in survivors and valid data
        row = row + 1; % row on which to plot current state - counts relevant generations
        x1 = row - 1; x2 = row; % start and end points of connections
        changes = [changes; g]; % record that a change occured in this generation
        for i = 1:pop
            s = Orig2(g, i); y2 = i;
            if s == i && i <= parents && g > 1 % if the entry is a surviving parent who has not moved
                y1 = i;
                [xx, yy] = mySpline([x1 x2], [y1 y2], pts);
                incx = [incx, xx]; incy = [incy, yy];
                inc = [inc; [x2, y2]];
            elseif  s <= parents && g > 1% if the entry is a surviving parent who has been moved down
                y1 = s;
                [xx, yy] = mySpline([x1 x2], [y1 y2], pts);
                incx = [incx, xx]; incy = [incy, yy];
                inc = [inc; [x2, y2]];
            elseif s <= parents + children && g > 1 % if the entry is a child
                for n = 2:2:children
                    if s <= parents + n
                        y11 = n - 1; y12 = n;
                        [xx1, yy1] = mySpline([x1, x2], [y11, y2], pts);
                        [xx2, yy2] = mySpline([x1, x2], [y12, y2], pts);
                        kidx = [kidx, xx1, xx2]; kidy = [kidy, yy1, yy2];
                        kid = [kid; [x2, y2]];
                        break
                    end
                end
            else % if it's a new random addition.
                rando = [rando; [x2, y2]];
            end
        end
    end
end

p1 = plot(incx, incy, '-', 'Color', c1, 'LineWidth', 1.5); hold on
p2 = plot(kidx, kidy, '-', 'Color', c2, 'LineWidth', 1.5); hold on
p3 = plot(rando(:, 1), rando(:, 2), 's', 'MarkerEdgeColor', [.2 .4 .9], 'MarkerFaceColor', [.6 .6 1], 'MarkerSize', 10, 'LineWidth', mw); hold on % plot random
p4 = plot(inc(:, 1), inc(:, 2), 's', 'MarkerEdgeColor', [.3 .3 .3], 'MarkerFaceColor', [.6 .6 .6], 'MarkerSize', 10, 'LineWidth', mw); hold on % plot survival
p5 = plot(kid(:, 1), kid(:, 2), 's', 'MarkerEdgeColor', [.9 .3 .3], 'MarkerFaceColor', [1 .6 .6], 'MarkerSize', 10, 'LineWidth', mw); % plot children
h = [p3, p4, p5];
legend(h, "Random", "Incumbent", "Child")

xlabels = {};
for i = 1:numel(changes)
    xlabels{i} = num2str(changes(i));
end

ylabels = {};
for j = 1:pop
    ylabels{j} = num2str(j);
end

title("Family Tree");
set(gca, 'xtick', [1:row]); set(gca,'ytick', [1:pop]);
set(gca,'xticklabel', xlabels); set(gca,'yticklabel', ylabels);
xlabel("generation"); ylabel("Rank");
axis([0 row + 1 0 pop + 1]); view([90, 90])
end

function [xx, yy] = mySpline(x, y, pts)
% produces clamped splines between two points 

% Inputs: 
%   x -- 2-value vector containing the x coordinates of the end points
%   y -- 2-value vector containing the y coordinates of the end points
%   pts -- the number of total points to plot (ends plus intermediates)

% Returns: 
%    xx -- array of x coordinates to plot
%    yy -- array of y coordinates to plot

cs = spline(x, [0 y 0]);
xx = linspace(x(1), x(2), pts)';
yy = ppval(cs,xx);
end