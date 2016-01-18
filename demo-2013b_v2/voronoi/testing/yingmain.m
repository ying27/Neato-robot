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
    
    initx = 132;
    inity =  22;
    finalx = 190;
    finaly = 1221;
    
    m = mapClass();
    rob = robotClass(sck,initx,inity,m);
    dm = directedMap(m,initx,inity);
    path = dm.getQueuePath(finalx,finaly)
    
    while path.size() > 0
        path_position = path.remove()
        mv = rob.moveTo(path_position(1),path_position(2));
        robot_position = rob.getPosition()
        display('*****')
        %{
        if ~mv
            dm = directedMap(rob.getMap(),rob.x,rob.y);
            path = dm.getQueuePath(finalx,finaly);
        end
        %}
    end
    
    
    
    %{
    initx = 132;
    inity =  95;
    finalx = 190;
    finaly = 1221;
    
    m = mapClass();
    rob = robotClass(sck,initx,inity,m);
    
    
    rob.rotate(90);
    a = rob.getObjects();
    figure;
    scatter(a(:,1),a(:,2));
    
    rob.rotate(90);
    a = rob.getObjects();
    figure;
    scatter(a(:,1),a(:,2));
    
    rob.rotate(90);
    a = rob.getObjects();
    figure;
    scatter(a(:,1),a(:,2));
    
    rob.rotate(90);
    a = rob.getObjects();
    figure;
    scatter(a(:,1),a(:,2));
    %}
    
    %{
    initx = 132;
    inity =  95;
    
    m = mapClass();
    rob = robotClass(sck,initx,inity,m);
    rob.moveTo(252,135);
    rob.getPosition()
    
    rob.moveTo(332,95);
    rob.getPosition()
    
    rob.moveTo(327,255);
    rob.getPosition()
    %}
    %{
    initx = 132;
    inity =  95;
    
    m = mapClass();
    rob = robotClass(sck,initx,inity,m);
    rob.moveTo(142,95);
    rob.getPosition()
    %}
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