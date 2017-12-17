function points = generateRandomPoints(n_points, attempts_limit, dist_threshold)
    points = zeros(n_points, 2);
    points(1, :) = rand(1, 2);
    for i = 2 : n_points
        attempt_number = 0;
        best_dist = 0;
        best_point = [];
        while (best_dist < dist_threshold) && (attempt_number < attempts_limit)
            attempt_number = attempt_number + 1;
            point = rand(1, 2);
            min_dist = min(sqrt(sum((points(1 : i - 1, :) - repmat(point, i - 1, 1)) .^ 2, 2)));
            if min_dist > best_dist
                best_dist = min_dist;
                best_point = point;
            end
        end
        points(i, :) = best_point;
    end
end