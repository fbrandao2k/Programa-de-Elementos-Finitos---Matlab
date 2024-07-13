%------------------------------------------------------------------
% MeshPlateHole draws the mesh for the problem 3
% It returns X and Y which are the coordinates for all points in the
% geometry
% This code was partially copied from the free source code of Siva and
% Indira. Some modifications were made.

classdef MeshPlateHole

    methods(Static)
        
        function [X,Y] = meshplate(L, B, Radius, n)
            % To mesh a plate with hole at center using Transfinite Interpolation (TFI)
            %{
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             Warning : On running this the workspace memory will be deleted. Save if
             any data present before running the code !!
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            --------------------------------------------------------------------------
             This part of the code was written by : Siva Srinivas Kolukula, PhD                           |
                               Structural Mechanics Laboratory                       |
                               Indira Gandhi Center for Atomic Research              |
                               India                                                 |
             E-mail : allwayzitzme@gmail.com                                         |
             web-link: https://sites.google.com/site/kolukulasivasrinivas/           |
            --------------------------------------------------------------------------
            %}
            % Version 1 : 15 November 2013
            
            % Dimensions of the plate
            %L = 1. ;                % Length of the plate
            %B = 1. ;                % Breadth of the plate

            % Number of discretizations along xi and eta axis
            %m = 10 ;
            m=n;
            %n = 10 ;
            %
            % Model plate as two regions which lie in first quadrant
            global R theta;
            %R = 0.1 ;               % Radius of the hole at center
            R = Radius;
            %%%%%%%%%%%%%%%%%%%%%%%Dont change from here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            theta = pi/2 ;          % Quarter angle of the hole
            global O P1 P2 P3 P4 P5 CMP ;
            O = [0. 0.] ;           % Centre of plate and hole
            P1 = [R 0.] ;           % Edge of the hole and plate
            P2 = [L/2 0.] ;         % Edge of the plate
            P3 = [L/2 B/2] ;        % Edge of the plate
            P4 = [0. B/2] ;         % Edge of the plate
            P5 = [0. R] ;           % Edge of the hole and plate
            CMP = [R*cos(theta/2.) R*sin(theta/2.)] ;
            % discretize along xi and eta axis
            xi = linspace(0.,1,m) ;
            eta = linspace(0.,1.,n) ;
            % Number of Domains 
            Domain = 2 ;
            DX = cell(1,Domain) ;   
            DY = cell(1,Domain) ;
            for d = 1:Domain        % Loop for two domains lying in first coordinate
                % Initialize matrices in x and y axis
                X = zeros(m,n) ;
                Y = zeros(m,n) ;

                for i = 1:m
                    Xi = xi(i) ;
                    for j = 1:n
                        Eta = eta(j) ;

                        % Transfinite Interpolation 
                        XY = (1-Eta)*MeshPlateHole.Xb(Xi,d)+Eta*MeshPlateHole.Xt(Xi,d)+(1-Xi)*MeshPlateHole.Xl(Eta,d)+Xi*MeshPlateHole.Xr(Eta,d)......
                            -(Xi*Eta*MeshPlateHole.Xt(1,d)+Xi*(1-Eta)*MeshPlateHole.Xb(1,d)+Eta*(1-Xi)*MeshPlateHole.Xt(0,d)+(1-Xi)*(1-Eta)*MeshPlateHole.Xb(0,d)) ;

                        X(i,j) = XY(1) ;
                        Y(i,j) = XY(2) ;

                    end
                end
                DX{d} = X ;
                DY{d} = Y ;
            end
            % Arrange the coordinates for each domain
            X1 = DX{1} ; Y1 = DY{1} ;       % Grid for first domain
            X2 = DX{2} ; Y2 = DY{2} ;       % Grid for second domain
            X = [X1 ;X2(m-1:-1:1,:)] ;      % Merge both the domains
            Y = [Y1 ;Y2(m-1:-1:1,:)] ;
            % Plot 1/4th of the plate
            %figure(1)
            %MeshPlateHole.plotgrid(X,Y) ;
            % break
            % Plot other domains of plate by imaging coordinates
            vec = [1 1 ; -1 1 ; -1 -1 ; 1 -1] ;
            figure(2)
            for quadrant = 1:4
                MeshPlateHole.plotgrid(vec(quadrant,1)*X,vec(quadrant,2)*Y) ;
                hold on
            end
        end

        function plotgrid(X,Y)

            % plotgrid: To plot structured grid.
            %
            % plotgrid(X,Y)
            %
            % INPUT:
            % X (matrix)    - matrix with x-coordinates of gridpoints
            % Y (matrix)    - matrix with y-coordinates of gridpoints


            if any(size(X)~=size(Y))
               error('Dimensions of X and Y must be equal');
            end

            [m,n]=size(X);

            % Plot grid
            % figure
            set(gcf,'color','w') ;
            axis equal
            axis off
            box on
            hold on

            % Plot internal grid lines
            for i=1:m
                plot(X(i,:),Y(i,:),'b','linewidth',1); 
            end
            for j=1:n
                plot(X(:,j),Y(:,j),'b','linewidth',1); 
            end

            % hold off
        end
        
        
        function xyb = Xb(s,Domain)
            global R ;
            r = R ;
            global O P1 P2 P3 P4 P5 CMP ;

            switch Domain
                case 1

                    x = O(1)+r*cos(pi/4*s) ;
                    y = O(2)+r*sin(pi/4*s) ;

                case 2

                    x = O(1)+r*cos(pi/4*s) ;
                    y = O(2)+r*sin(pi/4*s) ;

            end

            xyb = [x ; y] ;

        end
        
        function xyl = Xl(s,Domain)

            global O P1 P2 P3 P4 P5 CMP ;

            switch Domain
                case 1

                    x = P1(1)+(P2(1)-P1(1))*s ;
                    y = P1(2)+(P2(2)-P1(2))*s ;

                case 2

                    x = P5(1)+(P4(1)-P5(1))*s ;
                    y = P5(2)+(P4(2)-P5(2))*s ;    

            end

            xyl = [x ; y] ;
        end
        
        function xyr = Xr(s,Domain)
            global O P1 P2 P3 P4 P5 CMP ;

            switch Domain

                case 1

                    x = CMP(1)+(P3(1)-CMP(1))*s ;
                    y = CMP(2)+(P3(2)-CMP(2))*s ;

                case 2   

                    x = CMP(1)+(P3(1)-CMP(1))*s ;
                    y = CMP(2)+(P3(2)-CMP(2))*s ;

            end

            xyr = [x ; y] ;
        end
        
        function xyt = Xt(s,Domain)

            global O P1 P2 P3 P4 P5 CMP ;

            switch Domain
                case 1   

                    x = P2(1)+(P3(1)-P2(1))*s ;
                    y = P2(2)+(P3(2)-P2(2))*s ;

                case 2

                    x = P3(1)+(P4(1)-P3(1))*s ;
                    y = P3(2)+(P4(2)-P3(2))*s ;    

            end

            xyt = [x ; y] ;
        end
    end

end