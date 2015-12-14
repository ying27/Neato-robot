classdef mapClass<handle
   properties
      map;
   end
   
   methods
       
       function obj = mapClass()
           obj@handle();
           obj.map = logical(imread('map_20_bw.png'));  
       end
              
       function ret = isEmpty(obj,x,y)
           ret = obj.map(x,y) == 1;
       end
       
       function setDot(obj,x,y)
           obj.map(x,y) = 0;
       end
       
       function ret = getMap(obj)
           ret = obj.map;
       end  
       
       function showMap(obj)
           imshow(obj.map);
       end
   end
end