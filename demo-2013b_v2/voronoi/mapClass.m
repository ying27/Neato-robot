classdef mapClass<handle
   properties
      map;
   end
   
   methods
       
       function obj = mapClass()
           obj@handle();
           obj.map = logical(imread('map_100_bw.png'));
       end
              
       function ret = isEmpty(obj,x,y)
           ret = obj.map(x,y) == 1;
       end
       
       function setDot(obj,x,y)
           if x > 0 && y > 0
               obj.map(x,y) = 0;
           end
       end
       
       function setAllDots(obj,a)
           [h w] = size(a);
           for i=1 : h
               if a(i,1) > 0 && a(i,2) > 0
                   obj.map(a(i,1),a(i,2)) = 0;
               end
           end
       end
       
       
       function ret = getMap(obj)
           ret = obj.map;
       end  
       
       function showMap(obj)
           imshow(obj.map);
       end
   end
end