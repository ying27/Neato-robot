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
            
            %Punto C
            %obj.x = 132;
            %obj.y = 95;
            obj.x = 0;
            obj.y = 0;
            
            %grados respecto a al eje x del mapa
            %el eje x del robot es mirando en frente
            obj.orientation = 0;
            
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
        
        function [a,b] = lo2glo(obj,xx,yy)
            %Transforms local coordinates to global coordinates
            %xx = cos(obj.orientation)*x + sin(obj.orientation)*y;
            %yy = -sin(obj.orientation)*x + cos(obj.orientation)*y;
            q = local2globalcoord([xx;yy;0],'rr',[obj.x;obj.y;0]);
            a = q(1);
            b = q(2);
        end
           
        function [a,b] = glo2lo(obj,x,y)
            %Transforms global coordinates to local coordinates
            xx = cos(obj.orientation)*x + sin(obj.orientation)*y;
            yy = -sin(obj.orientation)*x + cos(obj.orientation)*y;
            q = global2localcoord([xx;yy;0],'rr',[obj.x;obj.y;0]);
            a = q(1);
            b = q(2);
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
            laux = C(9);
            raux = C(17);
            l = laux - obj.leftWheel;
            r = raux - obj.rightWheel;
            obj.leftWheel = laux;
            obj.rightWheel = raux;
        end
        
        function okay = moveTo(obj,x,y)
            
            dist = sqrt((x-obj.x)^2+(y-obj.y)^2);
            
            q = obj.glo2lo(x,y)';
            x = q(1);
            y = q(2);
            
            alpha = atan2(y, x) - atan2(0, 1);
            alpha = alpha * 360 / (2*pi);
            if (alpha < 0)
                alpha = alpha + 360;
            end
                        
            %Rotate the robot to the correct orientation
            obj.rotate(alpha);
            
            speed = 120;
            msg = ['SetMotor LWheelDist ', num2str(dist) ,' RWheelDist ', num2str(dist) , ' Speed ', num2str(speed)];
            datam = obj.sck.sendMsg(obj.sck,msg);
            display(datam);
            okay = obj.wait(dist/speed);
            aux = obj.getObjects();    
            obj.map.setAllDots(aux);
        end
        
        function rotate(obj,alpha)
            %Alpha must be positive
            rel = 190/90;
            speed = 120;
            dist = round(alpha*rel);
            msg = ['SetMotor LWheelDist ', num2str(-dist) ,' RWheelDist ', num2str(dist) , ' Speed ', num2str(speed)];
            obj.sck.sendMsg(obj.sck,msg);
            datam = obj.sck.sendMsg(obj.sck,msg);
            display(datam);
            pause(abs(dist/speed));            
            
            obj.orientation = mod(obj.orientation + alpha,360);
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
                okay = ~detect();
                t = toc;
            end
            %TODO: check if distant 0 and speed 0 works
            msg = ['SetMotor LWheelDist ', num2str(0) ,' RWheelDist ', num2str(0) , ' Speed ', num2str(1)];
            obj.sck.sendMsg(obj.sck,msg);
                        
            [l,r] = obj.readWheelPosition();
            dist = round(((l+r)/2)/10);
            [a,b] = lo2glo(obj,0,dist);
            obj.x = a;
            obj.y = b;
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
