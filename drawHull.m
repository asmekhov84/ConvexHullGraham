function h = drawHull(h, points, hull, inner, undefined, varargin)
    delete(h(ishandle(h)));
    line_style = ':';
    animate = false;
    if ~isempty(varargin)
        line_style = varargin{1};
    end
    if length(varargin) > 1
        animate = varargin{2};
    end
    sound_track = {};
    if animate
        sound_track = varargin{3};
        hull_init_id = 1;
        inner_init_id = 1;
        undefined_init_id = 1;
    else
        hull_init_id = length(hull);
        inner_init_id = length(inner);
        undefined_init_id = length(undefined);
    end
    delay = 0.2;
    h_hull = [];
    for i = hull_init_id : length(hull)
        delete(h_hull(ishandle(h_hull)));
        ids = hull(1 : i);
        x = points(ids, 1);
        y = points(ids, 2);
        h1 = plot(x, y, 'lineStyle', line_style, 'lineWidth', 1.5, 'color', 'w',...
            'marker', 'o', 'markerSize', 20, 'markerEdgeColor', 'w', 'markerFaceColor', 'g');
        h2 = text(x - 0.007, y - 0.002, num2str(ids), 'color', 'k', 'fontSize', 12);
        h_hull = [h1; h2];
        if animate
            sound(sound_track{1}, sound_track{2});
            pause(delay);
        end
    end
    h_inner = [];
    for i = inner_init_id : length(inner)
        delete(h_inner(ishandle(h_inner)));
        ids = inner(1 : i);
        x = points(ids, 1);
        y = points(ids, 2);
        h1 = scatter(x, y, 400, 'markerEdgeColor', 'w', 'markerFaceColor', 'r',...
            'lineWidth', 1.5);
        h2 = text(x - 0.007, y - 0.002, num2str(ids), 'color', 'k', 'fontSize', 12);
        h_inner = [h1; h2];
        if animate
            sound(sound_track{1}, sound_track{2});
            pause(delay);
        end
    end
    h_undefined = [];
    for i = undefined_init_id : length(undefined)
        delete(h_undefined(ishandle(h_undefined)));
        ids = undefined(1 : i);
        x = points(ids, 1);
        y = points(ids, 2);
        h1 = scatter(x, y, 400, 'markerEdgeColor', 'w', 'markerFaceColor', 'k',...
            'lineWidth', 1.5);
        h2 = text(x - 0.007, y - 0.002, num2str(ids), 'color', 'w', 'fontSize', 12);
        h_undefined = [h1; h2];
        if animate
            sound(sound_track{1}, sound_track{2});
            pause(delay);
        end
    end
    h = [h_hull; h_inner; h_undefined];
end