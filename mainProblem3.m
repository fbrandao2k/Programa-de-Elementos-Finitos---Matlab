%% This code is responsible to the problem 3
% Authors: Felipe da Silva Brandao and Vetle
% Discipline: Finite Elements
% Professor: Deane
% University: PUC-RIO


%% Inputs
E = 10e7;
v = 0.3; %poisson
h=1;
P = 1e6; %load
% Dimensions of the plate
L = 1. ;                % Length of the plate
B = 1. ;                % Breadth of the plate
Radius = 0.1;
% Choose here the value of pG (Gauss points)
pG = 2;
% Number of discretizations along xi and eta axis
n = 10;

%% Calculates X and Y of all points
%X and Y are all points of 1/quarter of the geometry
[X,Y] = MeshPlateHole.meshplate(L, B, Radius, n);

[m,n]=size(X);


%% Calculating the elenod
% elenod: the element end nodes arranged as a two-dimensional list:
% { { i1,j1,k1,w1 }, { i2,j2,k2,w2 }, . . . { ie,je,ke,we } }, where e is the total number of elements.
nElem = 4*(n-1)*(2*n-2); 
elenod{1,nElem} = {};

%complete elenod with the first quarter of the plate
count=1;
for i = 1:2*n-2
    for j= 1:n-1
        elenod{1,count} = [j+(i-1)*n, j+1+(i-1)*n, j+n+1+(i-1)*n, j+n+(i-1)*n];
        count = count+1;
    end
end
%complete elenod with the second quarter of the plate
add = (n)*(2*n-1)-n;
for i = 1:2*n-2
    for j= 1:n-1
        elenod{1,count} = [j+(i-1)*n+add, j+1+(i-1)*n+add, j+n+1+(i-1)*n+add, j+n+(i-1)*n+add];
        count = count+1;
    end
end
%complete elenod with the thrid quarter of the plate
add = add+(n)*(2*n-1)-n;
for i = 1:2*n-2
    for j= 1:n-1
        elenod{1,count} = [j+(i-1)*n+add, j+1+(i-1)*n+add, j+n+1+(i-1)*n+add, j+n+(i-1)*n+add];
        count = count+1;
    end
end
%complete elenod with the fourth quarter of the plate
add = add+(n)*(2*n-1)-n;
for i = 1:2*n-3
    for j= 1:n-1
        elenod{1,count} = [j+(i-1)*n+add, j+1+(i-1)*n+add, j+n+(i-1)*n+add, j+n+1+(i-1)*n+add];
        count = count+1;
    end
end
%complete elenod with the last elements
add = add+(n)*(2*n-1)-n-n;
i=1;
for j = 1:n-1
    elenod{1,count} = [j+add, j+1+add, i+1, i];
    count = count+1;
    i=i+1;
end

