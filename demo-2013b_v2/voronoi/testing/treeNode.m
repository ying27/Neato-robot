classdef treeNode<handle
    properties
        x;
        y;
        childs;
    end
    
    methods
        
        function obj = treeNode(x,y,skel)
            obj@handle();
            obj.x = x;
            obj.y = y;
            obj.childs = [];
            
            [q,w] = obj.getnexts(skel);
            for i = 1 : size(w)
               childs(end+1) = treeNode(w(i,1),w(i,2),q);
            end
            
        end
        
        function [imgc,a] = getnexts(obj,imgc)
            imgc(obj.x,obj.y) = 0;
            a = [];
            q = 1;
                        
            for i=obj.x-1:obj.x+1
                for j=obj.y-1:obj.y+1
                    if imgc(i,j) == 1
                        a(q,:) = [i,j];
                        q = q + 1;
                    end
                end
            end
            
        end
    end
end