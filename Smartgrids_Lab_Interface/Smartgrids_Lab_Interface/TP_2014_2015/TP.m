function varargout = TP(varargin)
% TP MATLAB code for TP.fig
%      TP, by itself, creates a new TP or raises the existing
%      singleton*.
%
%      H = TP returns the handle to a new TP or the handle to
%      the existing singleton*.
%
%      TP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TP.M with the given input arguments.
%
%      TP('Property','Value',...) creates a new TP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TP

% Last Modified by GUIDE v2.5 17-Apr-2015 11:19:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TP_OpeningFcn, ...
                   'gui_OutputFcn',  @TP_OutputFcn, ...
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


% --- Executes just before TP is made visible.
function TP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TP (see VARARGIN)

% Choose default command line output for TP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
axes(handles.axes1);
image(imread('G2Elab.jpg'));
axis off

axes(handles.axes2);
image(imread('RD.jpg'));
axis off

% UIWAIT makes TP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LF_analysis_interface.
function LF_analysis_interface_Callback(hObject, eventdata, handles)
% hObject    handle to LF_analysis_interface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LFA

% --- Executes on button press in Reconfiguration_algo.
function Reconfiguration_algo_Callback(hObject, eventdata, handles)
% hObject    handle to Reconfiguration_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Reconfiguration

% --- Executes on button press in VVC_algo.
function VVC_algo_Callback(hObject, eventdata, handles)
% hObject    handle to VVC_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VVC

% --- Executes on button press in OLTC_algo.
function OLTC_algo_Callback(hObject, eventdata, handles)
% hObject    handle to OLTC_algo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Time_analysis.
function Time_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Time_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Time_analysis
