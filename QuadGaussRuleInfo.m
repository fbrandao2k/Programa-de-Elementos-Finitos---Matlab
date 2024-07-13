%------------------------------------------------------------------
% QuadGaussRuleInfo
% point = [i,j] in the case of p1 different from p2.
% point = k in the case p1 = p2.
% the same for the p.
% p are the number of points [p1,p2] or just p=p1=p2.
% It returns ei and nj, respectively, and the weight product wij = wiwj
function info2 = QuadGaussRuleInfo(p,point)
    if length(p) == 2
        p1 = p(1);
        p2 = p(2);
        else
            p1 = p;
            p2 = p1;
    end
    if length(point) == 2
        i = point(1);
        j = point(2);
    else
        % if point is not a list, just a number, so that point is a
        % “visiting counter” k that runs from 1 through p^2.
        m = point;
        % Here j is in this sequence 1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4...,
        % p,p,p,p,
        j = floor((m-1)/p1)+1;
        %Here i is in this sequence 1,2,3,4,1,2,3,4,1,2,3,4.....
        i = m-p1*(j-1); 
    end
    info = LineGaussRuleInfo(p1, i);
    e = info(1);
    w1 = cell2mat( info(2) );
    info = LineGaussRuleInfo(p2, j);
    n = info(1);
    w2 = cell2mat ( info(2) );
    w12 = w1*w2;
    info2 = [ e,n,w12 ];
end