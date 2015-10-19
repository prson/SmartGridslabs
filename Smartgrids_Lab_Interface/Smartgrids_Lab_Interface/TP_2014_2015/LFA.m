function varargout = LFA(varargin)
% LFA MATLAB code for LFA.fig
%      LFA, by itself, creates a new LFA or raises the existing
%      singleton*.
%
%      H = LFA returns the handle to a new LFA or the handle to
%      the existing singleton*.
%
%      LFA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LFA.M with the given input arguments.
%
%      LFA('Property','Value',...) creates a new LFA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LFA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LFA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LFA

% Last Modified by GUIDE v2.5 16-Mar-2015 16:27:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LFA_OpeningFcn, ...
                   'gui_OutputFcn',  @LFA_OutputFcn, ...
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


% --- Executes just before LFA is made visible.
function LFA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LFA (see VARARGIN)

% Choose default command line output for LFA
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LFA wait for user response (see UIRESUME)
% uiwait(handles.figure1);
axis(handles.axes4,'off')


% --- Outputs from this function are returned to the command line.
function varargout = LFA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(~, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Config_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


set(hObject, 'Data', zeros(1,5));
set(hObject, 'RowName', {'Configuration'}, 'ColumnName', {'SW1', 'SW2', 'SW3', 'SW4', 'SW5'});


% --- Executes when entered data in editable cell(s) in Config.
function Config_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to Config (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
% data = get(hObject,'data');
% handles.configuration = data
% guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Consumption_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Consumption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject, 'Data', zeros(9,2));
set(hObject, 'RowName', {'Load 1 (N9)','Load 2 (5)','Load 3(N11)','Load 5 (N13)','Load 6 (N6)','Load 7 (N12)','Load 8 (N2)','Load 9 (7)','Load 10 (N8)' }, 'ColumnName', {'P_L (MW)','Q_L (MVAr)'});

% --- Executes during object creation, after setting all properties.
function Production_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Production (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(5,2));
set(hObject, 'RowName', {'Gen 1 (N14)','Gen 2 (N7)','Gen 3 (N10 ou 12)','Gen 4 (N9 ou 13)','Gen 5 (N5)'}, 'ColumnName', {'P_DG (MW)','Q_DG (MVAr)'});


% --- Executes during object creation, after setting all properties.
function Node_choice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to node_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(1,2));
set(hObject, 'RowName', {'Connection node'}, 'ColumnName', {'Gen 3','Gen 4'});


% --- Executes on button press in Loadflow.
function Loadflow_Callback(hObject, eventdata, handles)
% hObject    handle to Loadflow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Exécution du loadflow
if isfield(handles,'NO')==0,
    NO = [];
    disp('Attention, le réseau n''est pas radial')
elseif length(handles.NO)~= 5
    NO = [];
    disp('Attention, le réseau n''est pas radial')
else
    NO = handles.NO;
    Line = handles.Line;
    Bus = handles.Bus;
    Imax = handles.Imax;
    Param = handles.Parametres;
    Noeuds_source = [2;3;11];
    Consigne_regleur = [1;1;1];
    
    Sbase = Param(2); % MVA
    Tableau_conso = get(handles.Consumption, 'Data')/Sbase;
    Connection_node = get(handles.Node_choice, 'Data');
    Tableau_prod = get(handles.Production, 'Data')/Sbase;
    %% LF
    [Tension,Courant, Pertes] = Execution_loadflow(Bus, Line, NO, Imax, Param, Noeuds_source, Consigne_regleur,Tableau_conso,Connection_node,Tableau_prod);

    
    %% Sauvegarde des résultats
    handles.nbus = Bus(:,1);
    handles.nline = (1:1:size(Courant,1))';
    handles.Voltage = Tension;
    handles.Current = Courant;
    handles.Losses = Pertes;
    
    %% Visualisation

    contents = get(handles.Unit_choice,'Value');
    contents_vis = get(handles.Visu,'Value');

    Max_current = max(Courant);
    Min_voltage = min(Tension);
    Max_voltage = max(Tension);

    
    switch contents
        case 1
            set(handles.Results_voltage, 'Data',Tension) ;
            set(handles.Results_summary, 'Data',[Min_voltage ;Max_voltage ;Max_current;Pertes]) ;

            switch contents_vis
                case 1
                    plot(handles.axes3,handles.nbus,Tension,'.r',handles.nbus,Tension,'color','black')
                case 2 
                    plot(handles.axes3,handles.nline,Courant,'.r',handles.nline,Courant,'color','black')
                otherwise
            end

        case 2 
            % Dans la base RD
            set(handles.Results_voltage, 'Data',Tension*Param(1)) ;
            set(handles.Results_summary, 'Data',[Min_voltage*Param(1) ;Max_voltage*Param(1) ;Max_current;Pertes]) ;

            switch contents_vis
                case 1
                    plot(handles.axes3,handles.nbus,Tension*Param(1),'.r',handles.nbus,Tension*Param(1),'color','black')
                case 2 
                    plot(handles.axes3,handles.nline,Courant,'.r',handles.nline,Courant,'color','black')
                otherwise
            end

        case 3 
            % Dans la base MR
            set(handles.Results_voltage, 'Data',Tension*Param(3)) ;
            set(handles.Results_summary, 'Data',[Min_voltage*Param(3) ;Max_voltage*Param(3) ;Max_current;Pertes]) ;

            switch contents_vis
                case 1
                    plot(handles.axes3,handles.nbus,Tension*Param(3),'.r',handles.nbus,Tension*Param(3),'color','black')
                case 2 
                    plot(handles.axes3,handles.nline,Courant,'.r',handles.nline,Courant,'color','black')
                otherwise
            end

        otherwise
    end   
end

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function Loadflow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Loadflow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





% --- Executes on button press in Load_Data.
function Load_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fileName = uigetfile('*.xls');
fileName = handles.fileName;
handles.Line = xlsread(fileName,'Line');
handles.Bus = xlsread(fileName,'Bus');
handles.Imax = xlsread(fileName,'I_max');
handles.Parametres = xlsread(fileName,'Parametres');
handles.Coordonnees = xlsread('Coordonnees.xls');

axes(handles.axes4)

hold on
handles.coord_int = [0;1;2;0;3;4;5;6;7;8;9;10;11;12];
for i=1:size(handles.Line,1)
    if handles.Line(i,1) ~=1 && handles.Line(i,2) ~=1,
        if ~isempty(intersect(handles.Config,i)),
            % Alors la ligne est ouverte
            plot([handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3)],'--','color','red')
        else
            plot([handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3)],'color','black')
        end
    end
end
plot(handles.Coordonnees([1;2;9],2),handles.Coordonnees([1;2;10],3),'sq','color','red','MarkerFaceColor','red','Markersize',20)
plot(handles.Coordonnees(setdiff([1:1:12],[1;2;9]),2),handles.Coordonnees(setdiff([1:1:12],[1;2;9]),3),'o','color','black','MarkerFaceColor','black','Markersize',10)
taille1 = 0.5;
taille2 = 0.5;
text(handles.Coordonnees(:,2)+taille1,handles.Coordonnees(:,3)+taille1,num2str(handles.Coordonnees(:,1)))

axis equal

guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function Load_Data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Load_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on key press with focus on Unit_choice and none of its controls.
function Unit_choice_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Unit_choice (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in Consumption.
function Consumption_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to Consumption (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
% data = get(hObject,'data');
% handles.consumption = data
% guidata(hObject,handles);


% --- Executes when entered data in editable cell(s) in Production.
function Production_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to Production (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)



% --- Executes when entered data in editable cell(s) in node_choice.
function Node_choice_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to node_choice (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Consumption, 'Data', zeros(9,2));
set(handles.Production, 'Data', zeros(5,2));
set(handles.Node_choice, 'Data', zeros(1,2));
set(handles.Config, 'Data', zeros(1,5));
set(handles.Config, 'Data', zeros(1,5));
set(handles.Results_voltage, 'Data', zeros(13,1));
set(handles.Results_summary, 'Data', zeros(4,1));
set(handles.OLTC_settings,'Data', ones(3,1))
cla(handles.axes3)
cla(handles.axes4)

% --- Executes during object creation, after setting all properties.
function Results_voltage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Results_voltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(13,1));
set(hObject, 'RowName', {'N1','N2','N3','N5','N6','N7','N8','N9','N10','N11','N12','N13','N14'}, 'ColumnName', {'Voltage'});


% --- Executes when entered data in editable cell(s) in Results_voltage.
function Results_voltage_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to Results_voltage (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in Unit_choice.
function Unit_choice_Callback(hObject, eventdata, handles)
% hObject    handle to Unit_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Unit_choice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Unit_choice
% cla(handles.axes3)
contents = get(handles.Unit_choice,'Value');
contents_vis = get(handles.Visu,'Value');

Tension = handles.Voltage;
Min_voltage = min(Tension);
Max_voltage = max(Tension);
Param = handles.Parametres;
Courant = handles.Current;
Max_current = max(Courant);
Pertes = handles.Losses;

switch contents
    case 1
        set(handles.Results_voltage, 'Data',Tension) ;
        set(handles.Results_summary, 'Data',[Min_voltage ;Max_voltage ;Max_current;Pertes]) ;

        switch contents_vis
            case 1
                plot(handles.axes3,handles.nbus,Tension,'.r',handles.nbus,Tension,'color','black')
            case 2 
                plot(handles.axes3,handles.nline,Courant,'.r',handles.nline,Courant,'color','black')
            otherwise
        end
        
    case 2 
        % Dans la base RD
        set(handles.Results_voltage, 'Data',Tension*Param(1)) ;
        set(handles.Results_summary, 'Data',[Min_voltage*Param(1) ;Max_voltage*Param(1) ;Max_current;Pertes]) ;
    
        switch contents_vis
            case 1
                plot(handles.axes3,handles.nbus,Tension*Param(1),'.r',handles.nbus,Tension*Param(1),'color','black')
            case 2 
                plot(handles.axes3,handles.nline,Courant,'.r',handles.nline,Courant,'color','black')
            otherwise
        end
    
    case 3 
        % Dans la base MR
        set(handles.Results_voltage, 'Data',Tension*Param(3)) ;
        set(handles.Results_summary, 'Data',[Min_voltage*Param(3) ;Max_voltage*Param(3) ;Max_current;Pertes]) ;
    
        switch contents_vis
            case 1
                plot(handles.axes3,handles.nbus,Tension*Param(3),'.r',handles.nbus,Tension*Param(3),'color','black')
            case 2 
                plot(handles.axes3,handles.nline,Courant,'.r',handles.nline,Courant,'color','black')
            otherwise
        end
    
    otherwise
end

% --- Executes during object creation, after setting all properties.
function Unit_choice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Unit_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function OLTC_settings_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OLTC_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', ones(3,1));
set(hObject, 'RowName', {'N2','N3','N11'}, 'ColumnName', {'Voltage'});




% --- Executes on button press in OLTC.
function OLTC_Callback(hObject, eventdata, handles)
% hObject    handle to OLTC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'NO')==0,
    NO = [];
    disp('Attention, le réseau n''est pas radial')
elseif length(handles.NO)~= 5
    NO = [];
    disp('Attention, le réseau n''est pas radial')
else
    NO = handles.NO;
    Line = handles.Line;
    Bus = handles.Bus;
    Imax = handles.Imax;
    Param = handles.Parametres;
    Noeuds_source = [2;3;11];

    %% ¨Prise en compte du régalge des régleurs
    Valeurs_regleur = get(handles.OLTC_settings, 'Data');

    if sum(Valeurs_regleur < 1.1)== 3 &&  sum(Valeurs_regleur > 0.9) == 3,
        Consigne_regleur = Valeurs_regleur ;
    elseif sum(Valeurs_regleur < 1.1*Param(1)) == 3 && sum(Valeurs_regleur > 0.9*Param(1))==3,
        Consigne_regleur = Valeurs_regleur/Param(1) ;
    elseif sum(Valeurs_regleur < 1.1*Param(3))==3 && sum(Valeurs_regleur > 0.9*Param(3))==3,
        Consigne_regleur = Valeurs_regleur/Param(3) ;
    end
       
        
    Sbase = Param(2); % MVA
    Tableau_conso = get(handles.Consumption, 'Data')/Sbase;
    Connection_node = get(handles.Node_choice, 'Data');
    Tableau_prod = get(handles.Production, 'Data')/Sbase;
    
    %% LF
    [Tension,Courant, Pertes] = Execution_loadflow(Bus, Line, NO, Imax, Param, Noeuds_source, Consigne_regleur,Tableau_conso,Connection_node,Tableau_prod);

    %% Sauvegarde des résultats
    handles.nbus = Bus(:,1);
    handles.nline = (1:1:size(Courant,1))';
    handles.Voltage = Tension;
    handles.Current = Courant;
    handles.Losses = Pertes;
    
    %% Visualisation
    contents = get(handles.Unit_choice,'Value');
    contents_vis = get(handles.Visu,'Value');
 
    Max_current = max(Courant);
    Min_voltage = min(Tension);
    Max_voltage = max(Tension); 
    
    switch contents
        case 1
            set(handles.Results_voltage, 'Data',Tension) ;
            set(handles.Results_summary, 'Data',[Min_voltage ;Max_voltage ;Max_current;Pertes]) ;
 
            switch contents_vis
                case 1
                    plot(handles.axes3,handles.nbus,Tension,'.r',handles.nbus,Tension,'color','black')
                case 2 
                    plot(handles.axes3,handles.nline,Courant,'.r',handles.nline,Courant,'color','black')
                otherwise
            end
 
        case 2 
            % Dans la base RD
            set(handles.Results_voltage, 'Data',Tension*Param(1)) ;
            set(handles.Results_summary, 'Data',[Min_voltage*Param(1) ;Max_voltage*Param(1) ;Max_current;Pertes]) ;
 
            switch contents_vis
                case 1
                    plot(handles.axes3,handles.nbus,Tension*Param(1),'.r',handles.nbus,Tension*Param(1),'color','black')
                case 2 
                    plot(handles.axes3,handles.nline,Courant,'.r',handles.nline,Courant,'color','black')
                otherwise
            end
 
        case 3 
            % Dans la base MR
            set(handles.Results_voltage, 'Data',Tension*Param(3)) ;
            set(handles.Results_summary, 'Data',[Min_voltage*Param(3) ;Max_voltage*Param(3) ;Max_current;Pertes]) ;
 
            switch contents_vis
                case 1
                    plot(handles.axes3,handles.nbus,Tension*Param(3),'.r',handles.nbus,Tension*Param(3),'color','black')
                case 2 
                    plot(handles.axes3,handles.nline,Courant,'.r',handles.nline,Courant,'color','black')
                otherwise
            end
 
        otherwise
    end   
end
 
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function Results_summary_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Results_summary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(4,1));
set(hObject, 'RowName', {'Vmin(pu/kV)','Vmax(pu/kV)','Imax(%Iadm)','Plosses (%Cons)'}, 'ColumnName', {'Value'});


% --- Executes during object creation, after setting all properties.
function OLTC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OLTC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


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


% --- Executes on button press in Apply.
function Apply_Callback(hObject, eventdata, handles)
% hObject    handle to Apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.NO = nonzeros(get(handles.Config, 'Data'));


% cla(handles.axes4)
for i=1:size(handles.Line,1)
    if handles.Line(i,1) ~=1 && handles.Line(i,2) ~=1,
        if ~isempty(intersect(get(handles.Config, 'Data'),i)),
            % Alors la ligne est ouverte
            plot([handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3)],'-','color','white')
            plot([handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3)],'--','color','red')
            X1 = handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2);
            X2 = handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2);
            Y1 = handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3);
            Y2 = handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3);
            text((X1+X2)/2,(Y1+Y2)/2,['L ',num2str(i)])
        else
            % Alors la ligne est fermée
            plot([handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3)],'-','color','white')
            plot([handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3)],'-','color','black')
        end
    end
end

axis equal
guidata(hObject,handles)


% --- Executes on key press with focus on visu and none of its controls.
function visu_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to visu (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in Visu.
function Visu_Callback(hObject, eventdata, handles)
% hObject    handle to Visu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Visu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Visu
% cla(handles.axes3)

contents_uc = get(handles.Unit_choice,'Value');
contents_vis = get(handles.Visu,'Value');
Param = handles.Parametres;

switch contents_uc
    case 1
        switch contents_vis
            case 1
                plot(handles.axes3,handles.nbus,handles.Voltage,'.r',handles.nbus,handles.Voltage,'color','black')
            case 2 
                plot(handles.axes3,handles.nline,handles.Current,'.r',handles.nline,handles.Current,'color','black')
            otherwise
        end
    case 2 
        % Dans la base RD
        switch contents_vis
            case 1
                plot(handles.axes3,handles.nbus,handles.Voltage*Param(1),'.r',handles.nbus,handles.Voltage*Param(1),'color','black')
            case 2 
                plot(handles.axes3,handles.nline,handles.Current,'.r',handles.nline,handles.Current,'color','black')
            otherwise
        end
    case 3 
        % Dans la base MR
        switch contents_vis
            case 1
                plot(handles.axes3,handles.nbus,handles.Voltage*Param(3),'.r',handles.nbus,handles.Voltage*Param(3),'color','black')
            case 2 
                plot(handles.axes3,handles.nline,handles.Current,'.r',handles.nline,handles.Current,'color','black')
            otherwise
        end
    otherwise
end


% --- Executes during object creation, after setting all properties.
function Visu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Visu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Unit_choice_OLTC.
function Unit_choice_OLTC_Callback(hObject, eventdata, handles)
% hObject    handle to Unit_choice_OLTC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Unit_choice_OLTC contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Unit_choice_OLTC


% --- Executes during object creation, after setting all properties.
function Unit_choice_OLTC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Unit_choice_OLTC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
