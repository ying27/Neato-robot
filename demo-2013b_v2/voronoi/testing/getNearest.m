function mi = getNearest(x,y,xx,yy,m)
    %(x,y) = punt final
    %(xx,yy) = punt de partida
    
    import java.util.LinkedList
    
    mi = distp(x,y,xx,yy);
    q = LinkedList();
    
    w = cell2mat(m(xx,yy));
    for i = 1 : size(w)
        q.add(w(i,:));
    end

    while mi > 0 && q.size() ~= 0
        aux = q.remove();
        w = cell2mat(m(aux(1),aux(2)));
        for i = 1 : size(w)
            q.add(w(i,:));
        end
        mi = min(mi,distp(x,y,aux(1),aux(2)));
    end
end

