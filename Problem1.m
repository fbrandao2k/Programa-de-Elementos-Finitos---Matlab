function varargout = Problem1(varargin)
% PROBLEM1 MATLAB code for Problem1.fig
%      PROBLEM1, by itself, creates a new PROBLEM1 or raises the existing
%      singleton*.
%
%      H = PROBLEM1 returns the handle to a new PROBLEM1 or the handle to
%      the existing singleton*.
%
%      PROBLEM1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROBLEM1.M with the given input arguments.
%
%      PROBLEM1('Property','Value',...) creates a new PROBLEM1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Problem1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Problem1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Problem1

% Last Modified by GUIDE v2.5 07-Dec-2017 00:34:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Problem1_OpeningFcn, ...
                   'gui_OutputFcn',  @Problem1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Problem1 is made visible.
function Problem1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Problem1 (see VARARGIN)

% Choose default command line output for Problem1
handles.output = hObject;


% UIWAIT makes Problem1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(hObject, 'units','normalized','outerposition',[0 0 1 1]);
set(gcf,'name','Problem 1 - Felippa book','numbertitle','off') ;

%status solver: 'INITIAL_MODE', 'IMPORTED_MODE', 'SOLVED_MODE',
%'CHANGED_MODE'
handles.mode = 'INITIAL_MODE';

 % Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Problem1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in importDataButton.
%start plotting the initial structure, importing all data
function importDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to importDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla;
finiteElement = importfile('finiteElement.txt');
data = finiteElement.data;
nodetag_temp = finiteElement.nodetag;
forcevalues_temp = finiteElement.forcevalues;
disp(data);
handles.data = data;

%% Preparing the cells 
% It separates the data in cells and returns in case of some error 
num_rows = size(data);
num_rows = num_rows(1);
% elenod is a cell with the nodes of all elements
elenod{1,num_rows } = [];
elemat{1,num_rows } = {};


%% Checking validity of data
for i = 1:num_rows    
    type = data{i,1};
    if strcmp (type, 'bar')==0 && strcmp (type, 'tri')==0 && strcmp (type, 'quad')==0
        sprintf('Erro:');
        sprintf('Este tipo de elemento nao existe: %f', type );
        return
    end
end



%% Calculating the elenod
% elenod: the element end nodes arranged as a two-dimensional list:
% { { i1,j1 }, { i2,j2 }, . . . { ie,je } }, where e is the total number of elements.
for i = 1:num_rows
    % nodes is a cell with the nodes of the element i
    nodes = data{i,2};
    nodes = strsplit(nodes,';');
    
    for j = 1:length(nodes)
        elenod{1,i}(j) = str2double( nodes(j) );
    end 
end

%% Calculating the nodcoor
% nodcoor: Nodal coordinates arranged as a two-dimensional list:
% { { x1,y1 },{ x2,y2 }, . . . { xn,yn } }, where n is the total number of nodes.
% the total number of nodes is equal to the maximum node number
total_node = 0;
for i = 1:num_rows
    nodes = data{i,2};
    nodes = strsplit(nodes,';');
    for j = 1:length(nodes)
        n = str2double( nodes(j) );
        if n > total_node
            total_node = n;
        end
    end
end

% list is the list with the number of the nodes not repeated 
%list_node = [];

% nodcoor is a cell with all coordinates of the nodes
nodcoor{1,total_node } = [];
%i=1;
 %while any(list_node)~= total_node && i<= num_rows
 for i=1:num_rows
        nodes = data{i,2};
        nodes = strsplit(nodes,';');
        coord_nodes = data{i,3};
        coord_nodes = strsplit(coord_nodes,';');
        
        for j=1:length(nodes)
                n = str2double ( nodes(j) );
                %if ismember(n, list_node) == 0
                    nodcoor{1,n}(1) = str2double( coord_nodes( 2*j-1 ) );
                    nodcoor{1,n}(2) = str2double( coord_nodes( 2*j ) );
                    %list_node(1,n) = n;
                %end
        end
 end
 
 %% Calculating the elemat (type, E, v, h and A)
 % elemat = Element material properties arranged as a two-dimensional list:
 % {  { type1, A1, Em1,v1,h1 }, . . . { typee, Ae, Eme,ve,he } },
 % where e is the total number of elements, A is the area.  
 for i = 1:num_rows
    type = data{i,1};
    E =  data{i,4} ;
    v =  data{i,5} ;
    h =  data{i,6} ;
    A =  data{i,7} ;
    elemat{1,i}(1) = {type};
    elemat{1,i}(2) = {A};
    elemat{1,i}(3) = {E};
    elemat{1,i}(4) = {v};
    elemat{1,i}(5) = {h};
 end
 
 %% nodetag and forcevalues
% Here is calculated the vectors nodetag and forcevalues
% total_node is the total number of nodes
% nodetag = [ nodetag_x1, nodetag_y1; nodetag_x2, nodetag_y2;...., nodetag_xn, nodetag_yn;]
% It is 1 when the displacement is specified and 0 otherwise.
nodetag = zeros(total_node, 2);
for i = 1:size(nodetag_temp,1)
    node = str2double ( nodetag_temp{i,1} );
    nodeBC = nodetag_temp{i,2};
    nodeBC = str2double( strsplit(nodeBC,';') );
    nodetag(node, 1) = nodeBC(1);
    nodetag(node, 2) = nodeBC(2);
end

% forcevalues = [ force_x1, force_y1; force_x2, force_y2;...., force_xn, force_yn;]
% They are the force applied in each degree of freedom.
forcevalues = zeros(total_node, 2);
for i = 1:size(forcevalues_temp,1)
    node = str2double ( forcevalues_temp{i,1} );
    nodeForce = forcevalues_temp{i,2};
    nodeForce = str2double( strsplit(nodeForce,';') );
    forcevalues(node, 1) = nodeForce(1);
    forcevalues(node, 2) = nodeForce(2);
end
 
%storing objects
handles.elemat = elemat;
handles.nodcoor = nodcoor;
handles.elenod = elenod;
handles.nodetag = nodetag;
handles.forcevalues = forcevalues;

 handles.mode = 'IMPORTED_MODE';
 title('Imported Structure') ;
 
 alpha(1);
 
 % Update handles structure
 guidata(hObject, handles);

 %plots the mesh
 axes(handles.axesProblem1);
 hold on;
 axis( [-2 7 -1 7] );
 axis equal
 Plot2DMesh(handles.nodcoor, handles.elenod, handles.elemat, handles.nodetag,handles.forcevalues);


% --- Executes on button press in saveResultsButton.
function saveResultsButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveResultsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(handles.mode,'SOLVED_MODE') == 0 && strcmp(handles.mode,'CHANGED_MODE') == 0
    warndlg('Import and solve first!','!! Aviso !!')
    return
else
    %user chooses the file to save
    FileName = uiputfile('*.xlsx',...
                       'Choose a folder to save the file');
    K =  handles.K;
    count = 1;
    data = {'Matrix Stiffness ='};
    sheet = 1;
    start_line = strcat('A',int2str(count));
    xlRange = start_line;
    xlswrite(FileName,data,sheet,start_line)
    count = count+1;
    data = K;
    start_line = strcat('A',int2str(count));
    xlRange = start_line;
    xlswrite(FileName,data,sheet,start_line)
    count = count+length(K)+2;
    data = {'Node displacements'};
    start_line = strcat('A',int2str(count));
    xlRange = start_line;
    xlswrite(FileName,data,sheet,start_line)
    count = count+1;
    data = handles.solution.noddisplacement';
    start_line = strcat('A',int2str(count));
    xlRange = start_line;
    xlswrite(FileName,data,sheet,start_line)
    count = count+4;
    data = {'Nodal forces ='};
    start_line = strcat('A',int2str(count));
    xlRange = start_line;
    xlswrite(FileName,data,sheet,start_line)
    count = count+1;
    data = handles.solution.nodfor';
    start_line = strcat('A',int2str(count));
    xlRange = start_line;
    xlswrite(FileName,data,sheet,start_line)
    count = count+4;
    data = {'Stresses XX, YY and XY:'};
    start_line = strcat('A',int2str(count));
    xlRange = start_line;
    xlswrite(FileName,data,sheet,start_line)
    count = count+1;
    
    data = cell2mat ( handles.solution.nodeStresses );
    start_line = strcat('A',int2str(count));
    xlRange = start_line;
    xlswrite(FileName,data,sheet,start_line)
    count = count+1;  
    
end

% --- Executes on button press in solveButton.
% calculates the stiffness matrix
function solveButton_Callback(hObject, eventdata, handles)
% hObject    handle to solveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp( handles.mode, 'INITIAL_MODE') == 1
    warndlg('Import first!','!! Aviso !!')
    return
elseif strcmp( handles.mode, 'SOLVED_MODE') == 1
    warndlg('FEM already solved','!! Aviso !!')
else
    %% Global Stiffness matrix
    % Choose here the value of pG (Gauss points)
    pG = 2;
    K = PlaneMasterStiffness(handles.nodcoor, handles.elenod, handles.elemat, pG,'Problem1');
    handles.K = K;
    
    %% Plane Stress Solution
    % It calculates the stress in all points for all elements.

    solution = PlaneStressSolution(handles.nodcoor, handles.elenod, handles.elemat, handles.nodetag, handles.forcevalues, K, 'Problem1');
    
    handles.solution = solution;
    
    handles.mode = 'SOLVED_MODE';
    
     % Update handles structure
    guidata(hObject, handles);
end


% --- Executes on button press in DeformationButton.
% shows the deformed structure
function DeformationButton_Callback(hObject, eventdata, handles)
% hObject    handle to DeformationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if strcmp(handles.mode,'SOLVED_MODE') == 0 && strcmp(handles.mode,'CHANGED_MODE') == 0
    warndlg('Import and solve first!','!! Aviso !!')
    return
else
    axes(handles.axesProblem1);
    hold on;
    axis( [-2 7 -1 7] );
    axis equal
    if strcmp(handles.mode,'CHANGED_MODE') == 1
        alpha(1)
        cla;
    else %the initial structure becomes transparent
        %alpha(.3)
    end
    PlotDeformedMesh(handles.nodcoor, handles.elenod,handles.elemat, 1e3, handles.solution.noddisplacement);
end
    
    
    
    
% --- Executes on button press in plotUXButton.
function plotUXButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotUXButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(handles.mode,'SOLVED_MODE') == 0
    warndlg('Import and solve first!','!! Aviso !!')
    return
else
    axes(handles.axesProblem1);
    hold on;
    axis( [-2 7 -1 7] );
    axis equal
    cla;
    PlotResult(handles.nodcoor, handles.elenod,handles.elemat, 1, handles.solution.noddisplacement(:,1), 'UX');
    handles.mode='CHANGED_MODE';
end

% --- Executes on button press in plotUYButton.
function plotUYButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotUYButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(handles.mode,'SOLVED_MODE') == 0
    warndlg('Import and solve first!','!! Aviso !!')
    return
else
    axes(handles.axesProblem1);
    hold on;
    axis( [-2 7 -1 7] );
    axis equal
    cla;
    PlotResult(handles.nodcoor, handles.elenod,handles.elemat, 1, handles.solution.noddisplacement(:,2), 'UY');
    handles.mode='CHANGED_MODE';
end

% --- Executes on button press in sigmaXXButton.
function sigmaXXButton_Callback(hObject, eventdata, handles)
% hObject    handle to sigmaXXButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(handles.mode,'SOLVED_MODE') == 0
    warndlg('Import and solve first!','!! Aviso !!')
    return
else
    axes(handles.axesProblem1);
    hold on;
    axis( [-2 7 -1 7] );
    axis equal
    cla;
    nodeStresses = cell2mat( handles.solution.nodeStresses );
    nodeStresses = nodeStresses(1,:);
    PlotResult(handles.nodcoor, handles.elenod,handles.elemat, 1, nodeStresses', 'sigmaXX');
    handles.mode='CHANGED_MODE';
end

% --- Executes on button press in sigmaYYButton.
function sigmaYYButton_Callback(hObject, eventdata, handles)
% hObject    handle to sigmaYYButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(handles.mode,'SOLVED_MODE') == 0
    warndlg('Import and solve first!','!! Aviso !!')
    return
else
    axes(handles.axesProblem1);
    hold on;
    axis( [-2 7 -1 7] );
    axis equal
    cla;
    nodeStresses = cell2mat( handles.solution.nodeStresses );
    nodeStresses = nodeStresses(2,:);
    PlotResult(handles.nodcoor, handles.elenod,handles.elemat, 1, nodeStresses', 'sigmaYY');
    handles.mode='CHANGED_MODE';
end

% --- Executes on button press in sigmaXYButton.
function sigmaXYButton_Callback(hObject, eventdata, handles)
% hObject    handle to sigmaXYButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(handles.mode,'SOLVED_MODE') == 0
    warndlg('Import and solve first!','!! Aviso !!')
    return
else
    axes(handles.axesProblem1);
    hold on;
    axis( [-2 7 -1 7] );
    axis equal
    cla;
    nodeStresses = cell2mat( handles.solution.nodeStresses );
    nodeStresses = nodeStresses(3,:);
    PlotResult(handles.nodcoor, handles.elenod,handles.elemat, 1, nodeStresses', 'sigmaXY');
    handles.mode='CHANGED_MODE';
end

% --- Executes on button press in MenuButton.
function MenuButton_Callback(hObject, eventdata, handles)
% hObject    handle to MenuButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;
clear all, clc;
finiteElementProgram();
