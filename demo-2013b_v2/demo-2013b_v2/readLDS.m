function [ret] = readLDS(sck)
    msg = ['GetLDSScan'];
    data = sck.sendMsg(sck,msg);
    C = regexp(char(data), '[;]', 'split');
    C = C(3:362);
    j = 1;
    parsed = zeros(360,3);
    for index = 1:360
       aux = regexp(char(C(index)), '[,]', 'split');
       if str2double(char(aux(2))) < 5000
           parsed(index,:) = [index,str2double(char(aux(2))),str2double(char(aux(3)))];
           %j = j + 1;
       else
           parsed(index,:) = [index,0,0];
       end       
       
    end
    
    parsed
    
    
    for i = 1:90
        if (parsed(i,2) ~= 0)
            alpha = degtorad(parsed(i,1));
            dist = parsed(i,2)/10;
            newx = -(sin(alpha)*dist);
            newy = cos(alpha)*dist-9.5;
            ret(j,:) = [round(newx),round(newy)];
            j = j + 1;
        end
    end
    
    for i = 91:180
        if (parsed(i,2) ~= 0)
            alpha = degtorad(parsed(i,1)-90);
            dist = parsed(i,2)/10;
            
            newx = -(cos(alpha)*dist);
            newy = -(sin(alpha)*dist)-9.5;
            ret(j,:) = [round(newx),round(newy)];
            j = j + 1;
        end
    end
    
    
    for i = 181:270
        if (parsed(i,2) ~= 0)
            alpha = degtorad(parsed(i,1)-180);
            dist = parsed(i,2)/10;
            
            newx = sin(alpha)*dist;
            newy = -(cos(alpha)*dist)-9.5;
            ret(j,:) = [round(newx),round(newy)];
            j = j + 1;
        end
    end
    
    
    
    for i = 271:360
        if (parsed(i,2) ~= 0)
            alpha = degtorad(parsed(i,1)-270);
            dist = parsed(i,2)/10;
            newx = cos(alpha)*dist;
            newy = sin(alpha)*dist-9.5;
            ret(j,:) = [round(newx),round(newy)];
            j = j + 1;
        end
    end
    
    
    
    
    
    
    
    
    
end