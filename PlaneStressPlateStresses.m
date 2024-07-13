%------------------------------------------------------------------
% PlaneStressPlateStresses calculates the stresses for triangle and quad
% elements
% nodecoordinates: all node coordinates
% elemNodes: the nodes of each element
% elemat = Element material properties arranged as a two-dimensional list:
%       {  { type1, A1, Em1,v1,h1 }, . . . { typee, Ae, Eme,ve,he } },
%       where e is the total number of elements, A is the area.
% noddisplacement: displacement vector separated in nodes. f = [ux1, uy1; ux2, uy2, ... uxn, uyn]
% This function returns:
% nodePlateCounts: it counts the number of plate elements (tri and
% quad) linked to each node.
% nodeStresses: matrix with averaged stresses at plate nodes

function [nodePlateCounts, nodeStresses] = PlaneStressPlateStresses(nodecoordinates, elemNodes, elemat, noddisplacement)

    %number of elements
    numele=length(elemNodes);

    %number of nodes
    numnod=length(nodecoordinates);

    %creating an empty nodePlateCounts
    nodePlateCounts(numnod) = 0; 

    %creating an empty nodeStresses
    nodeStresses{1,numnod} = {};
    for i = 1:numnod
        nodeStresses{1,i} = [0;0;0;];
    end
    

    for i = 1:numele
        type = elemat{1,i}(1);
        enl = elemNodes{1,i};
        nNodeElement = length(enl);
        %nCoorElem(nNodeElement, 2) = 0;
        nCoorElem{1,nNodeElement} = {};
        ue(nNodeElement*2,1) = 0;
        %fill nCoorElem, which is the vector with the node coordinates of the
        %element i
        for j = 1:nNodeElement
            % fill nCoorElem, which is the vector with the node coordinates of the
            % element i
            %nCoorElem(j,:) = nodecoordinates{ 1,enl(j) };
            nCoorElem{1,j} = nodecoordinates{ 1,enl(j) };
            %element displacements
            ue(2*j-1) = noddisplacement(enl(j),1);
            ue(2*j) = noddisplacement(enl(j),2); 
        end
        
        if strcmp(type, 'Bar')
                %does nothing
                continue
        elseif strcmp(type,'quad')
                E = cell2mat( elemat{1,i}(3) );
                v = cell2mat ( elemat{1,i}(4) );
                Emat = E/(1-v^2)*[1,v,0;v,1,0;0,0,(1-v)/2];
                %cell of stresses sigma of the element i
                sige = Quad4IsoPMembraneStresses(nCoorElem,Emat,ue);
        elseif strcmp(type,'tri')
                E = cell2mat( elemat{1,i}(3) );
                v = cell2mat ( elemat{1,i}(4) );
                Emat = E/(1-v^2)*[1,v,0;v,1,0;0,0,(1-v)/2];
                sige = Trig3IsoPMembraneStresses(nCoorElem,Emat,ue);
        end
        
        if strcmp(type, 'tri') == 1 || strcmp(type, 'quad') == 1
            for j = 1:nNodeElement
                %node being used
                node = enl(j);
                %number of tri or quad shared with the same node
                nodePlateCounts(node) = nodePlateCounts(node)+1;
                nodeStresses{1,node} = nodeStresses{1,node} + sige{1,j};
            end
        end
    end
    
    %averaging the stresses
    for i = 1:numnod
            %count is how many times the node i is shared with other
            %elements
            count = nodePlateCounts(i);
            if count > 1
                nodeStresses{1,i} = nodeStresses{1,i}/count;
            end
    end
end