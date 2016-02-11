function B = getSplineBasisFromKnots(knots,x)
    %Evaluates the cubic B spline with knots specified in the knots vector
    %at positions x. Returns a matrix B which is m by n, where m is
    %length(x) and n is length(knots)-4 (one column for each basis
    %function.
    myspline=spmak(knots,eye(length(knots)-4));
    B = spval(myspline,x(:)')';
end