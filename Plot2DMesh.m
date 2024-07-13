%------------------------------------------------------------------
% Plot2DElementsAndNodes plots all elements and nodes, including the
% supports and the forces.
% It receives the following parameters:
% nodecoordinates: all node coordinates
% elemNodes: the nodes of each element
function Plot2DMesh(nodecoordinates, elemNodes, elemat, nodetag, forcevalues)
    %axis auto
    %axis equal
    cla;
    nel = length(elemNodes) ;                  % number of elements
    nnode = length(nodecoordinates) ;          % total number of nodes in system
    
    %counting the number of bars, tri and quad
    nbars = 0;
    ntris = 0;
    nquads = 0;
    for i=1:nel
       if strcmp( elemat{1,i}(1), 'bar')
           nbars = nbars+1;
       elseif strcmp( elemat{1,i}(1), 'tri')
           ntris = ntris+1;
       elseif strcmp( elemat{1,i}(1), 'quad')
           nquads = nquads+1;
       end
    end
    
    %plotting triangles
    if ntris>0
        X(3, ntris) = 0;
        Y(3, ntris) = 0;
        for iel = 1:nel
            if strcmp( elemat{1,iel}(1), 'tri')
                nnel = 3;
                for i = 1:nnel
                    node = elemNodes{1,iel}(i);
                    X(i, iel) = nodecoordinates{1,node}(1);
                    Y(i, iel) = nodecoordinates{1,node}(2);
                end
            end

        end
        plot(X,Y, 'k');
        fill(X,Y,[0.6 0.6 0.6 ]);
        clear X Y node
    end
    
    
    %plotting quads
    if nquads>0
        X(4, nquads) = 0;
        Y(4, nquads) = 0;
        for iel = 1:nel
            if strcmp( elemat{1,iel}(1), 'quad')
                nnel = 4;
                for i = 1:nnel
                    node(i) = elemNodes{1,iel}(i);
                    X(i, iel) = nodecoordinates{1,node(i)}(1);
                    Y(i, iel) = nodecoordinates{1,node(i)}(2);
                end
            end

        end
        plot(X,Y, 'k');
        fill(X,Y,[0.6 0.6 0.6 ]);
        clear X Y node
    end
    
    %plotting bars
    if nbars>0
        X(2, nbars) = 0;
        Y(2, nbars) = 0;
        for iel = 1:nel
            if strcmp( elemat{1,iel}(1), 'bar')
                nnel = 2;
                for i = 1:nnel
                    node = elemNodes{1,iel}(i);
                    X(i, iel) = nodecoordinates{1,node}(1);
                    Y(i, iel) = nodecoordinates{1,node}(2);
                end
            end

        end
        plot(X,Y,'k', 'LineWidth',3)
        clear X Y;
    end
    
    %plotting texts, circles, supports and forces
    for i = 1:nnode
        x = nodecoordinates{1,i}(1);
        y = nodecoordinates{1,i}(2);
        circle( x,y, 0.1, 'k');
        text( x+0.3,y, int2str(i),'fontsize',12,'color','k');
        if nodetag(i,1) == 1
            triangle(x,y,0.5,0.5,pi,[ 0 0 1]);
        end
        if nodetag(i,2) == 1
            triangle(x,y,0.5,0.5,-pi/2,[ 0 0 1]);
        end
        if forcevalues(i,1) ~= 0
            arrow2D(x,y,1,0.3,0.3,pi,[1 0 0])
            text( x-1.8,y, num2str(abs(forcevalues(i,1))),'fontsize',12,'color','r');
        end
        if forcevalues(i,2) ~= 0
            arrow2D(x,y,1,0.3,0.3,pi/2,[1 0 0])
            text( x,y+0.7, num2str(abs(forcevalues(i,2))),'fontsize',12,'color','r');
        end         
    end        
end


%% Class (static) auxiliary functions
        %------------------------------------------------------------------
        % Plots a square with defined center coordinates, side length and
        % color.
        % This method is used to draw nodal points and rotation constraints
        % on 2D models.
        % Input arguments:
        %  x: center coordinate on the X axis
        %  y: center coordinate on the Y axis
        %  l: side length
        %  c: color (RGB vector)
        function square(x,y,l,c)
            X = [x - l/2, x + l/2, x + l/2, x - l/2];
            Y = [y - l/2, y - l/2, y + l/2, y + l/2];
            fill(X, Y, c);
        end
        
        %------------------------------------------------------------------
        % Plots a triangle with defined top coordinates, height, base,
        % orientation, and color.
        % This method is used to draw translation constraints on 2D models.
        % Input arguments:
        %  x: top coordinate on the X axis
        %  y: top coordinate on the Y axis
        %  h: triangle height
        %  b: triangle base
        %  ang: angle (in radian) between the axis of symmetry and the
        %       horizontal direction (counterclockwise) - 0 rad when
        %       triangle is pointing left
        %  c: color (RGB vector)
        function triangle(x,y,h,b,ang,c)
            cx = cos(ang);
            cy = sin(ang);
            X = [x, x + h * cx + b/2 * cy, x + h * cx - b/2 * cy];
            Y = [y, y + h * cy - b/2 * cx, y + h * cy + b/2 * cx];
            fill(X, Y, c);
        end
        
        %------------------------------------------------------------------
        % Plots a circle with defined center coordinates, radius and color.
        % This method is used to draw hinges on 2D models.
        % Input arguments:
        %  x: center coordinate on the X axis
        %  y: center coordinate on the Y axis
        %  r: circle radius
        %  c: color (RGB vector)
        function circle(x,y,r,c)
            circ = 0 : pi/50 : 2*pi;
            xcirc = x + r * cos(circ);
            ycirc = y + r * sin(circ);
            plot(xcirc, ycirc, 'color', c);
            fill(xcirc, ycirc, [0.9 0.9 0.9]);
        end
        
        %------------------------------------------------------------------
        % Plots an arrow with defined beggining coordinates, length,
        % arrowhead height, arrowhead base, orientation, and color.
        % This method is used to draw load symbols on 2D models.
        % Input arguments:
        %  x: beggining coordinate on the X axis
        %  y: beggining coordinate on the Y axis
        %  l: arrow length
        %  h: arrowhead height
        %  b: arrowhead base
        %  ang: pointing direction (angle in radian with the horizontal
        %       direction - counterclockwise) - 0 rad when pointing left
        %  c: color (RGB vector)
        function arrow2D(x,y,l,h,b,ang,c)
            cx = cos(ang);
            cy = sin(ang);
            X = [x, x + l * cx];
            Y = [y, y + l * cy];
            line(X, Y, 'Color', c,'LineWidth',2 );
            triangle(x, y, h, b, ang, c);
        end
