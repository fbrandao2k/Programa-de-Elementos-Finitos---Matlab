%------------------------------------------------------------------
% PlotDeformedMesh the deformed mesh
% It receives the following parameters:
% nodecoordinates: all node coordinates
% elemNodes: the nodes of each element
function PlotDeformedMesh(nodecoordinates, elemNodes, elemat, factor,noddisplacement)

nel = length(elemNodes) ;                       % number of elements
nnode = length(nodecoordinates) ;               % total number of nodes in system

%counting the number of bars, tri and quad
    nbars = 0;
    ntris = 0;
    nquads = 0;
    for i=1:nel
       if strcmp( elemat{1,i}(1), 'bar')
           nbars = nbars+1;
       elseif strcmp( elemat{1,i}(1), 'tri')
           ntris = ntris+1;
       elseif strcmp( elemat{1,i}(1), 'quad')
           nquads = nquads+1;
       end
    end

    ux = noddisplacement(:,1) ;
    uy = noddisplacement(:,2) ;
    utotal = sqrt( ux.*ux+uy.*uy );
    
    
     %plotting triangles
    if ntris>0
        X(3, ntris) = 0;
        Y(3, ntris) = 0;
        UX = zeros(3,ntris) ;
        UY = zeros(3,ntris) ;
        profile = zeros(3,ntris);
        for iel = 1:nel
            if strcmp( elemat{1,iel}(1), 'tri')
                nnel = 3;
                for i = 1:nnel
                    node = elemNodes{1,iel}(i);
                    X(i, iel) = nodecoordinates{1,node}(1);
                    Y(i, iel) = nodecoordinates{1,node}(2);
                    UX(i,iel) = ux(node) ;
                    UY(i,iel) = uy(node) ;
                    profile(i,iel) = utotal(node) ;  
                end
            end

        end
        defoX = X+factor*UX ;
        defoY = Y+factor*UY ;  
        %figure
        plot(defoX,defoY,'k')
        fill(defoX,defoY,profile)
        clear X Y UX UY profile node
    end
    
     %plotting quads
    if nquads>0
        X(4, nquads) = 0;
        Y(4, nquads) = 0;
        UX = zeros(4,nquads) ;
        UY = zeros(4,nquads) ;
        profile = zeros(4,nquads);
        for iel = 1:nel
            if strcmp( elemat{1,iel}(1), 'quad')
                nnel = 4;
                for i = 1:nnel
                    node(i) = elemNodes{1,iel}(i);
                    X(i, iel) = nodecoordinates{1,node(i)}(1);
                    Y(i, iel) = nodecoordinates{1,node(i)}(2);
                    UX(i,iel) = ux(node(i)) ;
                    UY(i,iel) = uy(node(i)) ;
                    profile(i,iel) = utotal(node(i)) ;  
                end
            end

        end
        defoX = X+factor*UX ;
        defoY = Y+factor*UY ;  
        %figure
        plot(defoX,defoY,'k')
        fill(defoX,defoY,profile)
        clear X Y UX UY profile node
    end
    
    
    
    
    %for the bars
    if nbars >0
        nnel = 2;   
        
        % Initialization of the required matrices
        X = zeros(nnel,nbars) ; UX = zeros(nnel,nbars) ;
        Y = zeros(nnel,nbars) ; UY = zeros(nnel,nbars) ;
        profile = zeros(nnel,nel);


        for iel=1:nel   
            if strcmp( elemat{1,iel}(1), 'bar')
                nd=elemNodes{1,iel};
                X(1,iel)=nodecoordinates{1,nd(1)}(1);    % extract x value of the node
                Y(1,iel)=nodecoordinates{1,nd(1)}(2);    % extract y value of the node
                X(2,iel)=nodecoordinates{1,nd(2)}(1);    % extract x value of the node
                Y(2,iel)=nodecoordinates{1,nd(2)}(2);    % extract y value of the node

                UX(1,iel) = ux(nd(1)) ;
                UX(2,iel) = ux(nd(2)) ;
                UY(1,iel) = uy(nd(1)) ;
                UY(2,iel) = uy(nd(2)) ;

                profile(1,iel) = utotal(nd(1)) ;  
                profile(2,iel) = utotal(nd(2)) ;
            end
        end

        % Plotting the profile of a property on the deformed mesh for the bars
        defoX = X+factor*UX ;
        defoY = Y+factor*UY ;  
        %figure
        plot(defoX,defoY,'k')
        fill(defoX,defoY,profile)
        title('Profile of Utotal on deformed Mesh') ; 
        %axis equal
        %axis off ;
        % Colorbar Setting
        SetColorbar
    end
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