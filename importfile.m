function finiteElement = importfile(filename)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   FINITEELEMENT = IMPORTFILE(FILENAME) Reads data from text file
%   FILENAME for the default selection.
%
    %% Open the text file.
    fileID = fopen(filename,'r');

    %% Read columns of data according to format string.
    % This call separates the text in the file in objects that will be used for
    % the finite elements program
    cont = 1;
    while cont == 1
         % Get file line
          tline = fgetl(fileID);
          % Get rid of blank spaces
          string = deblank(tline);

          % Check for a file format tag string
          switch string
               case '%DATA'
                   finiteElement.data = readData(fileID);
                   
               case '%NODETAG'
                   finiteElement.nodetag = readNodeTag(fileID);
                   
               case '%FORCEVALUES'
                   finiteElement.forcevalues = readForcesValues(fileID);
                   
               case '%END'
                   cont = 0;
          end
    end

    fclose(fileID);

end

%% Auxiliary functions
%--------------------------------------------------------------------------
%The data is ordered in the following way:
%   column1: text (%s)
%	column2: text (%s)
%   column3: text (%s)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
function data = readData(fileID)
     total_lines = fscanf(fileID,'%f',1);
     dataArray{total_lines, 7} = {} ;
     for i = 1:total_lines
        %dataArray = textscan(fileID, '%s%s%s%f%f%f%f%[^\n\r]');
        %tline = fgetl(fileID);
        dataArray{i,1} = fscanf(fileID,'%s',1);
        dataArray{i,2} = fscanf(fileID,'%s',1);
        dataArray{i,3} = fscanf(fileID,'%s',1);
        dataArray{i,4} = fscanf(fileID,'%f',1);
        dataArray{i,5} = fscanf(fileID,'%f',1);
        dataArray{i,6} = fscanf(fileID,'%f',1);
        dataArray{i,7} = fscanf(fileID,'%f',1);
     end
     data = dataArray;
end

%--------------------------------------------------------------------------
% nodetag is a cell with zeros and ones. The value is 1 when the
% displacement is specified and 0 otherwise. 
% The first value of nodetag represents the
% node number.
% The nodetag begins only with the nodes in which the BC are aplied. It 
% will be later completed with the rest of the nodes.
function nodetag = readNodeTag(fileID)

     %number of boundary conditions
     nBC = str2double( fscanf(fileID,'%s',1) );
     nodetag{nBC,2} = {};
     
     %the node to be applied the boundary condition
     node = fscanf(fileID,'%s',1);
     
     %complete the nodetag cell
     for i=1:nBC
         nodetag{i,1} = node;
         nodetag{i,2} = fscanf(fileID,'%s',1);
         node = fscanf(fileID,'%s',1);
     end
     
end

%--------------------------------------------------------------------------
% forcevalues is a cell with the values of the forces applied.
% It is negative when it is against the x or y axis
% The first value of forcevalues represents the
% node number.
% The forcevalues begins only with the nodes in which the forces are aplied.
% It will be later completed with the rest of the nodes.
function forcevalues = readForcesValues(fileID)

     %number of forces
     nForces = str2double( fscanf(fileID,'%s',1) );
     forcevalues{nForces,2} = {};
     
     %the node to be applied the boundary condition
     node = fscanf(fileID,'%s',1);
     
     %complete the nodetag cell
     for i=1:nForces
         forcevalues{i,1} = node;
         forcevalues{i,2} = fscanf(fileID,'%s',1);
         node = fscanf(fileID,'%s',1);
     end
     
end

    
