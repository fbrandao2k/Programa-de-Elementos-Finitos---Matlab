%------------------------------------------------------------------
% Trig3MembraneStiffness = matrix = Ke
% page 289 Felippa
% Implementation of Iso-P triangle of three nodes stiffness matrix calculation.
% nodeCoord = { {x1,y1} , {x2,y2}, {x3,y3} } 
% E is the matrix of elastic modulus
% f = Ke * u
function matrix = Trig3MembraneStiffness(nodeCoord,Emat, h)
    x1 = nodeCoord{1,1}(1);
    y1 = nodeCoord{1,1}(2);
    x2 = nodeCoord{1,2}(1);
    y2 = nodeCoord{1,2}(2);
    x3 = nodeCoord{1,3}(1);
    y3 = nodeCoord{1,3}(2);
    %calculation of Triangle's Area
    A= ( x2*y3-x3*y2+(x3*y1-x1*y3)+(x1*y2-x2*y1) )/2;
    x21 = x2-x1;
    x32 = x3-x2;
    x13 = x1-x3;
    y12 = y1-y2;
    y23 = y2-y3;
    y31 = y3-y1;
    %calculating the Be, in which epsilon(x,y) = Be*e
    Be= 1/(2*A)*[ y23,0,y31,0,y12,0;...
                  0,x32,0,x13,0,x21;...
                  x32,y23,x13,y31,x21,y12;];
    Ke = A*h*Be'*Emat*Be;
    matrix = Ke;
end