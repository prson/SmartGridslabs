% the objective function of the optimization is computed in the function
% here, it is the sum of the reactive power injections, however, we assume
% that minimizing reactive power injection will minimize power losses.

function sqr=fun(x)
    sqr=sum(x(4:end).^2);
end