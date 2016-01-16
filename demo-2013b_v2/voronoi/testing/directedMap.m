function c = directedMap(x,y)
    import java.util.LinkedList

    m = mapClass();
    skel = m.getSkel();
    %imshow(skel);

    [a b] = size(skel);

    c = cell(a,b);
    q = LinkedList();
    q.add([x,y]);
    while q.size() ~= 0
        ret = q.remove();
        [skel, childs] = getnexts(ret(1),ret(2),skel);
        c(ret(1),ret(2)) = {childs};
        for f = 1 : size(childs)
            q.add(childs(f,:));
        end
    end
end