function [ret] = readLDS(sck)
    msg = ['GetLDSScan'];
    data = sck.sendMsg(sck,msg);
    C = regexp(char(data), '[;]', 'split');
    C = C(3:362);
    j = 1;
    for index = 1:360
       aux = regexp(char(C(index)), '[,]', 'split');
       if str2double(char(aux(2))) ~= 0
           ret(j,:) = [index,str2double(char(aux(2))),str2double(char(aux(3)))];
           j = j + 1;
       end
    end
end