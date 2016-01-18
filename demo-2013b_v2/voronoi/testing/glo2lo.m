function [a,b] = glo2lo(x,y)
    obj = struct('orient',0,'x',0,'y',0);
    %Transforms global coordinates to local coordinates
    q = global2localcoord([x;y;0],'rr',[obj.x;obj.y;0]);

    a = round(cos(deg2rad(obj.orient))*q(1) + sin(deg2rad(obj.orient))*q(2));
    b = round(-sin(deg2rad(obj.orient))*q(1) + cos(deg2rad(obj.orient))*q(2));