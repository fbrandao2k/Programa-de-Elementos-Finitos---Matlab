%------------------------------------------------------------------
% PlaneStressBarForces calculates the forces of bars
% elements
% nodecoordinates: all node coordinates
% elemNodes: the nodes of each element
% elemat = Element material properties arranged as a two-dimensional list:
%       {  { type1, A1, Em1,v1,h1 }, . . . { typee, Ae, Eme,ve,he } },
%       where e is the total number of elements, A is the area.
%noddisplacement: displacement vector separated in nodes. f = [ux1, uy1; ux2, uy2, ... uxn, uyn]

function [barelem, barforces] = PlaneStressBarForces(nodecoordinates, elemNodes, elemat, noddisplacement)

% Chapter 27 Felippa

end