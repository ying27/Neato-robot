classdef robotClass<handle
    properties
        x;
        y;
        leftWheel;
        rightWheel;
        orient;
        sck;
        map;
    end
    
    methods
        
        function obj = robotClass(sck,x,y,map)
            obj@handle();
            
            %Punto C
            obj.x = x;
            obj.y = y;
            
            %grados respecto a al eje x del mapa
            %el eje x del robot es mirando en frente
            obj.orient = 0;
            
            obj.sck = sck;
            obj.leftWheel = 0;
            obj.rightWheel = 0;
            obj.map = map;
        end
        
        function ret = getPosition(obj)
            ret = [obj.x,obj.y];
        end
        
        function ret = getMap(obj)
            ret = obj.map;
        end
        
        function [a,b] = lo2glo(obj,x,y)
            %Transforms local coordinates to global coordinates
            xx = round(cos(deg2rad(-obj.orient))*x + sin(deg2rad(-obj.orient))*y);
            yy = round(-sin(deg2rad(-obj.orient))*x + cos(deg2rad(-obj.orient))*y);
            
            q = local2globalcoord([xx;yy;0],'rr',[obj.x;obj.y;0]);
            a = q(1);
            b = q(2);
        end
           
        function [a,b] = glo2lo(obj,x,y)
            %Transforms global coordinates to local coordinates
            q = global2localcoord([x;y;0],'rr',[obj.x;obj.y;0]);
            
            a = round(cos(deg2rad(obj.orient))*q(1) + sin(deg2rad(obj.orient))*q(2));
            b = round(-sin(deg2rad(obj.orient))*q(1) + cos(deg2rad(obj.orient))*q(2));
        end
        
        function [a] = getObjects(obj)
            %Returns objects in the global coordinates system
            ldsscan = readLDS(obj.sck);
            [h w] = size(ldsscan);
            a = zeros(h,2);
            
            for i = 1 : h
                [q,w] = obj.lo2glo(ldsscan(i,1),ldsscan(i,2));
                a(i,:) = [q,w];
            end
            
        end
        
        function [l,r] = readWheelPosition(obj)
            msg = ['GetMotors LeftWheel RightWheel'];
            data = obj.sck.sendMsg(obj.sck,msg);
            C = regexp(char(data), '[;,]', 'split');
            laux = str2double(C(1,9));
            raux = str2double(C(1,17));
            l = laux - obj.leftWheel;
            r = raux - obj.rightWheel;
            obj.leftWheel = laux;
            obj.rightWheel = raux;
        end
        
        function okay = moveTo(obj,x,y)
            
            dist = sqrt((x-obj.x)^2+(y-obj.y)^2)*10;
            
            [q1,q2] = obj.glo2lo(x,y);
            x = q1;
            y = q2;
            
            alpha = atan2(y, x) - atan2(0, 1);
            alpha = alpha * 360 / (2*pi);
            if (alpha < 0)
                alpha = alpha + 360;
            end
                                    
            %Rotate the robot to the correct orient
            obj.rotate(alpha);
            
            speed = 120;
            msg = ['SetMotor LWheelDist ', num2str(dist) ,' RWheelDist ', num2str(dist) , ' Speed ', num2str(speed)];
            datam = obj.sck.sendMsg(obj.sck,msg);
            %display(datam);
            okay = obj.wait(dist,speed);
            aux = obj.getObjects();    
            obj.map.setAllDots(aux);
        end
        
        function rotate(obj,alpha)
            %Alpha must be positive
            rel = 190/90;
            speed = 120;
            if alpha > 180
               dist = round(((360-alpha))*rel)*-1;
            else
               dist = round(alpha*rel);
            end
            
            msg = ['SetMotor LWheelDist ', num2str(-dist) ,' RWheelDist ', num2str(dist) , ' Speed ', num2str(speed)];
            obj.sck.sendMsg(obj.sck,msg);
            datam = obj.sck.sendMsg(obj.sck,msg);
            %display(datam);
            pause(abs(dist/speed));            
            %Actualizar la ortientacion del robot
            obj.orient = mod(obj.orient + alpha,360);
        end
        
        function ret = detect(obj)
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
                okay = ~obj.detect();
                t = toc;
            end
            msg = ['SetMotor LWheelDist ', num2str(1) ,' RWheelDist ', num2str(1) , ' Speed ', num2str(1)];
            obj.sck.sendMsg(obj.sck,msg);
                        
            [l,r] = obj.readWheelPosition();
            dist = round(((l+r)/2)/10);
            [q1,q2] = lo2glo(obj,dist,0);
            obj.x = q1;
            obj.y = q2;
            %{
            if ~okay
                dist = round(((l+r)/2)/10);
                l = mod(l,10);
                r = mod(r,10);
                if (l ~= 0 && r ~= 0)
                    sp = speed/2;
                    msg = ['SetMotor LWheelDist ', num2str(-l) ,' RWheelDist ', num2str(-r) , ' Speed ', num2str(sp)];
                    datam = obj.sck.sendMsg(obj.sck,msg);
                    display(datam);
                    pause(dist/sp);
                end
            end
          %}
        end      
        
    end
end
