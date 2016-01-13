classdef socket
	properties
		skt
        input
        output
	end
	methods(Static)
		%Contructora (conecta directamente con el servidor)
		function obj = socket(ip,port)
			if nargin > 0
                try
                    obj.skt = java.net.Socket(ip,port);
                    obj.input = java.io.BufferedReader(java.io.InputStreamReader(obj.skt.getInputStream()),12288);
                    obj.output = java.io.PrintWriter(obj.skt.getOutputStream());                    
                catch e
                    display('Connection not established, check correct ip:port, and server on');
                    obj.skt = 'null';                    
                    %e.message
                    %if(isa(e, 'matlab.exception.JavaException'))
                    %    ex = e.ExceptionObject;
                    %    assert(isJava(ex));
                    %    ex.printStackTrace;
                    %end
                end
			end
        end
                
        %Sends message and waits for response
		function txt = sendMsg(obj,msg)
			obj.output.println(msg);
            obj.output.flush();
            txt = obj.input.readLine();
        end
        
        %Waits for a message
		function txt = getMsg(obj)
            txt = obj.input.readLine();
        end
                        
		%Closes the current socket connection letting the server get more
		%connections
		function close(obj)
            %obj.output.println('Stop'); % Do not use, only for stopping the socket server service
            obj.output.println('Close');
            obj.output.flush();
		end
    end
    methods        
        function sckt = get.skt(obj)
         sckt = obj.skt;
        end              
    end
end