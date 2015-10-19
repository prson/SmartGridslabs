function varargout = Reconfiguration(varargin)
% RECONFIGURATION MATLAB code for Reconfiguration.fig
%      RECONFIGURATION, by itself, creates a new RECONFIGURATION or raises the existing
%      singleton*.
%
%      H = RECONFIGURATION returns the handle to a new RECONFIGURATION or the handle to
%      the existing singleton*.
%
%      RECONFIGURATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECONFIGURATION.M with the given input arguments.
%
%      RECONFIGURATION('Property','Value',...) creates a new RECONFIGURATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Reconfiguration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Reconfiguration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Reconfiguration

% Last Modified by GUIDE v2.5 26-Mar-2015 20:45:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Reconfiguration_OpeningFcn, ...
                   'gui_OutputFcn',  @Reconfiguration_OutputFcn, ...
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


% --- Executes just before Reconfiguration is made visible.
function Reconfiguration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Reconfiguration (see VARARGIN)

% Choose default command line output for Reconfiguration
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

axis(handles.axes1,'off')
axis(handles.axes4,'off')
% UIWAIT makes Reconfiguration wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = Reconfiguration_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Reconfiguration.
function Reconfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to Reconfiguration (see GCBO)
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
    Consigne_regleur = [1;1;1];
    
    Sbase = Param(2); % MVA
    Tableau_conso = get(handles.Consumption, 'Data')/Sbase;
    Connection_node = get(handles.Node_choice, 'Data');
    Tableau_prod = get(handles.Production, 'Data')/Sbase;
    %% LF
    [Tension_initiale,Courant_initiale, Pertes_initiales] = Execution_loadflow(Bus, Line, NO, Imax, Param, Noeuds_source, Consigne_regleur,Tableau_conso,Connection_node,Tableau_prod);

    %% Reconfiguration
    [Config_trouvee] = Execution_SOB(Line, Bus,Param,Imax,Tableau_conso,Tableau_prod,Connection_node);

    [Tension_finale,Vecteur_I_fin, Pertes_finales] = Execution_loadflow(Bus, Line, Config_trouvee, Imax, Param, Noeuds_source, Consigne_regleur,Tableau_conso,Connection_node,Tableau_prod);

    %% Sauvegarde des résultats
%     handles.nbus = Bus(:,1);
%     handles.nline = (1:1:size(Courant,1))';
    
    handles.Voltage = Tension_initiale;
    handles.Current = Courant_initiale;
    handles.Losses = Pertes_initiales;
    
    handles.Config_trouvee = Config_trouvee;
    handles.Tension_finale = Tension_finale;
    handles.Pertes_finales = Pertes_finales;
    handles.Vecteur_I_fin = Vecteur_I_fin;
    

    
    Texte_2 = ['Configuration optimale : ' num2str(handles.Config_trouvee')];
    set(handles.Config_optim,'String',Texte_2);

    
    %% Visualisation

    contents = get(handles.Unit_choice,'Value');

    Min_voltage_init = min(Tension_initiale);
    Max_voltage_init = max(Tension_initiale);

    Min_voltage_fin = min(Tension_finale);
    Max_voltage_fin = max(Tension_finale);
    
    switch contents
        case 1
            set(handles.Main_results, 'Data',[[Min_voltage_init ;Max_voltage_init ;Pertes_initiales] [Min_voltage_fin ;Max_voltage_fin ;Pertes_finales]]) ;
        case 2 
            % Dans la base RD
            set(handles.Main_results, 'Data',[[Min_voltage_init*Param(1) ;Max_voltage_init*Param(1) .Pertes_initiales] [Min_voltage_fin*Param(1) ;Max_voltage_fin*Param(1) .Pertes_finales]]) ;
        case 3 
            % Dans la base MR
            set(handles.Main_results, 'Data',[[Min_voltage_init*Param(3) ;Max_voltage_init*Param(3) ;Pertes_initiales] [Min_voltage_fin*Param(3) ;Max_voltage_fin*Param(3) ;Pertes_finales]]) ;
        otherwise
    end   
end

axes(handles.axes4)

hold on
for i=1:size(handles.Line,1)
    if handles.Line(i,1) ~=1 && handles.Line(i,2) ~=1,
        if ~isempty(intersect(handles.Config_trouvee,i)),
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



% --- Executes on selection change in Unit_choice.
function Unit_choice_Callback(hObject, eventdata, handles)
% hObject    handle to Unit_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Unit_choice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Unit_choice
contents = get(handles.Unit_choice,'Value');
Tension_initiale = handles.Voltage;
Min_voltage_init = min(Tension_initiale);
Max_voltage_init = max(Tension_initiale);
Param = handles.Parametres;
Pertes_initiales = handles.Losses;

Min_voltage_fin = min(Tension_finale);
Max_voltage_fin = max(Tension_finale);
Pertes_finales =  handles.Pertes_finales;

switch contents
    case 1
        set(handles.Main_results, 'Data',[[Min_voltage_init ;Max_voltage_init ;Pertes_initiales] [Min_voltage_fin ;Max_voltage_fin ;Pertes_finales]]) ;
    case 2 
        % Dans la base RD
        set(handles.Main_results, 'Data',[[Min_voltage_init*Param(1) ;Max_voltage_init*Param(1) .Pertes_initiales] [Min_voltage_fin*Param(1) ;Max_voltage_fin*Param(1) .Pertes_finales]]) ;
    case 3 
        % Dans la base MR
        set(handles.Main_results, 'Data',[[Min_voltage_init*Param(3) ;Max_voltage_init*Param(3) ;Pertes_initiales] [Min_voltage_fin*Param(3) ;Max_voltage_fin*Param(3) ;Pertes_finales]]) ;
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
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
set(handles.Main_Results, 'Data', zeros(3,2));
cla(handles.axes1)
cla(handles.axes4)
Texte_reset = '';
set(handles.Config_optim,'String',Texte_reset);


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


cla(handles.axes1)
axes(handles.axes1)

hold on
handles.coord_int = [0;1;2;0;3;4;5;6;7;8;9;10;11;12];
for i=1:size(handles.Line,1)
    if handles.Line(i,1) ~=1 && handles.Line(i,2) ~=1,
        plot([handles.Coordonnees(handles.coord_int(handles.Line(i,1)),2),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),2)],[handles.Coordonnees(handles.coord_int(handles.Line(i,1)),3),handles.Coordonnees(handles.coord_int(handles.Line(i,2)),3)],'color','black')
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
function Main_results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Main_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(3,2));
set(hObject, 'RowName', {'Vmin(pu/kV)','Vmax(pu/kV)','Plosses (pu/kW)'}, 'ColumnName', {'Initial Value','Final Value'});


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
% hObject    handle to Node_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(1,2));
set(hObject, 'RowName', {'Connection node'}, 'ColumnName', {'Gen 3','Gen 4'});


% --- Executes during object creation, after setting all properties.
function Config_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', zeros(1,5));
set(hObject, 'RowName', {'Configuration'}, 'ColumnName', {'SW1', 'SW2', 'SW3', 'SW4', 'SW5'});


% --- Executes on button press in Apply.
function Apply_Callback(hObject, eventdata, handles)
% hObject    handle to Apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.NO = nonzeros(get(handles.Config, 'Data'));
Texte_1 = ['Configuration initiale : ' num2str(handles.NO')];
set(handles.Config_init,'String',Texte_1);


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

axes(handles.axes1)

guidata(hObject,handles)
