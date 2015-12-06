function move(dist,sck)
    
    dist = 1000*dist
    speed = 120; %[mm/s]
    msg = ['SetMotor LWheelDist ', num2str(dist) ,' RWheelDist ', num2str(dist) , ' Speed ', num2str(speed)];
    datam = sck.sendMsg(sck,msg);
    display(datam);
    pause(dist/speed);
end