classdef directedMap<handle
    properties
        %object mapClass
        map;
        %Cells of the directedMap
        m;
        %(x,y) is the starting point of the directed Map
        x;
        y;
        %(xx,yy) is nearest point in the path to the starting point
        xx;
        yy;
    end
    
    methods
        
        function obj = directedMap(map,x,y)
            import java.util.LinkedList
            obj@handle();
            obj.map = map;
            obj.x = x;
            obj.y = y;
            [aa,bb] = obj.getNearestInPath(x,y);
            obj.xx = aa;
            obj.yy = bb;
            
            skel = map.getSkel();
            
            [a b] = size(skel);
            
            m = cell(a,b);
            q = LinkedList();
            q.add([aa,bb]);
            while q.size() ~= 0
                ret = q.remove();
                [skel, childs] = obj.getnexts(ret(1),ret(2),skel);
                m(ret(1),ret(2)) = {childs};
                for f = 1 : size(childs)
                    q.add(childs(f,:));
                end
            end
            obj.m = m;
        end
        
        function [imgc,a] = getnexts(~,x,y,imgc)
            imgc(x,y) = 0;
            a = [];
            q = 1;
            
            for i=x-1:x+1
                for j=y-1:y+1
                    if imgc(i,j) == 1
                        a(q,:) = [i,j];
                        q = q + 1;
                    end
                end
            end
            
        end
        
        function [pathx,pathy] = getNearestInPath(obj,x,y)
            mapa = obj.map;
            list = mapa.getSkelList();
            mi = obj.distp(x,y,list(1,1),list(1,2));
            pathx = list(1,1);
            pathy = list(1,2);
            
            for i = 2 : size(list)
                q = obj.distp(x,y,list(i,1),list(i,2));
                if q < mi
                    mi = q;
                    pathx = list(i,1);
                    pathy = list(i,2);
                end
            end
        end
        
        function mi = getNearest(obj,x,y,xx,yy)
            %Used in the getPath in order to pick the shortest way when
            %there are multiple branchs in the voronoi
            
            %(x,y) = final point
            %(xx,yy) = starting point
            
            import java.util.LinkedList
            
            mi = obj.distp(x,y,xx,yy);
            q = LinkedList();
            
            w = cell2mat(obj.m(xx,yy));
            for i = 1 : size(w)
                q.add(w(i,:));
            end
            
            while mi > 0 && q.size() ~= 0
                aux = q.remove();
                w = cell2mat(obj.m(aux(1),aux(2)));
                for i = 1 : size(w)
                    q.add(w(i,:));
                end
                mi = min(mi,obj.distp(x,y,aux(1),aux(2)));
            end
        end
        
        function ret = distp(~,x,y,xx,yy)
            ret = sqrt((xx-x)^2+(yy-y)^2);
        end
        
        function p = getPath(obj,c,d)
            p = [];
            %get nearest end point (contained in the path)to the real
            %endpoint
            
            [x,y] = obj.getNearestInPath(c,d);
            
            if obj.xx ~= obj.x || obj.yy ~= obj.y
                p(end+1,:) = [obj.x,obj.y];
            end
            
            p(end+1,:) = [obj.xx,obj.yy];
            
            q = cell2mat(obj.m(obj.xx,obj.yy));
            while size(q) > 0
                aux = q(1,:);
                if size(q) > 1
                    mi = obj.getNearest(x,y,aux(1),aux(2));
                    for i = 2 : size(q)
                        if obj.getNearest(x,y,q(i,1),q(i,2)) < mi
                            aux = q(i,:);
                        end
                    end
                end
                p(end+1,:) = aux;
                if aux(1) == x && aux(2) == y
                    q = [];
                else
                    q = cell2mat(obj.m(aux(1),aux(2)));
                end
            end
            
            if p(end,1) ~= c || p(end,2) ~= d
                p(end+1,:) = [c,d];
            end
        end
        
        function kp = getKPath(obj,c,d,k)
            pa = obj.getPath(c,d);
            kp = [pa(1,:)];
            for i = 2 : (size(pa)-1)
                if mod(i,k) == 0
                    kp(end+1,:) = pa(i,:);
                end
            end
            kp(end+1,:) = pa(end,:);
        end
        
        function qp = getQueuePath(obj,c,d)
            import java.util.LinkedList
            pa = obj.getPath(c,d);
            obj.map.showPathInMap(pa);
            qp = LinkedList();
            for i = 1 : size(pa)
                qp.add(pa(i,:));
            end
        end
        
        function qp = getKQueuePath(obj,c,d,k)
            import java.util.LinkedList
            pa = obj.getPath(c,d);
            obj.map.showPathInMap(pa);
            qp = LinkedList();
            for i = 1 : size(pa)
                if mod(i,k) == 0
                    qp.add(pa(i,:));
                end
            end
        end
        
        function ret = getOptimalPath(obj,c,d)
            path = getKPath(obj,c,d,10);
            ret = [path(1,:)];
            
            alpha = abs(atan((path(2,2)-path(1,2))/(path(2,1)-path(1,1))));
            
            for i = 2:(size(path)-2)
                aux = abs(atan((path(i,2)-ret(end,2))/(path(i,1)-ret(end,1))));
                if (aux > alpha*1.02 || aux < alpha*0.98) %&& (abs(alpha - aux) >= 0.2662)
                    ret(end+1,:) = path(i,:);
                    alpha = abs(atan((path(i+1,2)-ret(end,2))/(path(i+1,1)-ret(end,1))));
                end
            end
            ret(end+1,:) = path(end-1,:);
            ret(end+1,:) = path(end,:);
        end
        
        function qp = getOptimalQueuePath(obj,c,d)
            import java.util.LinkedList
            pa = obj.getOptimalPath(c,d);
            figure;
            obj.map.showPathInMap(pa);
            qp = LinkedList();
            for i = 1 : size(pa)
                qp.add(pa(i,:));
            end
        end
        
        function showPath(obj,c,d)
            pa = obj.getPath(c,d);
            obj.map.showPathInMap(pa);
        end
        
    end
end