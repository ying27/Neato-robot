function neato()

    %######## Global vars ######
    hist = {}; % Will record all the robot data

    %########## NEEDED CODE - DON'T TOUCH ######################
    % UI Neato connection info
    prompt = {'Connection information',};
    dlg_title = 'Connection';
    num_lines = 1;
    %def = {'172.16.10.5:20000',};  % Robot A
    def = {'172.16.10.5:20005',};  % Robot F
    %def = {'172.16.10.5:20002',};  % Robot C


    conn = inputdlg(prompt,dlg_title,num_lines,def);
    conexion = strsplit(conn{1},':');

    % Neato Connection
    sck = socket(conexion{1},str2double(conexion{2}));
    try
        
        % If no connection, no code execution
        serialOK=1;
        if length(strfind(class(sck.skt()),'java.net.Socket')) == 1
            % Check if serial port is OK (required handshaking)
            data = sck.getMsg(sck);
            ok = strfind(data, 'OK');
            if length(ok) == 1
                display('Serial port (Raspberry-Neato) OK');
            else
                sck.close(sck);
                display('Serial port (Raspberry-Neato) not found, please check cable connection and Neato power on, and restart Raspberry');
                serialOK=0;
            end
            
            if serialOK   % Communication Raspery - NEATO is running      

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
                %{
                initx = 0;
                inity =  0;
                finalx = 190;
                finaly = 1221;
                
                msg = ['GetLDSScan'];
                data = sck.sendMsg(sck,msg)
                
                m = mapClass();
                rob = robotClass(sck,initx,inity,m);
                ldsscan = readLDS(sck)
                q = rob.getObjectsFromLDS(ldsscan);
                scatter(q(:,1),q(:,2)); 
                rob.detect(ldsscan)
                
                
                sck.close(sck);
                %}
                
                %initx = 124;
                initx = 124;
                inity =  52;
                
                %initx = 132;
                %inity =  22;
                finalx = 190;
                finaly = 1221;

                m = mapClass();
                rob = robotClass(sck,initx,inity,m);
                dm = directedMap(m,initx,inity);
                path = dm.getOptimalQueuePath(finalx,finaly);
                %path = dm.getKQueuePath(finalx,finaly,50);

                while path.size() > 0
                    aux = path.remove()
                    mv = rob.moveTo(aux(1),aux(2));
                    rob.getPosition()

                    if ~mv
                        dm = directedMap(rob.getMap(),rob.x,rob.y);
                        path = dm.getOptimalQueuePath(finalx,finaly);
                        %path = dm.getKQueuePath(finalx,finaly,50);
                    end


                end
                rob.getMap().showMap();
                sck.close(sck);

                % Close connection
                %sck.close(sck);
                
                
                %{
                initx = 124;
                inity =  52;
                m = mapClass();
                rob = robotClass(sck,initx,inity,m);
                q = rob.getObjects();
                scatter(q(:,1),q(:,2));
                sck.close(sck);
                %}
            end
        end
        
        
    catch exception
       sck.close(sck);
       display(exception);
    end
end

%######## End Code ##########

%######## Functions ##########
function wait_lidar()  % Wait 4 seconds for lidar wake up
    wt = waitbar(0,'Waiting Lidar Start...');
    for p=1:4
        pause(1);
        waitbar(p/4,wt,'Waiting Lidar Start......');
    end
    close(wt);
end
