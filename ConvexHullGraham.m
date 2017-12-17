close('all');

% Read sounds from disk.
[select_y, select_fs] = audioread('sounds/select.wav');
[test_y, test_fs] = audioread('sounds/test.wav');
[accept_y, accept_fs] = audioread('sounds/accept.wav');
[reject_y, reject_fs] = audioread('sounds/reject.wav');
[success_y, success_fs] = audioread('sounds/success.wav');

% Create an UI.
h_fig_main = figure('units', 'norm', 'outerPosition', [0, 0, 1, 1],...
    'color', 'w', 'toolBar', 'none', 'menuBar', 'none');
h_pnl_plot = uipanel(h_fig_main, 'position', [0, 0, 0.789, 0.9],...
    'backgroundColor', 'k', 'borderType', 'none');
h_pnl_table = uipanel(h_fig_main, 'position', [0.79, 0, 0.21, 0.9],...
    'backgroundColor', 'k', 'borderType', 'none');
h_pnl_info = uipanel(h_fig_main, 'position', [0, 0.901, 1, 0.1],...
    'backgroundColor', 'k', 'borderType', 'none');
axes('parent', h_pnl_plot, 'position', [0.05, 0.05, 0.9, 0.9]);
axis('off');
xlim([0, 1]);
ylim([-0.05, 1.05]);
hold('on');
h_lbl_table = uicontrol('parent', h_pnl_table, 'style', 'text',...
    'Units', 'norm', 'position', [0, 0, 1, 1], 'fontName', 'monospaced',...
    'fontSize', 12, 'backgroundColor', 'k', 'foregroundColor', 'w',...
    'horizontalAlignment', 'left');
h_lbl_info = uicontrol('parent', h_pnl_info, 'style', 'text', 'Units', 'norm',...
    'position', [0.01, 0.05, 0.98, 0.7], 'fontName', 'arial', 'fontSize', 14,...
    'backgroundColor', 'k', 'foregroundColor', 'w', 'horizontalAlignment', 'left');

long_delay = 4;
mid_delay = 0.7;
short_delay = 0.4;

pause();

% Create an array of randomly distributed 2D points.
set(h_lbl_info, 'string', ['Let''s consider an array of random points in the plane'...
    ' and three ordered sets named "hull", "inner" and "undefined".'...
    ' Initially all points are in the "undefined" set.']);
n_points = 25; % total number of points
points_source = generateRandomPoints(n_points, 500, 0.12);
points = points_source;
hull = [];
inner = [];
undefined = (1 : n_points)';
h_hull = [];
h_hull = drawHull(h_hull, points, hull, inner, undefined, '-', true, {select_y, select_fs});
showTable(h_lbl_table, hull, inner, undefined);
pause(long_delay);

% As the origin point of the convex hull we take point with the lowest Y value.
% Origin point is a priori lies on the border of the convex hull.
set(h_lbl_info, 'string', ['The first step is to find the point with the lowest Y coordinate.'...
    ' This point a priori belongs to the convex hull.']);
[~, lowest_point_id] = min(points(:, 2));
h_lowest_point = plot(points(lowest_point_id, 1), points(lowest_point_id, 2),...
    'marker', 'o', 'markerSize', 25, 'markerEdgeColor', 'y', 'lineWidth', 2);
sound(select_y, select_fs);
pause(long_delay);

% Calculate angles between X axis and each segment, connecting the origin
% with all of the points.
set(h_lbl_info, 'string', ['Now the points must be sorted in increasing order of'...
    ' the angle they and the lowest point make with the X axis.']);
u = points(lowest_point_id, 1 : 2);
angles = zeros(n_points, 1);
h_txt_angles = zeros(n_points, 1);
h_x_axis = quiver(u(1), u(2), max(points(:, 1)) - u(1), 0, 'color', 'w', 'lineWidth', 1.5);
for i = 1 : n_points
    v = points(i, 1 : 2);
    h_line = line([u(1), v(1)], [u(2), v(2)], 'lineStyle', ':', 'color', 'w');
    w = v - u;
    angles(i) = atan2d(w(2), w(1));
    h_txt_angles(i) = text(points(i, 1) + 0.01, points(i, 2) + 0.03,...
        [num2str(round(angles(i))), '°'], 'color', 'y', 'fontSize', 12);
    sound(select_y, select_fs);
    pause(short_delay);
    delete(h_line);
end
pause(mid_delay);

% Sort points in according to it's angles with the X axis.
undefined = [undefined, angles];
undefined = sortrows(undefined, 2);
undefined = undefined(:, 1);
delete(h_txt_angles);
delete(h_x_axis);
delete(h_lowest_point);
showTable(h_lbl_table, hull, inner, undefined);
pause(long_delay);

% First point will be on the convex hull.
hull = undefined(1);
undefined = [undefined; undefined(1)];
undefined(1) = [];
h_hull = drawHull(h_hull, points, hull, inner, undefined(1 : end - 1));
showTable(h_lbl_table, hull, inner, undefined(1 : end - 1));
set(h_lbl_info, 'string', 'Move the first point to the "hull".');
sound(accept_y, accept_fs);
pause(long_delay);

% Loop through all points and remove those of them which are not on the border
% of the convex hull.
set(h_lbl_info, 'string', ['Until the "undefined" set is not empty take the first'...
    ' point and check whether it is on the right or on the left side of a segment,'...
    ' which connects the next point with the last point from the "hull".'...
    ' If it on the left side (and three consecutive points make the right turn)'...
    ' than this point is not part of the convex hull and lies inside it.']);
h_ch = [];
h_desc = text(0.45, 1, '', 'color', 'y', 'fontSize', 18, 'units', 'norm');
while length(undefined) >= 2
    while true
        test_ids = [hull(end); undefined(1 : 2)];
        test_points = points(test_ids, :);

        h_test_lines = line(test_points(:, 1), test_points(:, 2), 'color', 'y');
        h_hull = drawHull(h_hull, points, hull, inner, undefined(1 : end - 1));
        set(h_desc, 'string', ['   Test point ', num2str(test_ids(2)), '   '], 'color', 'y');
        sound(test_y, test_fs);
        pause(mid_delay);

        if isLeftTurn(test_points(1, :), test_points(2, :), test_points(3, :))
            break;
        end

        inner = cat(1, inner, undefined(1));
        undefined(1) = [];
        undefined = cat(1, hull(end), undefined);
        hull(end, :) = [];
        h_hull = drawHull(h_hull, points, hull, inner, undefined(1 : end - 1));
        showTable(h_lbl_table, hull, inner, undefined(1 : end - 1));

        set(h_desc, 'string', 'Right turn - reject', 'color', 'r');
        set(h_test_lines, 'color', 'r');
        sound(reject_y, reject_fs);
        pause(mid_delay);
        delete(h_test_lines);
    end
    hull = cat(1, hull, undefined(1));
    undefined(1) = [];
    h_hull = drawHull(h_hull, points, hull, inner, undefined(1 : end - 1));
    showTable(h_lbl_table, hull, inner, undefined(1 : end - 1));

    set(h_desc, 'string', '     Left turn     ', 'color', 'g');
    set(h_test_lines, 'color', 'g');
    sound(accept_y, accept_fs);
    pause(mid_delay);
    delete(h_test_lines);
end

% Draw the completed convex hull.
delete(h_desc);
hull = [hull; hull(1)];
drawHull(h_hull, points, hull, inner, undefined(1 : end - 1), '-');
sound(success_y, success_fs);
set(h_lbl_info, 'string', 'Convex hull is complete!');