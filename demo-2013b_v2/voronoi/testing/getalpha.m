function alpha = getalpha(q, w, j, i)

    %(q,w) = punt origen
    %(j,i) = punt desti
    
    if (j <= q && i <= w)
        alpha = floor((pi-atan(abs(i-w)/abs(j-q)))*360/(2*pi));
    elseif (i >= w && j <= q)
        alpha = floor((pi+atan(abs(i-w)/abs(j-q)))*360/(2*pi));
    elseif (i >= w && j >= q)
        alpha = floor((2*pi-atan(abs(i-w)/abs(j-q)))*360/(2*pi));
    else 
        alpha = floor((atan(abs(i-w)/abs(j-q)))*360/(2*pi));
    end