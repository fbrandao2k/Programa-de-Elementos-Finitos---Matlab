%------------------------------------------------------------------
% One-Dimensional Gauss Rules with 1 through 5 Sample Points.
% The Mathematica module listed in Figure 17.3 returns the information for
% the i th point of the pth rule { ei,wi }.
% for the first five unidimensional Gauss rules.
% if p is not in the range 1 through 5, the module returns [ 0,0 ].
% Point i is a point between 1 and 5.
% It returns the sample point abcissa ei and the weight wi. [ ei , wi ]
function info = LineGaussRuleInfo(p,point) 
    % The values of g are the ei points.
    i = point;
    if i < 1 || i > 5
        info = [0,0];
        return
    end
    g2=[-1,1]/sqrt(3);
    g3=[-sqrt(3/5),0,sqrt(3/5)];
    w3=[5/9,8/9,5/9];
    w4=[(1/2)-sqrt(5/6)/6, (1/2)+sqrt(5/6)/6,(1/2)+sqrt(5/6)/6, (1/2)-sqrt(5/6)/6];
    g4=[ -sqrt((3+2*sqrt(6/5))/7) , -sqrt((3-2*sqrt(6/5))/7), sqrt((3-2*sqrt(6/5))/7), sqrt((3+2*sqrt(6/5))/7) ];
    g5=[ -sqrt(5+2*sqrt(10/7)),-sqrt(5-2*sqrt(10/7)), 0 , sqrt(5-2*sqrt(10/7)), sqrt(5+2*sqrt(10/7))]/3;
    w5=[ 322-13*sqrt(70), 322+13*sqrt(70), 512 , 322+13*sqrt(70) , 322-13*sqrt(70)]/900;
    if p==1
        info= { 0 , 2 };
    elseif p==2
        info={ g2(i) , 1 };
    elseif p==3
        info = { g3(i),w3(i) };
    elseif p==4
        info = { g4(i),w4(i) };
    elseif p==5
        info = { g5(i),w5(i) };
    else
        info = { 0 , 0 };
    end
end