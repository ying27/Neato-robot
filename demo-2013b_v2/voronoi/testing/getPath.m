function p = getPath(a,b,c,d)
    %the two points must be part of the voronoid path
    %goal
    %x = 158;
    %y = 1153;
    
    %initial position
    %xx = 445;
    %yy = 242;
    
    p = [];
    
    [xx,yy,x,y] = getStartEndInPath(a,b,c,d);
    
    if xx ~= a || yy ~= b
        p(end+1,:) = [a,b];
    end
    
    p(end+1,:) = [xx,yy];
    
    m = directedMap(xx,yy);
    q = cell2mat(m(xx,yy));
    while size(q) > 0
        aux = q(1,:);
        if size(q) > 1
            mi = getNearest(x,y,aux(1),aux(2),m);
            for i = 2 : size(q)
                if getNearest(x,y,q(i,1),q(i,2),m) < mi
                    aux = q(i,:);
                end
            end
        end
        p(end+1,:) = aux;
        q = cell2mat(m(aux(1),aux(2)));
    end
    
    if p(end,1) ~= c || p(end,2) ~= d
        p(end+1,:) = [c,d];
    end    
end