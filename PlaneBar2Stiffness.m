%------------------------------------------------------------------
% PlaneBar2Stiffness = matrix = Ke
% Plane Bernoulli Euler Bar in the 2D space.
% nodeCoord = { {x1,y1} , {x2,y2} } 
% f = Ke * u
function matrix = PlaneBar2Stiffness(nodeCoord,E,A)
    x1 = nodeCoord{1,1}(1);
    y1 = nodeCoord{1,1}(2);
    x2 = nodeCoord{1,2}(1);
    y2 = nodeCoord{1,2}(2);
    x21 = x2-x1;
    y21 = y2-y1;
    L = sqrt(x21^2+y21^2);
    ke = E*A/(L^3)*[ x21*x21, x21*y21,-x21*x21,-x21*y21; ...
        y21*x21, y21*y21,-y21*x21,-y21*y21;...
        -x21*x21,-x21*y21, x21*x21, x21*y21;...
        -y21*x21,-y21*y21, y21*x21, y21*y21;];
    matrix = ke;
end