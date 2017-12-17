function showTable(h_lbl_table, hull, inner, undefined)
    table = {'| hull | inner | undefined |'};
    hull_size = length(hull);
    inner_size = length(inner);
    undefined_size = length(undefined);
    table_size = max([hull_size, inner_size, undefined_size]);
    for i = 1 : table_size
        line = '';
        if i <= hull_size
            line = strcat(line, sprintf('| % 3d  |', hull(i)));
        else
            line = strcat(line, '|      |');
        end
        if i <= inner_size
            line = strcat(line, sprintf(' % 3d   |', inner(i)));
        else
            line = strcat(line, '       |');
        end
        if i <= undefined_size
            line = strcat(line, sprintf('   % 3d     |', undefined(i)));
        else
            line = strcat(line, '           |');
        end
        table = cat(2, table, line);
    end
    set(h_lbl_table, 'string', table);
end