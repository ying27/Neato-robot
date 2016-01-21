function ret = getOptPath(path)
    initx = path(1,1);
    inity =  path(1,2);
    finalx = path(end,1);
    finaly = path(end,1);
    
    [a,b] = size(path);
    
    if 2 < a        
        alpha = -atan((finaly-inity)/(finalx-initx));
        
        for i = 1 : size(path)
            xx = round(cos(-alpha)*path(i,1) + sin(alpha)*path(i,2));
            yy = round(-sin(-alpha)*path(i,1) + cos(alpha)*path(i,2));
            op(i,:) = [xx,yy];
        end
        
        limit = abs(op(1,2));
        if any(abs(op(2:(end-1),2)) > limit)
            half = round(size(path)/2);
            head = path(1:half,:);
            tail = path(half + 1 : end,:);
            hres = getOptPath(head);
            tres = getOptPath(tail);
            ret = vertcat(hres, tres);
        else
            ret = vertcat(path(1,:), path(end,:));
        end
    else
        ret = path;
    end
end