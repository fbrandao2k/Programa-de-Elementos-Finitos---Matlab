%------------------------------------------------------------------
% Quad4IsoPMembraneStresses calculates the stresses for the quad4 elements
% nodecoordinates: all node coordinates
% E young modulus matrix
% udisp: displacements of all the element nodes
% It returns sige:
% matrix with the element stress

function sige = Quad4IsoPMembraneStresses(nodecoordinates,Emat,udisp)
    sige{1,4} = {};
    %calculating in the gauss points
    naturalCoordinates = { {-1/sqrt(3),-1/sqrt(3)}, {1/sqrt(3),-1/sqrt(3)} , {1/sqrt(3),1/sqrt(3)} , {-1/sqrt(3),1/sqrt(3)} };
    for k = 1:4
        qcoor =  naturalCoordinates{1,k};
        matrix=Quad4IsoPShapeFunDer(nodecoordinates,qcoor);
        dNx = matrix{1,2};
        dNy = matrix{1,3};
        Be = [ dNx(1),  0,   dNx(2),     0,     dNx(3),     0,      dNx(4),     0;...
                0,   dNy(1),    0,    dNy(2),       0,  dNy(3),         0, dNy(4);...
                dNy(1), dNx(1), dNy(2), dNx(2), dNy(3), dNx(3), dNy(4), dNx(4);];
        sige{1,k} = Emat*Be*udisp;
    end
    
    
    %extrapolating to the corner points
    %sigmaxx
    gaussValues = [ sige{1,1}(1); sige{1,2}(1); sige{1,3}(1); sige{1,4}(1) ];
    extrapolation_matrix = [ 1+1/2*sqrt(3), -1/2, 1-1/2*sqrt(3), -1/2;
                             -1/2, 1+1/2*sqrt(3), -1/2, 1-1/2*sqrt(3);
                              1-1/2*sqrt(3), -1/2, 1+1/2*sqrt(3), -1/2;
                              -1/2, 1-1/2*sqrt(3), -1/2, 1+1/2*sqrt(3);];
    cornerValues = extrapolation_matrix*gaussValues;
    sige{1,1}(1) = cornerValues(1);
    sige{1,2}(1) =cornerValues(2);
    sige{1,3}(1) = cornerValues(3);
    sige{1,4}(1) = cornerValues(4);
    
     %sigmayy
    gaussValues = [ sige{1,1}(2); sige{1,2}(2); sige{1,3}(2); sige{1,4}(2) ];
    extrapolation_matrix = [ 1+1/2*sqrt(3), -1/2, 1-1/2*sqrt(3), -1/2;
                             -1/2, 1+1/2*sqrt(3), -1/2, 1-1/2*sqrt(3);
                              1-1/2*sqrt(3), -1/2, 1+1/2*sqrt(3), -1/2;
                              -1/2, 1-1/2*sqrt(3), -1/2, 1+1/2*sqrt(3);];
    cornerValues = extrapolation_matrix*gaussValues;
    sige{1,1}(2) = cornerValues(1);
    sige{1,2}(2) =cornerValues(2);
    sige{1,3}(2) = cornerValues(3);
    sige{1,4}(2) = cornerValues(4);
    
     %sigmaxy
    gaussValues = [ sige{1,1}(3); sige{1,2}(3); sige{1,3}(3); sige{1,4}(3) ];
    extrapolation_matrix = [ 1+1/2*sqrt(3), -1/2, 1-1/2*sqrt(3), -1/2;
                             -1/2, 1+1/2*sqrt(3), -1/2, 1-1/2*sqrt(3);
                              1-1/2*sqrt(3), -1/2, 1+1/2*sqrt(3), -1/2;
                              -1/2, 1-1/2*sqrt(3), -1/2, 1+1/2*sqrt(3);];
    cornerValues = extrapolation_matrix*gaussValues;
    sige{1,1}(3) = cornerValues(1);
    sige{1,2}(3) =cornerValues(2);
    sige{1,3}(3) = cornerValues(3);
    sige{1,4}(3) = cornerValues(4);
    
end
    