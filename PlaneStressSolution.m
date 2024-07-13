%------------------------------------------------------------------
% PlaneStressSolution drives the analysis of the plane stress problem
% nodecoordinates: all node coordinates
% elemNodes: the nodes of each element
% elemat = Element material properties arranged as a two-dimensional list:
%       {  { type1, A1, Em1,v1,h1 }, . . . { typee, Ae, Eme,ve,he } },
%       where e is the total number of elements, A is the area.
% nodetag = [ nodetag_x1, nodetag_y1; nodetag_x2, nodetag_y2;...., nodetag_xn, nodetag_yn;]
% It is 1 when the displacement is specified and 0 otherwise.
% forcevalues = [ force_x1, force_y1; force_x2, force_y2;...., force_xn, force_yn;]
% They are the force applied in each degree of freedom.
% K: the global stiffness matrix
% It returns the object called solution, which includes noddisplacement,
% nodfor, nodePlateCounts, nodeStresses, barelem and barforces.
% String: "Problem1", "Problem2", "Problem3"

function solution = PlaneStressSolution(nodecoordinates, elemNodes, elemat, nodetag, forcevalues, K, String) 
    
        %calculates the K modified
        Kmod = ModifiedMasterStiffness(nodetag,K);
        
        %calculates the f modified
        fmod = ModifiedNodeForces(nodetag,forcevalues, K);
        
        %solve displacement
        % Kmod*u = fmod -> u = Kmod^(-1)*fmod
        u = linsolve(Kmod, fmod); 
        
        
        %calculate f = Ku, which is the list with the node forces,
        %including the reactions.
        f = K*u;
        
        %nodfor: force vector separated in nodes. f = [fx1, fy1; fx2, fy2, ... fxn, fyn]
        nodfor(size(f,1)/2, 2)=0;
        for i=1:size(f,1)/2
            nodfor(i,1) = f(2*i-1);
            nodfor(i,2) = f(2*i);
        end
        
        %noddisplacement: displacement vector separated in nodes. f = [ux1, uy1; ux2, uy2, ... uxn, uyn]
        noddisplacement(size(u,1)/2, 2)=0;
        for i=1:size(u,1)/2
            noddisplacement(i,1) = u(2*i-1);
            noddisplacement(i,2) = u(2*i);
        end
        
        %nodePlateCounts: it counts the number of plate elements (tri and
        %quad) linked to each node.
        %nodeStresses: matrix with averaged stresses at plate nodes
        if strcmp(String, 'Problem1') == 1
            Kmod %disp
            fmod %disp
            u %disp
            f %disp
            [nodePlateCounts, nodeStresses] = PlaneStressPlateStresses(nodecoordinates, elemNodes, elemat, noddisplacement);
        elseif strcmp(String, 'Problem2') == 1
            [nodePlateCounts, nodeStresses] = PlaneStressPlateStresses2(nodecoordinates, elemNodes, elemat, noddisplacement);
        end
            
        
        %barelem: a list of bar elements
        %barforces: a list of bar forces
        %[barelem, barforces] = PlaneStressBarForces(nodecoordinates, elemNodes, elemat, noddisplacement);
        
        solution.noddisplacement=noddisplacement;
        solution.nodfor = nodfor;
        solution.nodePlateCounts=nodePlateCounts;
        solution.nodeStresses = nodeStresses;
        %solution.barelem =barelem;
        %solution.barforces =barforces;
end