%------------------------------------------------------------------
% Quad4IsoPMembStiffness
% encoor = Element node coordinates arranged in two-dimensional list form:
% { { x1,y1 },{ x2,y2 },{ x3,y3 },{ x4,y4 } }.
% h = The plate thickness.
% pG = pG specifies the Gauss product rule to have pG points in each direction. pG may be
% 1 through 4. For rank sufficiency, p must be 2 or higher. If pG is 1 the element will
% be rank deficient by two. By default pG = 2.
% E = young modulus  
% v = poisson
% It returns Ke as an 8 × 8 symmetric matrix
function matrix = Quad4IsoPMembStiffness(encoor,E, v,  h, pG )
    % Emat = A two-dimensional list that stores the 3 × 3 plane stress matrix of elastic moduli
    % arranged as { { E11,E12,E33 },{ E12,E22,E23 },{ E13,E23,E33 } }. Must be symmetric.
    Emat = E/(1-v^2)*[1,v,0;v,1,0;0,0,(1-v)/2];
    Ke = zeros(8,8);
    if pG < 1 || pG > 4
        disp('pG out of range');
        return
    end
    for k=1:pG*pG
        %qcoor is the ei and nj natural coordinates = [ei, nj]
        info = QuadGaussRuleInfo(pG, k);
        qcoor = [ info(1), info(2) ];
        % w12 is wi*wj.
        w12 = cell2mat ( info(3) );
        info = Quad4IsoPShapeFunDer ( encoor, qcoor );
        % Nf Value of shape functions, arranged as list [ Nf1,Nf2,Nf3,Nf4 ].
        % Nfx Value of x-derivatives of shape functions, arranged as list { Nfx1,Nfx2,Nfx3,Nfx4 }.
        % Nfy Value of y-derivatives of shape functions, arranged as list { Nfy1,Nfy2,Nfy3,Nfy4 }.
        % Jdet Jacobian determinant.
        %Nf = info(1);
        dNx = cell2mat ( info(2) );
        dNy = cell2mat ( info(3) );
        Jdet = cell2mat ( info(4) );
        c=w12*Jdet*h;
        % Be is the strain-displacement matrix.
        Be = zeros(3,2*4);
        for i=1:4
            Be(1, 2*i-1) =  dNx(i);
            Be(1, 2*i) = 0;
            Be(2, 2*i-1) = 0;
            Be(2, 2*i) = dNy(i);
            Be(3,  2*i-1 )  =  dNy(i);
            Be(3,  2*i )  =  dNx(i);
        end
        Ke = Ke + c*Be'*Emat*Be;
    end
    matrix = Ke;
end