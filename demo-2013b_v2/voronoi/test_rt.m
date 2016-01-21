initx = 124;
inity =  52;
finalx = 190;
finaly = 1221;

m = mapClass();
dm = directedMap(m,initx,inity);
path = dm.getOptimalQueuePath(finalx,finaly);
scatter(inity,initx,'o','b.')

while path.size() > 0
    aux = path.remove()
    scatter(aux(2),aux(1),'o','b.')
    pause(1);    
end