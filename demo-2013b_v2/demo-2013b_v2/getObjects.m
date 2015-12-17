function [a] = getObjects(x,y,orient, sck)
    ldsscan = readLDS(sck);
    [h w] = size(ldsscan);
    
    for i = 1:h
        newx = sin(ldsscan(i,1))*(ldsscan(i,2)/50)+x;
        newy = cos(ldsscan(i,1))*(ldsscan(i,2)/50)+y;
        a(i,:) = [newx,newy];
    end
    
    
    
    if orient == 0
        tx = -1;
        ty = -1;
    elseif orient == 1
        tx = 1;
        ty = -1
    elseif orient == 2
        tx = 1;
        ty = 1;
    else
        tx = -1;
        ty = 1;
        
        
    for i = 1:h
        a(i) = [a(i,1)*tx+x,a(i,2)*ty+y];        
    end
    
end