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
set(gcf,'name','Problem 2 - Bending problem','numbertitle','off') ;

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


    %% Inputs
    E = str2double ( get(handles.youngModulus,'String') ); 
    v = str2double ( get(handles.poisson,'String') ); %poisson
    h= str2double ( get(handles.h,'String') );
    P = str2double ( get(handles.loadP,'String') ); %load
    Lx = str2double ( get(handles.Lx,'String') ); %mesh Lx side
    Ly = str2double ( get(handles.Ly,'String') ); %mesh Ly side
    nElemX = str2double ( get(handles.nElemx,'String') ); %Number of elements in the x direction
    nElemY = str2double ( get(handles.nElemy,'String') ); %Number of elements in the y direction
    % Choose here the value of pG (Gauss points)
    pG = 2;
    
    %% Calculating X and Y 
    
    X = 0:Lx/nElemX:Lx;
    Y = 0:Ly/nElemY:Ly;
    [X,Y] = meshgrid(X,Y);

    %total number of elements
    nElem = nElemX*nElemY;

    nLines = nElemY+1;
    nColumns = nElemX+1;
    
    %total number of elements
    nElem = nElemX*nElemY;

    nLines = nElemY+1;
    nColumns = nElemX+1;
    %% Calculating the elenod
    % elenod: the element end nodes arranged as a two-dimensional list:
    % { { i1,j1,k1,w1 }, { i2,j2,k2,w2 }, . . . { ie,je,ke,we } }, where e is the total number of elements.

    elenod{1,nElem} = {};

    count=1;
    for i = 1:nLines-1
        for j= 1:nColumns-1
        elenod{1,count} = [j+(i-1)*nColumns, j+1+(i-1)*nColumns, j+nColumns+1+(i-1)*nColumns, j+nColumns+(i-1)*nColumns];
        count = count+1;
        end
    end
    
    %% Calculating the nodcoor
    % nodcoor: Nodal coordinates arranged as a two-dimensional list:
    % { { x1,y1 },{ x2,y2 }, . . . { xn,yn } }, where n is the total number of nodes.

    %total_nodes is the total number of nodes
    total_nodes=nLines*nColumns;
    nodcoor{1,total_nodes } = [];
    count=1;
    for j=1:size(Y,1)
        for i = 1:size(X,2)
            nodcoor{1,count} = [ X(j,i), Y(j,i) ];
            count = count+1;
        end
    end
    
     %% Calculating the elemat (E, v, h)
     % elemat = Element material properties
     % In this problem, E, v(poisson) and h are the same for all elements,
     % therefore elemat is single list with three values
     % [ Em,v,h ]
     elemat(1) = E;
     elemat(2) = v;
     elemat(3) = h;
     
     %% Global Stiffness matrix
     K = PlaneMasterStiffness(nodcoor, elenod, elemat, pG,'Problem2');
     handles.K = K;
    
      %% nodetag and forcevalues
    % Here is calculated the vectors nodetag and forcevalues
    % total_node is the total number of nodes
    % nodetag = [ nodetag_x1, nodetag_y1; nodetag_x2, nodetag_y2;...., nodetag_xn, nodetag_yn;]
    % It is 1 when the displacement is specified and 0 otherwise.
    nodetag = zeros(total_nodes, 2);
    for i = 1:nElemY+1
        node = 1+(i-1)*(nElemX+1);
        nodetag(node, 1) = 1;
        nodetag(node, 2) = 1;
    end
    
    % forcevalues = [ force_x1, force_y1; force_x2, force_y2;...., force_xn, force_yn;]
    % They are the force applied in each degree of freedom.
    forcevalues = zeros(total_nodes, 2);
    for i = 1:nElemY+1
        node = (nElemX+1)+(i-1)*(nElemX+1);
        forcevalues(node, 1) = 0;
        forcevalues(node, 2) = -P/(nElemY+1);
    end
    
    %storing objects
    handles.elemat = elemat;
    handles.nodcoor = nodcoor;
    handles.elenod = elenod;
    handles.nodetag = nodetag;
    handles.forcevalues = forcevalues;

    handles.mode = 'SOLVED_MODE';
    title('Solved') ;
     
    % Update handles structure
    guidata(hObject, handles);
     
    
     %% Calulating all X and Y and plotting
     handles.sizex = Lx;
     handles.sizey = Ly;
    axes(handles.axesProblem2)
    hold on;
    axis equal
    zoom on
    axis([ -1 Lx+1 -1 Ly+1 ]);
    cla;
  
    for i =1:size(X,2)
        line( [X(1,i), X(1,i)], [Y(1,i), Y(nLines,i)] );
    end
    for i =1:size(Y,1)
        line( [X(i,1), X(i,nColumns)], [Y(i,1), Y(i,1)] );
    end

    
    %plotting texts, circles, supports and forces
    Plot2DMesh2(handles.nodcoor, handles.elenod, handles.elemat, handles.nodetag,handles.forcevalues, P, Lx, Ly);
     
    %% Plane Stress Solution
    % It calculates the stress in all points for all elements.

    solution = PlaneStressSolution(handles.nodcoor, handles.elenod, handles.elemat, handles.nodetag, handles.forcevalues, K, 'Problem2');
    
    handles.solution = solution;
    
    handles.mode = 'SOLVED_MODE';
    
     % Update handles structure
    guidata(hObject, handles);


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
    axes(handles.axesProblem2);
    hold on;
    axis([ -1 handles.sizex+1 -1 handles.sizey+1 ]);
    axis equal
    if strcmp(handles.mode,'CHANGED_MODE') == 1
        alpha(1)
        cla;
    else %the initial structure becomes transparent
        %alpha(.3)
    end
    if handles.sizey < 0.5
        PlotDeformedMesh2(handles.nodcoor, handles.elenod,handles.elemat, 1e+5, handles.solution.noddisplacement, handles.sizex, handles.sizey);
    else
        PlotDeformedMesh2(handles.nodcoor, handles.elenod,handles.elemat, 1e-1, handles.solution.noddisplacement, handles.sizex, handles.sizey);
    end
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
    axes(handles.axesProblem2);
    hold on;
    axis([ -1 handles.sizex+1 -1 handles.sizey+1 ]);
    axis equal
    cla;
    PlotResult2(handles.nodcoor, handles.elenod,handles.elemat, 1, handles.solution.noddisplacement(:,1), 'UX', handles.sizex, handles.sizey);
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
    axes(handles.axesProblem2);
    hold on;
    axis([ -1 handles.sizex+1 -1 handles.sizey+1 ]);
    axis equal
    cla;
    PlotResult2(handles.nodcoor, handles.elenod,handles.elemat, 1, handles.solution.noddisplacement(:,2), 'UY', handles.sizex, handles.sizey);
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
    axes(handles.axesProblem2);
    hold on;
    axis([ -1 handles.sizex+1 -1 handles.sizey+1 ]);
    axis equal
    cla;
    nodeStresses = cell2mat( handles.solution.nodeStresses );
    nodeStresses = nodeStresses(1,:);
    PlotResult2(handles.nodcoor, handles.elenod,handles.elemat, 1, nodeStresses', 'sigmaXX', handles.sizex, handles.sizey);
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
    axes(handles.axesProblem2);
    hold on;
    axis([ -1 handles.sizex+1 -1 handles.sizey+1 ]);
    axis equal
    cla;
    nodeStresses = cell2mat( handles.solution.nodeStresses );
    nodeStresses = nodeStresses(2,:);
    PlotResult2(handles.nodcoor, handles.elenod,handles.elemat, 1, nodeStresses', 'sigmaYY',handles.sizex, handles.sizey) ;
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
    axes(handles.axesProblem2);
    hold on;
    axis([ -1 handles.sizex+1 -1 handles.sizey+1 ]);
    axis equal
    cla;
    nodeStresses = cell2mat( handles.solution.nodeStresses );
    nodeStresses = nodeStresses(3,:);
    PlotResult2(handles.nodcoor, handles.elenod,handles.elemat, 1, nodeStresses', 'sigmaXY', handles.sizex, handles.sizey);
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
