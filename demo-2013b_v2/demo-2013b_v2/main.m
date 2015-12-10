function main(sck)
    % Send data mode message (required handshaking)
    msg = ['DataMode listener']; % altres modes constant  moody
    data = sck.sendMsg(sck,msg);
    display(data);


    msg = ['JoystickMode Off']; % altres modes constant  moody
    data = sck.sendMsg(sck,msg);
    display(data);

    % Wait lidar start
    wait_lidar();

    %########## END NEEDED CODE ######################

    %#################################################
    %### Demo robot movement and data acquisition ###

    %[l,r] = readWheelPosition(sck)

    move(0.5,sck);
    rotate('r',sck);
    move(0.5,sck);
    rotate('l',sck);
    move(0.5,sck);



    %[l r] = readWheelPosition(sck)

    %readLDS(sck)

end