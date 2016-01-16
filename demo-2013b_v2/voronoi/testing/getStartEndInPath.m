function [initx,inity,finalx,finaly] = getStartEndInPath(x,y,xx,yy)
    m = mapClass();
    list = m.getSkelList();
    
    mi = distp(x,y,list(1,1),list(1,2));
    initx = list(1,1);
    inity = list(1,2);
    
    for i = 2 : size(list)
        q = distp(x,y,list(i,1),list(i,2));
        if q < mi
            mi = q;
            initx = list(i,1);
            inity = list(i,2);
        end
    end
    
    mi = distp(xx,yy,list(1,1),list(1,2));
    finalx = list(1,1);
    finaly = list(1,2);
    
    for i = 2 : size(list)
        q = distp(xx,yy,list(i,1),list(i,2));
        if q < mi
            mi = q;
            finalx = list(i,1);
            finaly = list(i,2);
        end
    end
    
end