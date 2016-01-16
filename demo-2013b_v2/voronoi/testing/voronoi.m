function ret = voronoi()
    k = 5;
    m = mapClass();
    mapa = m.getMap();
    
    mapd = ~imdilate(~mapa, strel('square', 21));    
    skel = bwmorph(mapd, 'thin', Inf);
    imshow(skel);
    
    %find first contour point
    [he,wi] = size(skel);
    nfound = true;
    i = 1;
    while nfound && i < wi
        j = 1;
        while nfound && j < he
            if (skel(j,i) == 1)
                nfound = false;
            end
            j = j+1;
        end
        i = i+1;
    end
    i = i - 1;
    j = j - 1;
    
    %-----------------------------------------------------------------
    
    
    it = 1;
    %ret(it,:) = [j,i];
    %[a,b] = getnext(skel,j,i);
    a = j;
    b = i;
    q = 0;
    while a ~= -1 && b ~= -1
        skel(a,b) = 0;
        if mod(q,k) == 0
            ret(it,:) = [a,b];
            it = it + 1;
        end
        q = q + 1
        [a,b] = getnext(skel,a,b);
    end


function [xx,yy] = getnext(imgc, x, y)
    %imgc(y,x)
    %X and Y must be empty in the imgc
    aux = -1;
    auy = -1;
    
    for (i=x-1:x+1)
        for (j=y-1:y+1)
            if (imgc(i,j) == 1)
                aux = i;
                auy = j;
            end
        end
    end
    xx = aux;
    yy = auy;
    
