function neato()

%######## Global vars ######
hist = {}; % Will record all the robot data

%########## NEEDED CODE - DON'T TOUCH ######################
% UI Neato connection info
prompt = {'Connection information',};
dlg_title = 'Connection';
num_lines = 1;
def = {'172.16.10.5:20000',};  % Robot A
%def = {'172.16.10.5:20001',};  % Robot B
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
        
        main(sck);
        
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