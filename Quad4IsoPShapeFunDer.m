%------------------------------------------------------------------
% Quad4IsoPShapeFunDer returns Nf,dNx,dNy,Jdet
% It is used for Iso-P Quad4 (Bilinear Quadrilateral).
% Nf Value of shape functions, arranged as list [ Nf1,Nf2,Nf3,Nf4 ].
% dNx Value of x-derivatives of shape functions, arranged as list { Nfx1,Nfx2,Nfx3,Nfx4 }.
% dNy Value of y-derivatives of shape functions, arranged as list { Nfy1,Nfy2,Nfy3,Nfy4 }.
% Jdet Jacobian determinant.
% encoor = Element node coordinates arranged in two-dimensional list form: { { x1,y1 },{ x2,y2 },{ x3,y3 },{ x4,y4 } }.
% qcoor Quadrilateral coordinates [ e, n ] of the point.
% This function returns { Nf, dNx, dNy, Jdet }.
function matrix = Quad4IsoPShapeFunDer(encoor,qcoor)
    %coordinates {e,n}
    e = cell2mat ( qcoor(1) );
    n = cell2mat ( qcoor(2) );
    x1 = encoor{1,1}(1);
    y1 = encoor{1,1}(2);
    x2 = encoor{1,2}(1);
    y2 = encoor{1,2}(2);
    x3 = encoor{1,3}(1);
    y3 = encoor{1,3}(2); 
    x4 = encoor{1,4}(1);
    y4 = encoor{1,4}(2);
    Nf = [ (1-e)*(1-n),(1+e)*(1-n),(1+e)*(1+n),(1-e)*(1+n)]/4;
    %derivavtice of Nf in relation to e, considerating n constant
    dNe = [-(1-n); (1-n);(1+n);-(1+n) ]/4;
    %derivavtice of Nf in relation to n, considerating e constant
    dNn= [ -(1-e); -(1+e) ; (1+e) ; (1-e) ]/4;
    x=[x1,x2,x3,x4];
    y=[y1,y2,y3,y4];
    J11 = x*dNe;
    J12 = y*dNe;
    J21 = x*dNn;
    J22 = y*dNn;
    Jdet = (J11*J22-J12*J21);
    dNx= ( J22*dNe-J12*dNn)/Jdet; 
    dNy= (-J21*dNe+J11*dNn)/Jdet; 
    matrix{1,4} = 0;
    matrix{1,1} = Nf;
    matrix{1,2} = dNx;
    matrix{1,3} = dNy;
    matrix{1,4} = Jdet;
end