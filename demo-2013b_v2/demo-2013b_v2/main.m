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

    m = mapClass();
    
    rob = robotClass(sck);
    
    %ldsscan = readLDS(sck)
    
    g(:,:) = getObjects(25,5,2, sck);
    %for i = 1 : size(g,1)
    %    m.setDot(g(i,1),g(i,2));
    %end
    
    %m.showMap;

     %{
    rob.rotateTo('l',sck);
    rob.detect(sck)
    rob.rotateTo('l',sck);
    rob.detect(sck)
    rob.rotateTo('l',sck);
    rob.detect(sck)
    rob.rotateTo('l',sck);
    rob.detect(sck)
    %}
    
    
    %rob.moveTo(5,sck);
    %move(0.5,sck);
    
    %rob.move(5,sck);
    
    %[l,r] = readWheelPosition(sck)
    
    %{
    move(0.5,sck);
    rotate('r',sck);
    move(0.5,sck);
    rotate('l',sck);
    move(0.5,sck);
    %}


    %[l r] = readWheelPosition(sck)
    
    %re = readLDS(sck);
    %{
    move(0.5,sck);
    re = readLDS(sck);
    move(0.5,sck);
    re = readLDS(sck);
    move(0.5,sck);
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