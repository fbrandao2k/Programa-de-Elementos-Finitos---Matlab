%------------------------------------------------------------------
% PlotResult plot the desirable result: stress, displacement
% It receives the following parameters:
% nodecoordinates: all node coordinates
% elemNodes: the nodes of each element
% component to be plotted as a profile
% string is the component: 'UX', 'UY', 'sigmaXX', ...
function PlotResult2(nodecoordinates, elemNodes, elemat, factor,component, string, Lx, Ly)

scale = min(Lx, Ly);
    if abs(scale) < 0.5
        axis([ -0.15 Lx+0.15 -0.15 Ly+0.15 ]);
    end
    
nel = length(elemNodes) ;                       % number of elements
nnode = length(nodecoordinates) ;               % total number of nodes in system
nnel = 4;

    nquads = nel;
    
        X(4, nquads) = 0;
        Y(4, nquads) = 0;
        profile = zeros(4,nquads);
        for iel = 1:nel
                
                for i = 1:nnel
                    node = elemNodes{1,iel}(i);
                    X(i, iel) = nodecoordinates{1,node}(1);
                    Y(i, iel) = nodecoordinates{1,node}(2);
                    profile(i,iel) = component(node) ;  
                end
            

        end
        
        plot(X,Y,'k')
        fill(X,Y,profile)
        clear X Y profile node
    
    
    
  
        if strcmp(string, 'UX') == 1
            title('Profile of UX on Mesh') ; 
        elseif strcmp(string, 'UY') == 1
            title('Profile of UY on Mesh') ;
        elseif strcmp(string, 'sigmaXX') == 1
            title('Profile of sigmaXX on Mesh') ;
        elseif strcmp(string, 'sigmaYY') == 1
            title('Profile of sigmaYY on Mesh') ;
        elseif strcmp(string, 'sigmaXY') == 1
            title('Profile of sigmaXY on Mesh') ;
        end
        %axis equal
        %axis off ;
        % Colorbar Setting
        alpha(1);
        SetColorbar
    
end

%bar shoing the max and min values of the profile
function SetColorbar
    cbar = colorbar;
    % Dimensions of the colorbar     
    % cpos = get(cbar,'position'); 
    % cpos(3) = cpos(3)/4 ;   % Reduce the width of colorbar by half
    % cpos(2) = cpos(2)+.1 ;
    % cpos(4) = cpos(4)-.2 ;
    %set(cbar,'Position',cpos) ;
    %brighten(0.5); 

    % Title of the colorbar
    set(get(cbar,'title'),'string','VAL');
    %locate = get(cbar,'title');
    %tpos = get(locate,'position');
    %tpos(3) = tpos(3)+5. ;
    %set(locate,'pos',tpos);

    % Setting the values on colorbar
    %
    % get the color limits
    clim = caxis;
    ylim(cbar,[clim(1) clim(2)]);
    numpts = 24 ;    % Number of points to be displayed on colorbar
    kssv = linspace(clim(1),clim(2),numpts);
    set(cbar,'YtickMode','manual','YTick',kssv); % Set the tickmode to manual
    for i = 1:numpts
        imep = num2str(kssv(i),'%+3.2E');
        vasu(i) = {imep} ;
    end
    set(cbar,'YTickLabel',vasu(1:numpts),'fontsize',9);
end