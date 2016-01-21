classdef mapClass<handle
   properties
      map;
   end
   
   methods
       
       function obj = mapClass()
           obj@handle();
           m = logical(imread('map_100_bw.png'));
           %{
           for i = 1 : 500
               for j = 303 : 1310
                   m(i,j) = false
               end
           end
           %}
           m(1:500,303:885) = false;
           obj.map = m;
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
       
       function showPathInMap(obj,a)
           [h w] = size(a);
           aux = obj.map;
           
           for i=1 : h
               if a(i,1) > 0 && a(i,2) > 0
                   aux(a(i,1),a(i,2)) = 0;
               end
           end
           imshow(aux)
           
       end
       
       
       function ret = getMap(obj)
           ret = obj.map;
       end
       
       function ret = getSkel(obj)
           mapd = ~imdilate(~obj.map, strel('square', 15));
           ret = bwmorph(mapd, 'thin', Inf);
       end
       
       function ret = getSkelList(obj)
           skel = obj.getSkel();
           [q,w] = size(skel);
           ret = [];
           for i = 1 : q
               for j = 1 : w
                   if skel(i,j) == 1
                       ret(end+1,:) = [i,j];
                   end
               end
           end
       end
       
       function showMap(obj)
           figure;
           imshow(obj.map)
       end
   end
end