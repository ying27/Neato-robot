function yingmain(sck)
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
    
    m = mapClass();    
    rob = robotClass(sck,m);
    
    aux = rob.getObjects();
    
    scatter(aux(:,1),aux(:,2));
    
    %m.setAllDots(aux);
    %m.showMap();
    
    %scatter(aux(:,1),aux(:,2))
    
    
    %ldsscan = readLDS(sck);
    %scatter(ldsscan(:,1),ldsscan(:,2))
    
end



%######## Functions ##########
function wait_lidar()  % Wait 4 seconds for lidar wake up
    wt = waitbar(0,'Waiting Lidar Start...');
    for p=1:4
        pause(1);
        waitbar(p/4,wt,'Waiting Lidar Start......');
    end
    close(wt);
end