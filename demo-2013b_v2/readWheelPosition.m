function [l,r] = readWheelPosition(sck)
    msg = ['GetMotors LeftWheel RightWheel'];
    data = sck.sendMsg(sck,msg);
    C = regexp(char(data), '[;,]', 'split');
    l = C(9);
    r = C(17);
end