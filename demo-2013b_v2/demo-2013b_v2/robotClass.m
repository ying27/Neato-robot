classdef robotClass<handle
   properties
      x;
      y;
      orientation;
      sck;
   end
   
   methods
       
       function obj = robotClass(sck)
           obj@handle();
           obj.x = 132;
           obj.y = 95;
           obj.orientation = 2;
           obj.sck = sck;
       end
                     
       function ret = getPosition(obj)
           ret = [obj.x,obj.y];
       end
       
       function moveTo(obj,dist,sck)     
            dist = 10*dist;
            speed = 120;
            msg = ['SetMotor LWheelDist ', num2str(dist) ,' RWheelDist ', num2str(dist) , ' Speed ', num2str(speed)];
            datam = sck.sendMsg(sck,msg);
            display(datam);
            pause(dist/speed);

            if obj.orientation == 0
                obj.x = obj.x-dist;
            elseif obj.orientation == 1
                obj.y = obj.y+dist;
            elseif obj.orientation == 2
                obj.x = obj.x+dist;
            else
                obj.y = obj.y-dist;
            end
       end
       
       function rotateTo(obj,dir,sck)
           dist = 190;
           speed = 120;    
           if dir == 'l'
                msg = ['SetMotor LWheelDist ', num2str(-dist) ,' RWheelDist ', num2str(dist) , ' Speed ', num2str(speed)];
           else
                msg = ['SetMotor LWheelDist ', num2str(dist) ,' RWheelDist ', num2str(-dist) , ' Speed ', num2str(speed)];
           end
           sck.sendMsg(sck,msg);
           datam = sck.sendMsg(sck,msg);
           display(datam);
           pause(abs(dist/speed));

           if obj.orientation == 0 && dir == 'l'
               obj.orientation = 3;
           elseif obj.orientation == 3 && dir == 'r'
               obj.orientation = 0;
           elseif dir == 'l'
               obj.orientation = dir-1;
           else
               obj.orientation = dir+1;
           end       
       end
       
       
       
        function ret = detect(~,sck)
          ret = false;
          ldsscan = readLDS(sck)
          [h,w] = size(ldsscan);
          
          i = 1;
          
          while (i < h && ~ret)
              
            if (ldsscan(i,1) >= 294 || ldsscan(i,1) <= 26)
                
               if ldsscan(i,1) >= 26 &&  ldsscan(i,1) <= 66
                  if (165/cos(degtorad(90-ldsscan(i,1)))) > ldsscan(i,2)               
                     ret = true;
                     return
                  end

               elseif ldsscan(i,1) >= 294 &&  ldsscan(i,1) <= 334
                  if (165/cos(degtorad(ldsscan(i,1)-270))) > ldsscan(i,2)
                     ret = true;
                     return
                  end
               else
                  if ldsscan(i,2) < 750
                      ret = true;
                      return
                  end
               end
            end
            
            i = i+1;
            
          end
            
            
        end
       
       
       
       
       
       
   end
end
