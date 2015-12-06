function rotate(dir,sck)
    dist = 190;
    speed = 120;    
    if dir == 'l'
         msg = ['SetMotor LWheelDist ', num2str(-dist) ,' RWheelDist ', num2str(dist) , ' Speed ', num2str(speed)];
    else
         msg = ['SetMotor LWheelDist ', num2str(dist) ,' RWheelDist ', num2str(-dist) , ' Speed ', num2str(speed)];
        
    end
    
    sck.sendMsg(sck,msg);
    %datam = sck.sendMsg(sck,msg);
    %display(datam);

    % Wait until movement stops
    pause(abs(dist/speed));
end