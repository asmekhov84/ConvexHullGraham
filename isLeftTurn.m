% Check that three consecutive points are turning anticlockwise.
function result = isLeftTurn(a, b, c)
    result = ((b(1) - a(1)) * (c(2) - a(2)) - (b(2) - a(2)) * (c(1) - a(1)) > 0);
end