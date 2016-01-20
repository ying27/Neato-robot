function [ret] = readLDS(sck)
    %returns the objects in the local map.
    %the result is a list of coordinates (x,y)
    msg = ['GetLDSScan'];
    data = sck.sendMsg(sck,msg);
    C = regexp(char(data), '[;]', 'split');
    C = C(3:362);
    j = 1;
    ret = [];
    parsed = zeros(360,3);
    
    
    
    %beta%
    limit = 500;
    next = regexp(char(C(2)), '[,]', 'split');
    ndist = str2double(char(next(2)));
    
    aux = regexp(char(C(1)), '[,]', 'split');
    dist = str2double(char(aux(2)));
    
    if dist < 1000 && abs(dist-ndist) < limit 
        parsed(1,:) = [1,str2double(char(aux(2))),str2double(char(aux(3)))];
    else
        parsed(1,:) = [1,0,0];
    end
    aux = next;
    dist = ndist;
    %%%%%%
    
    
    for index = 2:359
       next = regexp(char(C(index+1)), '[,]', 'split');
       ndist = str2double(char(next(2)));
       if dist < 750 && (abs(dist-ndist) < limit || abs(dist-parsed(index-1,2)) < limit)
           parsed(index,:) = [index,str2double(char(aux(2))),str2double(char(aux(3)))];
           %j = j + 1;
       else
           parsed(index,:) = [index,0,0];
       end       
       aux = next;
       dist = ndist;
    end
    
    
    %beta%
    if dist < 500 && abs(dist-parsed(359,2)) < limit
        parsed(1,:) = [1,str2double(char(aux(2))),str2double(char(aux(3)))];
    else
        parsed(360,:) = [360,0,0];        
    end
    %%%%%%
    
    
   for i = 1:360
      alpha = parsed(i,1);
      dist = parsed(i,2)/10;
      [newx,newy] = pol2cart(deg2rad(alpha),dist);
      %newx = (sin(alpha)*dist)%-9.5;
      %newy = cos(alpha)*dist;%-9.5;
      ret(j,:) = [round(newx),round(newy)];
      j = j + 1;
   end
    
    
    %{
    for i = 1:90
        if (parsed(i,2) ~= 0)
            alpha = degtorad(parsed(i,1));
            dist = parsed(i,2)/10;
            %-9.5 is because the laser it's not in the center of the robot
            newx = (sin(alpha)*dist)%-9.5;
            newy = cos(alpha)*dist;%-9.5;
            ret(j,:) = [round(newx),round(newy)];
            j = j + 1;
        end
    end
    
    for i = 91:180
        if (parsed(i,2) ~= 0)
            alpha = degtorad(parsed(i,1)-90);
            dist = parsed(i,2)/10;
            
            newx = -(cos(alpha)*dist)-9.5;
            newy = (sin(alpha)*dist);%-9.5;
            ret(j,:) = [round(newx),round(newy)];
            j = j + 1;
        end
    end
    
    
    for i = 181:270
        if (parsed(i,2) ~= 0)
            alpha = degtorad(parsed(i,1)-180);
            dist = parsed(i,2)/10;
            
            newx = -(cos(alpha)*dist)-9.5;
            newy = -(sin(alpha)*dist);%-9.5;
            ret(j,:) = [round(newx),round(newy)];
            j = j + 1;
        end
    end
    
    
    
    for i = 271:360
        if (parsed(i,2) ~= 0)
            alpha = degtorad(parsed(i,1)-270);
            dist = parsed(i,2)/10;
            newx = (cos(alpha)*dist)-9.5;
            newy = -sin(alpha)*dist;%-9.5;
            ret(j,:) = [round(newx),round(newy)];
            j = j + 1;
        end
    end
  %}
    
    
end