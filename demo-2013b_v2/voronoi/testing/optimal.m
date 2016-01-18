function ret = getOptimalPath(path)
    ret = [path(1,:)];
    
    alpha = abs(atan((path(2,2)-path(1,2))/(path(2,1)-path(1,1))));
    
    for i = 2:(size(path)-2)
            aux = abs(atan((path(i,2)-ret(end,2))/(path(i,1)-ret(end,1))));
            if (aux > alpha*1.02 || aux < alpha*0.98) %&& (abs(alpha - aux) >= 0.2662)
                ret(end+1,:) = path(i,:);
                alpha = abs(atan((path(i+1,2)-ret(end,2))/(path(i+1,1)-ret(end,1))));
            end
    end
    ret(end+1,:) = path(end-1,:);
    ret(end+1,:) = path(end,:);
end