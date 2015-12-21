function [a] = getObjects(x,y,orient, sck)
    ldsscan = readLDS(sck);
    [h w] = size(ldsscan);
    
    a = zeros(h,2);
    
    if (orient == 0)
      for i = 1 : h
         a(i,:) = [-ldsscan(i,2)+x,ldsscan(i,1)+y];
      end 
      
    elseif (orient == 1)
      for i = 1 : h
         a(i,:) = [ldsscan(i,1)+x,ldsscan(i,2)+y];
      end
      
    elseif (orient == 2)
      for i = 1 : h
         a(i,:) = [ldsscan(i,2)+x,-ldsscan(i,1)+y];
      end
      
    else
      for i = 1 : h
         a(i,:) = [-ldsscan(i,1)+x,-ldsscan(i,2)+y];
      end      
    end    
    
end