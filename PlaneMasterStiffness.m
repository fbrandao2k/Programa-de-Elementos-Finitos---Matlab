%------------------------------------------------------------------
% PlaneMasterStiffness = matrix = Ke
% It returns the master stiffness of all the elements together
% nodcoor = Nodal coordinates arranged as a two-dimensional list:
%       { { x1,y1 },{ x2,y2 }, . . . { xn,yn } }, where n is the total number of nodes.
% elenod = Element nodes arranged as a two-dimensional list:
%       { { i1,j1 }, { i2,j2 }, . . . { ie,je } }, where e is the total number of elements.
% elemat = Element material properties arranged as a two-dimensional list:
%       {  { type1, A1, Em1,v1,h1 }, . . . { typee, Ae, Eme,ve,he } },
%       where e is the total number of elements, A is the area.
% pG is the number of gauss points
% String is the number of the problem. n=1 -> problem1, n=2 -> problem2, n=3 -> problem3 
% f = Ke * u
function matrix = PlaneMasterStiffness(nodcoor, elenod, elemat, pG,String)
    numele = length(elenod);
    numnod = length(nodcoor);
    % K is the global stiffness matrix
    K = zeros( 2*numnod, 2*numnod );
    %if problem 1
    if strcmp(String, 'Problem1') == 1
            % e is the number of the element from 1 to  e(last element)
            for e=1:numele
                area = cell2mat ( elemat{1,e}(2) ) ;
                E = cell2mat ( elemat{1,e}(3) ) ;
                v = cell2mat( elemat{1,e}(4) );
                h = cell2mat( elemat{1,e}(5) );
                type = elemat{1,e}(1);
                type = type{1,1};
                %if the element is a bar
                if strcmp( type, 'bar' )
                    %ni and ny are the start and end node respectively.
                    eNL = elenod(e);
                    ni = eNL{1,1}(1) ;
                    nj = eNL{1,1}(2) ;
                    % ncoor = coordinates of the nodes of the bar e
                    ncoor = { nodcoor{1,ni}, nodcoor{1,nj} };
                    Ke = PlaneBar2Stiffness( ncoor, E, area);
                    txt = sprintf('The stiffness matrix for the element %d is:',e);
                    fprintf(txt);
                    disp(Ke);
                    % nodes = list with the nodes [ni, nj, nk, nw]
                    nodes = [ ni, nj ];
                    % columns = list with the columns of the matrix K that need to
                    % be changed
                    columns = [ 2*ni-1, 2*ni, 2*nj-1, 2*nj ];
                    %degree of freedom of this element
                elseif strcmp( type, 'tri' )
                    %ni, nj and nk are the nodes.
                    eNL = elenod(e);
                    %disp(eNL)
                    %disp(elenod)
                    ni = eNL{1,1}(1);
                    nj = eNL{1,1}(2);
                    nk = eNL{1,1}(3);
                    % ncoor = coordinates of the nodes of the bar e
                    ncoor = { nodcoor{1,ni}, nodcoor{1,nj}, nodcoor{1,nk}  };
                    % If the plate material is isotropic with elastic modulus E and Poisson’s ratio v, the moduli in the
                    % constitutive matrix E reduce to E11 = E22 = E/(1 ? v^2), E33 = 1/2*E/(1 + ?) = G, E12 = v*E11
                    % and E13 = E23 = 0
                    Emat = [ E/(1-v^2), v*E/(1-v^2), 0;...
                             v*E/(1-v^2), E/(1-v^2), 0;...
                             0, 0, 1/2*E/(1 + v);];
                    Ke = Trig3MembraneStiffness( ncoor, Emat, h);
                    txt = sprintf('The stiffness matrix for the element %d is:',e);
                    fprintf(txt);
                    disp(Ke);
                    nodes = [ ni, nj, nk ];
                    columns = [ 2*ni-1, 2*ni, 2*nj-1, 2*nj, 2*nk-1, 2*nk  ];
                elseif strcmp( type, 'quad' )
                    %ni, nj, nk and nw are the nodes.
                    eNL = elenod(e);
                    ni = eNL{1,1}(1);
                    nj = eNL{1,1}(2);
                    nk = eNL{1,1}(3);
                    nw = eNL{1,1}(4);
                    % ncoor = coordinates of the nodes of the bar e
                    ncoor = { nodcoor{1,ni}, nodcoor{1,nj}, nodcoor{1,nk}, nodcoor{1,nw}   };
                    Ke = Quad4IsoPMembStiffness(ncoor,E, v, h, pG );
                    txt = sprintf('The stiffness matrix for the element %d is:',e);
                    fprintf(txt);
                    disp(Ke);
                    nodes = [ ni, nj, nk, nw ];
                    columns = [ 2*ni-1, 2*ni, 2*nj-1, 2*nj, 2*nk-1, 2*nk, 2*nw-1, 2*nw   ];
                end
                dof = length(Ke);
                % i is the row, j is the column
                for i = 1:dof/2
                    for j = 1:dof
                         K ( 2*nodes(i)-1, columns(j) ) =  K ( 2*nodes(i)-1, columns(j) ) + Ke ( 2*i-1,j );
                         K ( 2*nodes(i), columns(j) ) =  K ( 2*nodes(i), columns(j) ) + Ke ( 2*i,j );
                    end
                end
            end
            matrix = K;
            fprintf('The global stiffness matrix is:');
            disp(K);
    %if problem 2
    elseif strcmp(String, 'Problem2') == 1
        for e=1:numele
            E = elemat(1);
            v = elemat(2);
            h = elemat(3);
            eNL = elenod(e);
            ni = eNL{1,1}(1);
            nj = eNL{1,1}(2);
            nk = eNL{1,1}(3);
            nw = eNL{1,1}(4);
            % ncoor = coordinates of the nodes of the bar e
            ncoor = { nodcoor{1,ni}, nodcoor{1,nj}, nodcoor{1,nk}, nodcoor{1,nw}   };
            Ke = Quad4IsoPMembStiffness(ncoor,E, v, h, pG );
            %txt = sprintf('The stiffness matrix for the element %d is:',e);
            %fprintf(txt);
            %disp(Ke);
            nodes = [ ni, nj, nk, nw ];
            columns = [ 2*ni-1, 2*ni, 2*nj-1, 2*nj, 2*nk-1, 2*nk, 2*nw-1, 2*nw   ];
            dof = length(Ke);
            % i is the row, j is the column
            for i = 1:dof/2
                    for j = 1:dof
                         K ( 2*nodes(i)-1, columns(j) ) =  K ( 2*nodes(i)-1, columns(j) ) + Ke ( 2*i-1,j );
                         K ( 2*nodes(i), columns(j) ) =  K ( 2*nodes(i), columns(j) ) + Ke ( 2*i,j );
                    end
            end
            
        end
        matrix = K;
    end
    
end