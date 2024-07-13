%% This program call a graphical interface of the finite elements program
% Authors: Felipe da Silva Brandao and Vetle
% Discipline: Finite Elements
% Professor: Deane
% University: PUC-RIO

function varargout = finiteElementProgram(varargin)
% FINITEELEMENTPROGRAM MATLAB code for finiteElementProgram.fig
%      FINITEELEMENTPROGRAM, by itself, creates a new FINITEELEMENTPROGRAM or raises the existing
%      singleton*.
%
%      H = FINITEELEMENTPROGRAM returns the handle to a new FINITEELEMENTPROGRAM or the handle to
%      the existing singleton*.
%
%      FINITEELEMENTPROGRAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINITEELEMENTPROGRAM.M with the given input arguments.
%
%      FINITEELEMENTPROGRAM('Property','Value',...) creates a new FINITEELEMENTPROGRAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before finiteElementProgram_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to finiteElementProgram_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help finiteElementProgram

% Last Modified by GUIDE v2.5 06-Dec-2017 02:26:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @finiteElementProgram_OpeningFcn, ...
                   'gui_OutputFcn',  @finiteElementProgram_OutputFcn, ...
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


% --- Executes just before finiteElementProgram is made visible.
function finiteElementProgram_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to finiteElementProgram (see VARARGIN)

% Choose default command line output for finiteElementProgram
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes finiteElementProgram wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = finiteElementProgram_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in problem1Button.
function problem1Button_Callback(hObject, eventdata, handles)
% hObject    handle to problem1Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Problem1();
close(finiteElementProgram);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in BendProb2Button.
% Calls the problem 2 of a beam with one fixed end.
function BendProb2Button_Callback(hObject, eventdata, handles)
% hObject    handle to BendProb2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Problem2;
close(finiteElementProgram);
%figure1_CloseRequestFcn(hObject, eventdata, handles);



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
