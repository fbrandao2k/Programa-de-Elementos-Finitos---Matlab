%------------------------------------------------------------------
% ModifiedMasterStiffness calculate the Kmod, which is the stiffness matrix
% after the BC
% nodetag = [ nodetag_x1, nodetag_y1; nodetag_x2, nodetag_y2;...., nodetag_xn, nodetag_yn;]
% It is 1 when the displacement is specified and 0 otherwise.
function Kmodified = ModifiedMasterStiffness(nodetag,K)

    Kmodified = K;

    nnode = length(K);

    for i = 1:nnode
        %gets the ceiling number and the remainder, so it is not necessary to
        %flat the vector nodetag
        if rem(i,2) == 1
            column = 1;
        else
            column =2;
        end
        if nodetag( ceil(i/2), column ) == 1
            for j=1:nnode
                if j == i
                    Kmodified(i, j) = 1;
                else
                    Kmodified(i,j) = 0;
                end
            end
        end
    end
end