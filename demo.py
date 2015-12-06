import socket
import sys
import time

# Global vars
rbuffer = ""

###### FUNCTIONS #######
def sendMsg(msg):
	global sock
	sock.sendall(msg + chr(10))
	return getMsg()


def getMsg():
	global sock
	global rbuffer
	resp = ''
	
	while not resp: # While resp empty
		rbuffer = sock.recv(8192)
		if chr(10) in rbuffer:
			resp,rbuffer = rbuffer.split(chr(10),1)
	return resp
	
def close():
	sock.sendall('Close' + chr(10))
	sock.close()


###### MAIN #######
if __name__ == '__main__':
	########## NEEDED CODE - DON'T TOUCH ######################
	
	global sock
	
	# Create a TCP/IP socket
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	
	# Connect the socket to the port where the server is listening
	server_address = ('localhost', 20000)
	print 'connecting to %s port %s' % server_address
	sock.connect(server_address)
	
	#Handshaking - Get Serial OK
	data = getMsg()
	if 'OK' in data:
		print 'Serial port (Raspberry-Neato) OK'
	else:
		sock.close()
		print 'Serial port (Raspberry-Neato) not found, please check cable connection and Neato power on, and restart Raspberry'
		sys.exit()
	
	#Handshaking - Send data mode
	print sendMsg('DataMode listener')
	
	#Wait lidar start
	print 'Wait lidar start'
	time.sleep(3) #Wait 3 seconds
	
	########## END NEEDED CODE ######################
	
	print sendMsg('GetMotors LeftWheel RightWheel')
	print sendMsg('GetLDSScan')
	
	#SetMotor distance in [mm], speed in [mm/s]
	#Direct movement
	dist = 1000; #[mm]
	speed = 120; #[mm/s]
	print sendMsg('SetMotor LWheelDist '+ str(dist) +' RWheelDist '+ str(dist) + ' Speed '+ str(speed))
	
	#Wait until movement stops
	time.sleep(dist/speed)
	
	print sendMsg('GetMotors LeftWheel RightWheel')
	print sendMsg('GetLDSScan')
	
	close()
