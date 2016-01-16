function [imgc,a] = getnexts(x,y,imgc)
    imgc(x,y) = 0;
    a = [];
    q = 1;

    for i=x-1:x+1
        for j=y-1:y+1
            if imgc(i,j) == 1
                a(q,:) = [i,j];
                q = q + 1;
            end
        end
    end

end