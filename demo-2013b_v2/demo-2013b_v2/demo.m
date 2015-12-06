function demo()

%######## Global vars ######
hist = {}; % Will record all the robot data

%########## NEEDED CODE - DON'T TOUCH ######################
% UI Neato connection info
prompt = {'Connection information',};
dlg_title = 'Connection';
num_lines = 1;
%def = {'172.16.10.5:20000',};  % Robot A
def = {'172.16.10.5:20001',};  % Robot B
%def = {'172.16.10.5:20002',};  % Robot C


conn = inputdlg(prompt,dlg_title,num_lines,def);
conexion = strsplit(conn{1},':');

% Neato Connection
sck = socket(conexion{1},str2double(conexion{2}));

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
        
        
        msg = ['JoystickMode off']; % altres modes constant  moody
        data = sck.sendMsg(sck,msg);
        display(data);
        
        % Wait lidar start
        wait_lidar();
        
        %########## END NEEDED CODE ######################
        
        %#################################################
        %### Demo robot movement and data acquisition ###
        
        %Read robot data & log it into "hist"
        msg = ['GetMotors LeftWheel RightWheel'];
        data = sck.sendMsg(sck,msg);
        display(data);
        hist{1,1} = char(data);
        msg = ['GetLDSScan'];
        data = sck.sendMsg(sck,msg);
        display(data);
        hist{1,2} = char(data);
        
        % SetMotor distance in [mm], speed in [mm/s]
        % Direct movement
        dist = 500; %[mm]
        speed = 120; %[mm/s]
        msg = ['SetMotor LWheelDist ', num2str(dist) ,' RWheelDist ', num2str(dist) , ' Speed ', num2str(speed)];
        datam = sck.sendMsg(sck,msg);
        display(datam);
        
        %Wait until movement stops
        pause(dist/speed);
        
        %Read robot data & log it into "hist"
        msg = ['GetMotors LeftWheel RightWheel'];
        data = sck.sendMsg(sck,msg);
        display(data);
        hist{1,3} = char(data);
        msg = ['GetLDSScan'];
        data = sck.sendMsg(sck,msg);
        display(data);
        hist{1,4} = char(data);
        
        % 90º rigth turn
        dist = 190;
        speed = 120;
        msg = ['SetMotor LWheelDist ', num2str(dist) ,' RWheelDist ', num2str(-dist) , ' Speed ', num2str(speed)];
        datam = sck.sendMsg(sck,msg);
        display(datam);
        
        % Wait until movement stops
        pause(dist/speed);
        
        %Read robot data & log it into "hist"
        msg = ['GetMotors LeftWheel RightWheel'];
        data = sck.sendMsg(sck,msg);
        display(data);
        hist{1,5} = char(data);
        msg = ['GetLDSScan'];
        data = sck.sendMsg(sck,msg);
        display(data);
        hist{1,6} = char(data);
        
        % Direct movement
        dist = 500; %[mm]
        speed = 120; %[mm/s]
        msg = ['SetMotor LWheelDist ', num2str(dist) ,' RWheelDist ', num2str(dist) , ' Speed ', num2str(speed)];
        datam = sck.sendMsg(sck,msg);
        display(datam);
        
        %Wait until movement stops
        pause(dist/speed);
        
        %Read robot data & log it into "hist"
        msg = ['GetMotors LeftWheel RightWheel'];
        data = sck.sendMsg(sck,msg);
        display(data);
        hist{1,7} = char(data);
        msg = ['GetLDSScan'];
        data = sck.sendMsg(sck,msg);
        display(data);
        hist{1,8} = char(data);
        
        msg = ['SetLDSRotation off'];
        data = sck.sendMsg(sck,msg);
        
        % Save data into workspace
        assignin('base', 'hist', hist);
        
        % Close connection
        sck.close(sck);
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

end