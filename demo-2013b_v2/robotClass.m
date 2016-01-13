classdef robotClass<handle
    properties
        x;
        y;
        leftWheel;
        rightWheel;
        orientation;
        sck;
        map;
    end
    
    methods
        
        function obj = robotClass(sck,map)
            obj@handle();
            obj.x = 132;
            obj.y = 95;
            obj.orientation = 2;
            obj.sck = sck;
            obj.leftWheel = 0;
            obj.rightWheel = 0;
            obj.map = map;
        end
        
        function ret = getPosition(obj)
            ret = [obj.x,obj.y];
        end
        
        function ret = getMap(obj)
            ret = obj.map.getMap();
        end
        
        function [a] = getObjects(obj)
            ldsscan = readLDS(obj.sck);
            [h w] = size(ldsscan);
            
            a = zeros(h,2);
            
            if (obj.orientation == 0)
                for i = 1 : h
                    a(i,:) = [-ldsscan(i,2)+obj.x,ldsscan(i,1)+obj.y];
                end
                
            elseif (obj.orientation == 1)
                for i = 1 : h
                    a(i,:) = [ldsscan(i,1)+obj.x,ldsscan(i,2)+obj.y];
                end
                
            elseif (obj.orientation == 2)
                for i = 1 : h
                    a(i,:) = [ldsscan(i,2)+obj.x,-ldsscan(i,1)+obj.y];
                end
                
            else
                for i = 1 : h
                    a(i,:) = [-ldsscan(i,1)+obj.x,-ldsscan(i,2)+obj.y];
                end
            end
            
        end
        
        function [l,r] = readWheelPosition(obj)
            msg = ['GetMotors LeftWheel RightWheel'];
            data = obj.sck.sendMsg(obj.sck,msg);
            C = regexp(char(data), '[;,]', 'split');
            laux = C(9);
            raux = C(17);
            l = laux - obj.leftWheel;
            r = raux - obj.rightWheel;
            obj.leftWheel = laux;
            obj.rightWheel = raux;
        end
        
        function okay = moveTo(obj,dist)
            dist = 10*dist;
            speed = 120;
            msg = ['SetMotor LWheelDist ', num2str(dist) ,' RWheelDist ', num2str(dist) , ' Speed ', num2str(speed)];
            datam = obj.sck.sendMsg(obj.sck,msg);
            display(datam);
            okay = obj.wait(dist/speed);
            aux = obj.getObjects();    
            obj.map.setAllDots(aux);
        end
        
        function rotateTo(obj,dir)
            dist = 190;
            speed = 120;
            if dir == 'l'
                msg = ['SetMotor LWheelDist ', num2str(-dist) ,' RWheelDist ', num2str(dist) , ' Speed ', num2str(speed)];
            else
                msg = ['SetMotor LWheelDist ', num2str(dist) ,' RWheelDist ', num2str(-dist) , ' Speed ', num2str(speed)];
            end
            obj.sck.sendMsg(obj.sck,msg);
            datam = obj.sck.sendMsg(obj.sck,msg);
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
        
        function ret = detect(~)
            ret = false;
            ldsscan = readLDS(obj.sck);
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
        
        function okay = wait(obj,dist,speed)
            tic;
            tlimit = dist/speed;
            t = toc;
            okay = true;
            while (t < tlimit && okay)
                okay = ~detect();
                t = toc;
            end
            %TODO: check if distant 0 and speed 0 works
            msg = ['SetMotor LWheelDist ', num2str(0) ,' RWheelDist ', num2str(0) , ' Speed ', num2str(0)];
            obj.sck.sendMsg(obj.sck,msg);
            
            [l,r] = obj.readWheelPosition();
            
            if ~okay
                dist = round(((l+r)/2)/10);
                l = mod(l,10);
                r = mod(r,10);
                if (l ~= 0 && r ~= 0)
                    sp = speed/2;
                    msg = ['SetMotor LWheelDist ', num2str(l) ,' RWheelDist ', num2str(r) , ' Speed ', num2str(-sp)];
                    datam = obj.sck.sendMsg(obj.sck,msg);
                    display(datam);
                    pause(dist/sp);
                end
            end
            
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
        
    end
end
