classdef directedMap<handle
    properties
        %object mapClass
        map;
        %graph
        g;
        %(x,y) is the starting point of the directed Map
        x;
        y;
        %ninit is the nearest starting node from the voronoid graph
        ninit;
        %last calculated path
        %path;
    end
    
    methods
        
        function obj = directedMap(map,x,y)
            obj@handle();
            obj.map = map;
            obj.x = x;
            obj.y = y;
                        
            sk = map.getSkel();

            [row,col] = find(sk);

            g = PGraph([]);
            dict = containers.Map;

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

            n = g.closest([obj.x,obj.y]);
            obj.ninit = n;
            obj.g = g;
            %obj.path = [];
        end
        
        function ret = distp(~,x,y,xx,yy)
            ret = sqrt((xx-x)^2+(yy-y)^2);
        end        
                
        function p = getPath(obj,c,d)
            nfinal = obj.g.closest([c,d]);
            q = obj.g.Astar(obj.ninit,nfinal);
            p = obj.g.coord(q(:))';
            p(end+1,:) = [c,d];
            %obj.path = p;
            hold off
            obj.map.showPathInMap(p);
            hold on
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
            %obj.map.showPathInMap(pa);
            qp = LinkedList();
            for i = 1 : size(pa)
                if mod(i,k) == 0
                    qp.add(pa(i,:));
                end
            end
        end
        
        function ret = getOptimalPath(obj,c,d)
            path = getPath(obj,c,d);
            
            ret = DouglasPeucker(path,0.75,false)
            for i = 1 : size(ret);
               scatter(ret(i,2),ret(i,1),'+','g.') 
            end
            %{
            ret = [path(1,:)];
                        
                      
            for i = 2:(size(path)-1)
                dist = obj.distp(path(i-1,1),path(i-1,2),path(i+1,1),path(i+1,2))
                if dist == 2
                    ndist = obj.distp(path(i-1,1),path(i-1,2),path(i,1),path(i,2));
                    ndist = ndist + obj.distp(path(i,1),path(i,2),path(i+1,1),path(i+1,2));
                    if ndist ~= 2
                        ret(end+1,:) = path(i,:);
                    end
                elseif (dist < 2.82 || dist > 2.83) %&& (dist < 2.23 || dist > 2.24)
                    ret(end+1,:) = path(i,:);
                end
            end
            ret(end+1,:) = path(end,:);
            %}
        end
        
        function qp = getOptimalQueuePath(obj,c,d)
            import java.util.LinkedList
            pa = obj.getOptimalPath(c,d);
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