%------------------------------------------------------------------
% ModifiedNodeForces calculate the fmod, which is the force vector
% after the BC
% nodetag = [ nodetag_x1, nodetag_y1; nodetag_x2, nodetag_y2;...., nodetag_xn, nodetag_yn;]
% It is 1 when the displacement is specified and 0 otherwise.
% forcevalues = [ force_x1, force_y1; force_x2, force_y2;...., force_xn, force_yn;]
% forcevalues are the forces applied in each dof.
function fmod = ModifiedNodeForces(nodetag,forcevalues, K)

%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%testing ModifiedNodeForces
syms v1 v2 v4;
syms K11 K22 K13 K14 K15 K16;
syms K12 K22 K23 K24 K25 K26;
syms K13 K23 K33 K34 K35 K36;
syms K14 K24 K34 K44 K45 K46;
syms K15 K25 K35 K45 K55 K56;
syms K16 K26 K36 K46 K56 K66;
nodetag=[1,1;0,1;0,0;];
forcevalues = [v1,v2;0,v4;0,0;];
K = [ K11 K22 K13 K14 K15 K16;...
K12 K22 K23 K24 K25 K26;...
K13 K23 K33 K34 K35 K36;...
K14 K24 K34 K44 K45 K46;...
K15 K25 K35 K45 K55 K56;...
K16 K26 K36 K46 K56 K66;];
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}

nnodof = length(K); 

%creating a flat copy of forcevalues
flat_forcevalues(nnodof,1)=0;
for i = 1:nnodof
    if rem(i,2) == 1
            column = 1;
    else
            column = 2;
    end
    flat_forcevalues(i) = forcevalues( ceil(i/2), column );
end

%{
%shaping flat_forcevalues to become fmod
for i = 1:nnodof
        %gets the ceiling number and the remainder, so it is not necessary to
        %flat the vector nodetag
        if rem(i,2) == 1
            column = 1;
        else
            column = 2;
        end
        if nodetag( ceil(i/2), column ) == 0
            for j=1:nnodof
                    if rem(j,2) == 1
                            column = 1;
                    else
                            column = 2;
                    end
                    if j == i
                        flat_forcevalues(i) = flat_forcevalues(i) + forcevalues(ceil(j/2), column );
                    else
                        flat_forcevalues(i) = flat_forcevalues(i) - K(i,j)*forcevalues(ceil(j/2), column );
                    end
            end
        end
end
%}

fmod = flat_forcevalues;

end