%------------------------------------------------------------------
% Plot2DMesh2 plots all elements and nodes for the Problem2, including the
% supports and the forces.
% It receives the following parameters:
% nodecoordinates: all node coordinates
% elemNodes: the nodes of each element
% P is the total force
% scale of the axis
function Plot2DMesh2(nodecoordinates, elemNodes, elemat, nodetag, forcevalues,P, Lx, Ly)

    nel = length(elemNodes) ;                  % number of elements
    nnode = length(nodecoordinates) ;          % total number of nodes in system 
    
    scale = min(Lx, Ly);
    
    if abs(scale) < 0.5
        axis([ -0.15 Lx+0.15 -0.15 Ly+0.15 ]);
        sizeTriangle = 0.01;
        fontSize = 6;
        arrowSize = 0.02;
        arrowSizeBase1 = 0.005;
        arrowSizeBase2 = 0.015;
        textOffset = 0.01;
        textOffset2 = 0.05;
    else
        sizeTriangle = 0.1;
        fontSize = 6;
        arrowSize = 0.1;
        arrowSizeBase1 = 0.03;
        arrowSizeBase2 = 0.07;
        textOffset = 0.05;
        textOffset2 = 0.2;
    end
    
    
    %plotting texts, circles, supports and forces
    for i = 1:nnode
        x = nodecoordinates{1,i}(1);
        y = nodecoordinates{1,i}(2);
        %circle( x,y, 0.1, 'k');
        text( x+textOffset,y, int2str(i),'fontsize',fontSize,'color','k');
        if nodetag(i,1) == 1
            triangle(x,y,sizeTriangle,sizeTriangle,pi,[ 0 0 1]);
        end
        if nodetag(i,2) == 1
            triangle(x,y,sizeTriangle,sizeTriangle,-pi/2,[ 0 0 1]);
        end
        if forcevalues(i,1) ~= 0
            arrow2D(x,y,arrowSize,arrowSizeBase1,arrowSizeBase1,pi,[1 0 0]);
            %text( x-1.8,y, num2str(forcevalues(i,1)),'fontsize',12,'color','r');
        end
        if forcevalues(i,2) ~= 0
            arrow2D(x,y,arrowSize,arrowSizeBase2,arrowSizeBase2,pi/2,[1 0 0]);
            Lx = x;
            %text( x,y+0.7, num2str(forcevalues(i,2)),'fontsize',12,'color','r');
        end         
    end
    Ly = y;
    text( Lx+textOffset2,Ly/2, num2str(P),'fontsize',fontSize+2,'color','r');
    
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
