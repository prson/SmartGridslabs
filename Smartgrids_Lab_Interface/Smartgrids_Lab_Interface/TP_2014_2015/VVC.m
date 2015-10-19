function varargout = VVC(varargin)
% VVC MATLAB code for VVC.fig
%      VVC, by itself, creates a new VVC or raises the existing
%      singleton*.
%
%      H = VVC returns the handle to a new VVC or the handle to
%      the existing singleton*.
%
%      VVC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VVC.M with the given input arguments.
%
%      VVC('Property','Value',...) creates a new VVC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VVC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VVC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VVC

% Last Modified by GUIDE v2.5 19-Mar-2015 12:39:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VVC_OpeningFcn, ...
                   'gui_OutputFcn',  @VVC_OutputFcn, ...
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


% --- Executes just before VVC is made visible.
function VVC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VVC (see VARARGIN)

% Choose default command line output for VVC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VVC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VVC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Load_Data.
function Load_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fileName = uigetfile('*.xls');
fileName = handles.fileName;
handles.Line = xlsread(fileName,1);
handles.Bus = xlsread(fileName,2);
handles.Imax = xlsread(fileName,3);
handles.Parametres = xlsread(fileName,'Parametres');


handles.Coordonnees = xlsread('Coordonnees.xls');

axes(handles.axes1)
coord_int = [0;1;2;0;3;4;5;6;7;8;9;10;11;12];

hold on
for i=1:size(handles.Line,1)
    if handles.Line(i,1) ~=1 && handles.Line(i,2) ~=1,
        if intersect(get(handles.Config, 'Data'),i),
            % Alors la ligne est ouverte
            plot([handles.Coordonnees(coord_int(handles.Line(i,1)),2),handles.Coordonnees(coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(coord_int(handles.Line(i,1)),3),handles.Coordonnees(coord_int(handles.Line(i,2)),3)],'--','color','red')
        else
            plot([handles.Coordonnees(coord_int(handles.Line(i,1)),2),handles.Coordonnees(coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(coord_int(handles.Line(i,1)),3),handles.Coordonnees(coord_int(handles.Line(i,2)),3)],'color','black')
        end
    end
end
plot(handles.Coordonnees([1;2;9],2),handles.Coordonnees([1;2;10],3),'sq','color','red','MarkerFaceColor','red')
plot(handles.Coordonnees(setdiff([1:1:12],[1;2;9]),2),handles.Coordonnees(setdiff([1:1:12],[1;2;9]),3),'o','color','black','MarkerFaceColor','black')
text(handles.Coordonnees(:,2)+0.1,handles.Coordonnees(:,3)+0.1,num2str(handles.Coordonnees(:,1)))

axis equal

guidata(hObject,handles)


function NDG_Callback(hObject, eventdata, handles)
% hObject    handle to NDG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NDG as text
%        str2double(get(hObject,'String')) returns contents of NDG as a double


% --- Executes during object creation, after setting all properties.
function NDG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NDG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in VVC.
function VVC_Callback(hObject, eventdata, handles)
% hObject    handle to VVC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.DGlist),
   location = get(handles.DGlist,'Data');
    NO = get(handles.Config, 'Data');
    Line = handles.Line;
    Bus = handles.Bus;
    Imax = handles.Imax;
    Param = handles.Parametres;
    Noeuds_source = [2;3;11];

    %% ¨Prise en compte du régalge des régleurs
    Valeurs_regleur = get(handles.OLTC_settings, 'Data');

%     if sum(Valeurs_regleur < 1.1)== 3 &&  sum(Valeurs_regleur > 0.9) == 3,
%         Consigne_regleur = Valeurs_regleur ;
%     elseif sum(Valeurs_regleur < 1.1*Param(1)) == 3 && sum(Valeurs_regleur > 0.9*Param(1))==3,
%         Consigne_regleur = Valeurs_regleur/Param(1) ;
%     elseif sum(Valeurs_regleur < 1.1*Param(3))==3 && sum(Valeurs_regleur > 0.9*Param(3))==3,
%         Consigne_regleur = Valeurs_regleur/Param(3) ;
%     end
    
    Sbase = Param(2); % MVA
    Tableau_conso = get(handles.Consumption, 'Data')/Sbase;
    Connection_node = get(handles.Node_choice, 'Data');
    Tableau_prod = get(handles.Production, 'Data')/Sbase;
    
    [handles.exitflag,handles.Tension_finale,handles.P_sol,handles.x_solution] = VVC_algorithm(Bus, Line, NO, Imax, Param, Noeuds_source,Tableau_conso,Connection_node,Tableau_prod,location);

    if handles.exitflag == -2,
        set(handles.Conclusion,'String',['No feasible solution found (' num2str(handles.exitflag) ')'])
    else
        set(handles.Conclusion,'String',['Feasible solution found (' num2str(handles.exitflag) ')'])
    end
    set(handles.VVC_results,'Data',[min(handles.Tension_finale);max(handles.Tension_finale);handles.P_sol]);
    
    DG_number = str2num(get(handles.NDG,'String'));
    t2 = uitable('Data',zeros(DG_number,1),'Position',[800 220 150 130],'ColumnEditable',[true true true true true]);
    Solution_finale = handles.x_solution;
    Solution_finale = [Solution_finale(1:3);Solution_finale(4:end)*Sbase];
    set(t2,'Data',Solution_finale)
    set(t2,'ColumnName', {'Q_generateurs (MW)'});




%     if exitflag == -2,
%         set(handles.Conclusion,'String',['No feasible solution found (' num2str(exitflag) ')'])
%     else
%         set(handles.Conclusion,'String',['Feasible solution found (' num2str(exitflag) ')'])
%     end
%     set(handles.VVC_results,'Data',[min(bus_sol(:,2));max(bus_sol(:,2));P_sol]);
%     
%     DG_number = str2num(get(handles.NDG,'String'));
%     t2 = uitable('Data',zeros(DG_number,1),'Position',[800 220 150 130],'ColumnEditable',[true true true true true]);
%     set(t2,'Data',x_solution)
end



% --- Executes on button press in Apply.
function Apply_Callback(hObject, eventdata, handles)
% hObject    handle to Apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DG_number = str2num(get(handles.NDG,'String'));
if DG_number == 0,
    handles.DGlist = [];
else    
    t = uitable('Data',zeros(1,DG_number),'Position',[100 200 450 50],'ColumnEditable',[true true true true true]);
    handles.DGlist = t;

end
handles.DGN = DG_number;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function Consumption_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Consumption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(9,2));
set(hObject, 'RowName', {'Load 1','Load 2','Load 3','Load 5','Load 6','Load 7','Load 8','Load 9','Load 10' }, 'ColumnName', {'P_Cons (MW)','Q_Cons (MVAr)'});


% --- Executes during object creation, after setting all properties.
function Production_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Production (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(5,2));
set(hObject, 'RowName', {'Gen 1 (N14)','Gen 2 (N7)','Gen 3 (N10 ou 12)','Gen 4 (N9 ou 13)','Gen 5 (N5)'}, 'ColumnName', {'P_DG (MW)','Q_DG (MVAr)'});


% --- Executes during object creation, after setting all properties.
function Node_choice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Node_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(1,2));
set(hObject, 'RowName', {'Connection node'}, 'ColumnName', {'Gen 3','Gen 4'});


% --- Executes during object creation, after setting all properties.
function VVC_results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VVC_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(3,1));
set(hObject, 'RowName', {'Vmin(pu)','Vmax(pu)','Losses (pu)'}, 'ColumnName', {'Values'});


% --- Executes during object creation, after setting all properties.
function Q_sol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Q_sol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Config_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Apply_configuration.
function Apply_configuration_Callback(hObject, eventdata, handles)
% hObject    handle to Apply_configuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hold on
coord_int = [0;1;2;0;3;4;5;6;7;8;9;10;11;12];

for i=1:size(handles.Line,1)
    if handles.Line(i,1) ~=1 && handles.Line(i,2) ~=1,
        if intersect(get(handles.Config, 'Data'),i),
            % Alors la ligne est ouverte
            plot([handles.Coordonnees(coord_int(handles.Line(i,1)),2),handles.Coordonnees(coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(coord_int(handles.Line(i,1)),3),handles.Coordonnees(coord_int(handles.Line(i,2)),3)],'color','white')
            plot([handles.Coordonnees(coord_int(handles.Line(i,1)),2),handles.Coordonnees(coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(coord_int(handles.Line(i,1)),3),handles.Coordonnees(coord_int(handles.Line(i,2)),3)],'--','color','red')
        else
            plot([handles.Coordonnees(coord_int(handles.Line(i,1)),2),handles.Coordonnees(coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(coord_int(handles.Line(i,1)),3),handles.Coordonnees(coord_int(handles.Line(i,2)),3)],'color','black')
        end
    end
end
plot(handles.Coordonnees([1;2;9],2),handles.Coordonnees([1;2;10],3),'sq','color','red','MarkerFaceColor','red')
plot(handles.Coordonnees(setdiff([1:1:12],[1;2;9]),2),handles.Coordonnees(setdiff([1:1:12],[1;2;9]),3),'o','color','black','MarkerFaceColor','black')
text(handles.Coordonnees(:,2)+0.1,handles.Coordonnees(:,3)+0.1,num2str(handles.Coordonnees(:,1)))

axis equal


% --- Executes when entered data in editable cell(s) in OLTC_settings.
function OLTC_settings_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to OLTC_settings (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in OLTC_settings.
function OLTC_settings_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to OLTC_settings (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function OLTC_settings_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OLTC_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', ones(3,1));
set(hObject, 'RowName', {'N2','N3','N11'}, 'ColumnName', {'Voltage'});
