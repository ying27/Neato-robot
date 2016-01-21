m = mapClass();
sk = m.getSkel();


[row,col] = find(sk);

g = PGraph([]);
dict = containers.Map;

initx = 124;
inity =  52;
finalx = 190;
finaly = 1221;

for i = 1 : size(row)
   x = row(i);
   y = col(i);
   nid = g.add_node([x,y]);
   dict(strcat(int2str(x),int2str(y))) = nid; 
   %up
   up = strcat(int2str(x-1),int2str(y));
   if dict.isKey(up)
       ant = dict(up);
       g.add_edge(nid, ant);
   end
   %diagonals
   dil = strcat(int2str(x-1),int2str(y-1));
   if dict.isKey(dil)
       ant = dict(dil);
       g.add_edge(nid, ant);
   end
   
   dir = strcat(int2str(x+1),int2str(y-1));
   if dict.isKey(dir)
       ant = dict(dir);
       g.add_edge(nid, ant);
   end
   
   %left
   left = strcat(int2str(x),int2str(y-1));
   if dict.isKey(left)
       ant = dict(left);
       g.add_edge(nid, ant);
   end
end


init = [initx,inity];
final = [finalx,finaly];

ninit = g.closest(init)
nfinal = g.closest(final)

q = g.Astar(1,2058);
ret = g.coord(q(:))';

